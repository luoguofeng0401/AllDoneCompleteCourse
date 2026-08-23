//
//  AuthViewModel.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import SwiftUI
import Combine
import FactoryKit

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var currentAuthType: AuthType = .signIn
    @Published var firstName: String = .empty
    @Published var lastName: String = .empty
    @Published var email: String = .empty
    @Published var password: String = .empty
    @Published var forgotPasswordSuccess: Bool = false
    @Published var error: Error?
    @Published var alert: AppAlert?
    @Injected(\.authStore) var authStore
//    @Injected(\.userStore) var userStore
//    @Injected(\.todoStore) var todoStore
}

extension AuthViewModel {
    var canSignIn: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var canSignUp: Bool {
        !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    var canResetPassword: Bool {
        !email.isEmpty
    }
    
    func toggleAuthType() {
        withAnimation(.spring) {
            currentAuthType = currentAuthType.isSignIn ? .signUp : .signIn
        }
    }
    
    func authenticate() async throws {
        switch currentAuthType {
        case .signIn:
            try await signIn()
        case .signUp:
            try await signUp()
        }
    }
    
    func resetPassword() async throws {
        guard canResetPassword else {
            alert = .init(
                title: "Reset Password Error",
                message: "Please enter your email to reset your password."
            )
            return
        }
        try await authStore.resetPassword(email: email)
        triggerForgotPasswordSuccess()
    }
}

private extension AuthViewModel {
    func signIn() async throws {
        guard canSignIn else {
            alert = .init(
                title: "Sign In Error",
                message: "Plaese fill in all required field."
            )
            return
        }
        try await authStore.signIn(email: email, password: password)
    }
    
    func signUp() async throws {
        guard canSignUp else {
            alert = .init(
                title: "Sign Up Error",
                message: "Make sure all field are completed before proceeding."
            )
            return
        }
        try await authStore.signUp(email: email, password: password)
        try creatUserProfild()
        try creatListSetup()
    }
    
    func creatUserProfild() throws {
        guard let userId = authStore.getAuthenticatedUser()?.uid else { return }
//        try userStore.createNewUser(user: .init(
//            userId: userId,
//            firstName: firstName,
//            lastName: lastName,
//            email: email,
//            dateCreated: .init())
//        )
    }
    
    func creatListSetup() throws {
        guard let userId = authStore.getAuthenticatedUser()?.uid else { return }
    }
    
    func triggerForgotPasswordSuccess() {
        forgotPasswordSuccess = true
        Task {
            try await Task.sleep(for: .seconds(3))
            await MainActor.run {
                self.forgotPasswordSuccess = false
            }
        }
    }
}

extension AuthViewModel: ErrorDisplayable { }

extension AuthViewModel: AlertDisplayable { }
