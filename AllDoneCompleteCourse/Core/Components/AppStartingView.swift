 //
//  ContentView.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import SwiftUI

struct AppStartingView: View {
    @StateObject private var viewModel: AppStartingViewModel = .init()
    
    var body: some View {
        Group {
            switch viewModel.appState {
            case .auth:
                Text("Auth View")
            case .app:
                NavigationStack {
                    Text("App")
                }
            }
        }
        .animation(.spring(), value: viewModel.appState)
    }
}

#Preview {
    AppStartingView()
}
