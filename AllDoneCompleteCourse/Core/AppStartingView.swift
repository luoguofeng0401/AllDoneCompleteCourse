 //
//  ContentView.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import SwiftUI
import FactoryKit

struct AppStartingView: View {
    @StateObject private var viewModel: AppStartingViewModel = .init()
    
    var body: some View {
        Group {
            switch viewModel.appState {
            case .auth:
                AuthView()
            case .app:
                NavigationStack {
                    TasksView()
                }
            }
        }
        .animation(.spring(), value: viewModel.appState)
    }
}

#Preview {
    AppStartingView()
}
