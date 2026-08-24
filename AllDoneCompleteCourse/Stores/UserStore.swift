//
//  UserStore.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import Foundation
import FirebaseFirestore

@MainActor
final class UserStore: UserStoreProtocol {
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: AppUser) throws {
        try userDocument(userId: user.userId).setData(from: user)
    }
    
    func getUser(userId: String) async throws -> AppUser {
        try await userDocument(userId: userId).getDocument(as: AppUser.self)
    }
}
