//
//  AppStartingViewModel.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import SwiftUI
import Combine
import FactoryKit

@MainActor
final class AppStartingViewModel: ObservableObject {
    @Published var appState: AppState = .auth
    @Injected(\.authStore) var authStore
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        updateAppState()
        setSubscribers()
    }
    

}

private extension AppStartingViewModel {
    func setSubscribers() {
        authStore.authUpdatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
            }
            .store(in: &cancellables)
        }
    
    func getAppState() -> AppState{
        authStore.getAuthenticatedUser() == nil ? .auth : .app
    }
    
    func updateAppState() {
        let currentAppState = getAppState()
        
        if appState != currentAppState {
            self.appState = currentAppState
        }
    }
}
