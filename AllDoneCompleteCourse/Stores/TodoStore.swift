//
//  TodoStore.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/26.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
final class TodoStore: ObservableObject, TodoStoreProtocol {
    private let todoListsCollection = Firestore.firestore().collection("todo_Lists")
    
    private func todoListDocument(todoListId: String) -> DocumentReference {
        todoListsCollection.document(todoListId)
    }
    
    private func tasksCollection(todoListId: String) -> CollectionReference {
        todoListDocument(todoListId: todoListId).collection("tasks")
    }
    
    private func getAllTodoListsForUserIdQuery(userId: String)
    -> Query {
        todoListsCollection
            .whereField(TodoList.CodingKeys.ownerId.rawValue, isEqualTo: userId)
            .order(by: TodoList.CodingKeys.name.rawValue, descending: false)
    }
    
    private var todoListsListener: ListenerRegistration? = nil
    private var tasksListeners: [String: ListenerRegistration] = [:]
    
    func getTodoLists(for userId: String) async throws -> [TodoList] {
        let todoLists = try await getAllTodoListsForUserIdQuery(userId: userId)
            .getDocuments(as: TodoList.self)
            .withInboxFirst()
        let updatedTodoLists = await loadTaskIntoTodoLists(todoLists: todoLists)
        return updatedTodoLists
        
    }
    
    func loadTaskIntoTodoLists(todoLists: [TodoList]) async -> [TodoList] {
        var updatedTodoLists = todoLists
        await withTaskGroup(of: (Int, [TodoTask]).self) { group in
            for (index, todoList) in  todoLists.enumerated() {
                guard let todoListId = todoList.id else { continue }
                group.addTask {
                    let tasks = try? await self.tasksCollection(todoListId: todoListId).getDocuments(as: TodoTask.self)
                    return (index, tasks ?? [])
                }
            }
            for await (index, tasks) in group {
                updatedTodoLists[index].tasks = tasks
            }
        }
        
        return updatedTodoLists.withInboxFirst()
    }
    
    func addTodoList(name: String, ownerId: String) throws {
        let newTodoListDocument = todoListsCollection.document()
        let newTodoList = TodoList(id: newTodoListDocument.documentID, name: name, ownerId: ownerId)
        try newTodoListDocument.setData(from: newTodoList)
    }
    
    func deleteTodoList(todoListId: String) async throws {
        try await deleteAllTasksInTodoList(todoListId: todoListId)
        try await todoListDocument(todoListId: todoListId).delete()
    }
    
    private func deleteAllTasksInTodoList(todoListId: String) async throws {
        let tasksSnapshot = try await tasksCollection(todoListId: todoListId).getDocuments()
        for document in tasksSnapshot.documents {
            try await document.reference.delete()
        }
    }
    
    func addTask(todoListId: String, name: String, description: String? = nil) async throws {
        let newTaskDocument = tasksCollection(todoListId: todoListId).document()
        let newTask = TodoTask(id: newTaskDocument.documentID, name: name, description: description)
        try newTaskDocument.setData(from: newTask)
    }
    
    func deleteTask(todoListId: String, taskId: String) async throws {
        try await tasksCollection(todoListId: todoListId).document(taskId).delete()
    }
    
    func setupUser(userId: String) throws {
        try addDefaulfTodoLists(userId: userId)
    }
    
    private func addDefaulfTodoLists(userId: String) throws {
        let defaultTodoLists = TodoList.DefaultTodoList.allNames
        for listName in defaultTodoLists {
            try addTodoList(name: listName, ownerId: userId)
        }
    }
    
    func todoListPublisher(userId: String) -> AnyPublisher<[TodoList], Error> {
        addListenerForTodoLists(userId: userId)
    }
    
    func taskPublisher(todoLists: [TodoList]) -> [String: AnyPublisher<[TodoTask], Error>] {
        addListenerForTodoLists(todoLists: todoLists)
    }
    
    private func addListenerForTodoLists(userId: String) -> AnyPublisher<[TodoList], any Error> {
        let (publisher, listener) = getAllTodoListsForUserIdQuery(userId: userId)
            .addSnapshotListener(as: TodoList.self)
        self.todoListsListener = listener
        return publisher
    }
    
    private func addListenerForTodoLists(todoLists: [TodoList]) -> [String: AnyPublisher<[TodoTask], Error>] {
        var taskPublishers: [String: AnyPublisher<[TodoTask], Error>] = [:]
        for todoList in todoLists {
            guard let todoListId = todoList.id else { continue }
            tasksListeners[todoListId]?.remove()
            let (publisher, listener) = tasksCollection(todoListId: todoListId)
                .addSnapshotListener(as: TodoTask.self)
            tasksListeners[todoListId] = listener
            taskPublishers[todoListId] = publisher
        }
        return taskPublishers
    }
    
    func removeAllPublishers() {
        todoListsListener?.remove()
        todoListsListener = nil
        for (_, listener) in  tasksListeners {
            listener.remove()
        }
        tasksListeners.removeAll()
    }
}

fileprivate extension [TodoList] {
    func withInboxFirst() -> [TodoList] {
        guard let inboxIndex = firstIndex(where: { $0.name == TodoList.DefaultTodoList.inbox.description }) else { return self }
        var updatedTodoList = self
        let inboxTodoList = updatedTodoList.remove(at: inboxIndex)
        updatedTodoList.insert(inboxTodoList, at: 0)
        return updatedTodoList
    }
}


