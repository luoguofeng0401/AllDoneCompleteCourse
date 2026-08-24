//
//  UserStoreProtocol.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import Foundation

protocol UserStoreProtocol {
    func createNewUser(user: AppUser) throws
    func getUser(userId: String) async throws -> AppUser
}
