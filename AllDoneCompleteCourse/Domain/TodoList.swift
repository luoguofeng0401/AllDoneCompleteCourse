//
//  TodoList.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/26.
//

import Foundation
import FirebaseFirestore

struct TodoList: Identifiable {
    @DocumentID var id: String?
    let name: String
    let ownerId: String
    @ServerTimestamp var dateCreated: Timestamp?
    
    var tasks: [TodoTask] = []
    
    init(id: String, name: String, ownerId: String) {
        self.id = id
        self.name = name
        self.ownerId = ownerId
        self.dateCreated = nil
    }
}

extension TodoList: Equatable { }

extension TodoList: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TodoList: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ownerId = "owner_id"
        case dateCreated = "date_created"
    }
}

extension TodoList {
    enum DefaultTodoList {
        case inbox
        case personal
        case work
        case groceries
    }
}

extension TodoList.DefaultTodoList: CustomStringConvertible {
    var description: String {
        switch self {
        case .inbox: "Inbox"
        case .personal: "Personal"
        case .work: "Work"
        case .groceries: "Groceries"
        }
    }
}

extension TodoList.DefaultTodoList: CaseIterable {
    static var allNames: [String] {
        Self.allCases.map { $0.description }
    }
}

extension [TodoList] {
    func firstIndex(matchingId todoListId: String) -> Int? {
        firstIndex(where: { $0.id == todoListId })
    }
    func first(matchingId todoListId: String?) -> TodoList? {
        first(where: { $0.id == todoListId })
    }
    func firstId() -> String? {
        first?.id
    }
    func contains(matchingName: String) -> Bool {
        contains(where: { $0.name.lowercased() == matchingName.lowercased() })
    }
}

extension TodoList {
    static var empty: Self {
        [Self].mocks[0]
    }
}

extension [TodoList] {
    static var mocks: Self {
        [
            .init(id: "mock_list_1", name: "Work", ownerId: "user_123"),
            .init(id: "mock_list_2", name: "Home", ownerId: "user_123"),
            .init(id: "mock_list_3", name: "Groceries", ownerId: "user_456")
        ]
    }
}
