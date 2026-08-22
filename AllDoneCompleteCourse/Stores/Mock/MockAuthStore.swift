//
//  MockAuthStore.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import Foundation
import Combine

@MainActor
final class MockAuthStore: ObservableObject, AuthStoreProtocol {
    @Published var authUpdate: Date = .init()
    
    var authUpdatePublisher: AnyPublisher<Date, Never> {
        $authUpdate.eraseToAnyPublisher()
    }
    
    func getAuthenticatedUser() -> AuthData? {
        .mock
    }
    
    func signIn(email: String, password: String) async throws -> AuthData {
        .mock
    }
    
    func signUp(email: String, password: String) async throws -> AuthData {
        .mock
    }
    
    func resetPassword(email: String) async throws { }
    
    func signOut() throws { }
    
    
}
