//
//  AuthStore.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
final class AuthStore: ObservableObject, AuthStoreProtocol {
    @Published var authUpdate: Date = .init()
    
    var authUpdatePublisher: AnyPublisher<Date, Never> {
        $authUpdate.eraseToAnyPublisher()
    }
    
    func getAuthenticatedUser() -> AuthData? {
        guard let user = Auth.auth().currentUser else { return nil }
        return .init(user: user)
    }
    @discardableResult
    func signIn(email: String, password: String) async throws -> AuthData {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        authUpdate = .init()
        return .init(user: authDataResult.user)
    }
    
    @discardableResult
    func signUp(email: String, password: String) async throws -> AuthData {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        authUpdate = .init()
        return .init(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        authUpdate = .init()
    }
}
