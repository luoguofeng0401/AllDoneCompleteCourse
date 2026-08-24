//
//  MockUserStore.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import Foundation

@MainActor
final class MockUserStore: UserStoreProtocol {
    func createNewUser(user: AppUser) throws {
        
    }
    
    func getUser(userId: String) throws -> AppUser {
        .mock
    }
}
