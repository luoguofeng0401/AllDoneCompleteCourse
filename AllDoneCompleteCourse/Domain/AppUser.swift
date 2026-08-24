//
//  AppUser.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import Foundation
import FirebaseFirestore

struct AppUser {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    let dateCreated: Timestamp?
    
    init(userId: String, firstName: String, lastName: String, email: String, dateCreated: Timestamp?) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.dateCreated = dateCreated
    }
}

extension AppUser {
    static var empty: Self {
        .init(userId: .empty, firstName: .empty , lastName: .empty, email: .empty, dateCreated: nil)
    }
    
    static var mock: Self {
        .init(userId: "mock_user_1", firstName: "John", lastName: "Blitz", email: "john.blitz@gmail.com", dateCreated: .init())
    }
}

extension AppUser: Codable {
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case dateCreated = "date_created"
    }
}
