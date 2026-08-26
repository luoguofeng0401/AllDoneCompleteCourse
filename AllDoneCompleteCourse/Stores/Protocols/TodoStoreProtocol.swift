//
//  TodoStoreProtocol.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/26.
//

import Foundation
import Combine

@MainActor
protocol TodoStoreProtocol: ObservableObject {
    func getTodoLists(for userId: String) async throws -> [TodoList]
    func loadTaskIntoTodoLists(todoLists: [TodoList]) async -> [TodoList]
    
    func addTodoList(name: String ,ownerId: String) throws
    func deleteTodoList(todoListId: String) async throws
    func addTask(todoListId: String, name: String, description:String?) async throws
    func deleteTask(todoListId: String, taskId: String) async throws
    
    func setupUser(userId: String) throws
    
    func todoListPublisher(userId: String) -> AnyPublisher<[TodoList], Error>
    func taskPublisher(todoLists: [TodoList]) -> [String: AnyPublisher<[TodoTask], Error>]
    func removeAllPublishers()
}
