//
//  TodoTask.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/26.
//

import Foundation

struct TodoTask: Identifiable {
    let id: String
    let name: String
    let dateCreated: Date
    let description: String?
    
    init(id: String, name: String, description: String? = nil) {
        self.id = id
        self.name = name
        self.dateCreated = .init()
        self.description = description
    }
}

extension TodoTask: Equatable { }

extension TodoTask: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TodoTask: Codable {
    enum  CodingKeys: String, CodingKey {
        case id
        case name
        case dateCreated = "date_created"
        case description
    }
}

extension [TodoTask] {
    func filtered(by searchText: String) -> [TodoTask] {
        let lowercasedSearch = searchText.lowercased()
        return self.filter {
            searchText.isEmpty ||
            $0.name.lowercased().contains(lowercasedSearch) ||
            ($0.description?.lowercased().contains(lowercasedSearch) ?? false)
        }
    }
}

extension [TodoTask] {
    func partitionedByCompletion(using completedTaskIds: Set<String>) -> (completed: [TodoTask], incomplete: [TodoTask]) {
        let incompleted = self.filter {!completedTaskIds.contains($0.id) }
        let complete = self.filter { completedTaskIds.contains($0.id) }
        return (incompleted, complete)
    }
}

extension [TodoTask] {
    func sortedByDate() -> [TodoTask] {
        self.sorted { $0.dateCreated < $1.dateCreated}
    }
}

extension TodoTask {
    static var mock: Self {
        [Self].mocks[0]
    }
}

extension [TodoTask] {
    static var mocks: Self {
        [
            .init(id: "mock_task_1", name: "Get groceries", description: "Go to Walmark and Target"),
            .init(id: "mock_task_2", name: "Call Mom", description: nil),
            .init(id: "mock_task_3", name: "Go for a walk", description: nil),
            .init(id: "mock_task_4", name: "Do maths", description: "Do maths homework"),
        ]
    }
}
