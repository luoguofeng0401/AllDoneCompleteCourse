//
//  MockTodoStore.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/26.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
final class MockTodoStore: ObservableObject, TodoStoreProtocol {
    func getTodoLists(for userId: String) async throws -> [TodoList] {
        .mocks
    }
    
    func loadTasksIntoTodoLists(todoLists: [TodoList]) async -> [TodoList] {
        .mocks
    }
    
    func addTodoList(name: String, ownerId: String) throws { }
    
    func deleteTodoList(todoListId: String) async throws { }
    
    func addTask(todoListId: String, name: String, description: String? = nil) async throws { }
    
    func deleteTask(todoListId: String, taskId: String) async throws { }
    
    func setupUser(userId: String) throws { }
    
    func todoListsPublisher(userId: String) -> AnyPublisher<[TodoList], any Error> {
        Just(.mocks)
        
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func taskPublisher(todoLists: [TodoList]) -> [String: AnyPublisher<[TodoTask], Error>] {
        var mockPublisher: [String: AnyPublisher<[TodoTask], Error>] = [:]
        for list in todoLists {
            guard let listId = list.id else { continue }
            let publisher = Just([TodoTask].mocks)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            
            mockPublisher[listId] = publisher
        }
        return mockPublisher
    }
    
    func removeAllPublishers() { }
    
}
