//
//  SettingsViewModel.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/31.
//

import SwiftUI
import Combine
import FactoryKit

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var user: AppUser = .empty
    @Published var shouldDismiss: Bool = false
    @Published var error: Error?
    @Published var alert: AppAlert?
    @Injected(\.authStore) var authStore
    @Injected(\.userStore) var userStore
    @Injected(\.appInfoStore) var appInfoStore
    
    init() {
        Task(handlingError: self) {
            try await self.loadUserData()
        }
    }
}

extension SettingsViewModel {
    func singOutAttempt() {
        alert = .init(
            title: "Sign out",
            message: "Are you sure you want to Sign out?",
            actionButton: .init(
                title: "Sign out",
                action: {
                    self.signOut()
                    
                }
            ))
    }
}

private extension SettingsViewModel {
    func loadUserData() async throws {
        guard let userId = authStore.getAuthenticatedUser()?.uid else { return }
        user = try await userStore.getUser(userId: userId)
    }
    
    func signOut() {
        Task(handlingError: self) {
            self.shouldDismiss = true
            try? await Task.sleep(for: .seconds(0.5))
            try self.authStore.signOut()
        }
    }
}

extension SettingsViewModel {
    var appName: String {
        appInfoStore.name
    }
    
    var appDescription: String {
        appInfoStore.description
    }
    
    var userInfoData: [InfoData] {
        [
            .init(name: "First Name", info: user.firstName.capitalized),
            .init(name: "Last Name", info: user.lastName.capitalized),
            .init(name: "Email", info: user.email.lowercased()),
        ]
    }
    
    var appInfoData: [InfoData] {
        [
            .init(name: "Version", info: appInfoStore.version),
            .init(name: "Compatibility", info: appInfoStore.compatibillity),
            .init(name: "Developer", info: appInfoStore.developer)
        ]
    }
}

extension SettingsViewModel: ErrorDisplayable {
    
}

extension SettingsViewModel: AlertDisplayable {
    
}
