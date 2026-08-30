//
//  View+LoadingRedacted.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/30.
//

import SwiftUI

struct LoadingRedactedModifier: ViewModifier {
    let condition: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if condition {
                LoadingRedactedView
            }
        }
    }
    
    private var LoadingRedactedView: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                ForEach([TodoTask].mocks) { task in
                    TaskCompactView(task: task, isCompleted: Bool.random()) { }
                }
            }
            .padding()
        }
        .infinityFrame()
        .background(Color.appTheme.viewBackground)
        .redacted(reason: .placeholder)
        .disabled(true)
    }
}

extension View {
    func loadingRedacted(when condition: Bool) -> some View {
        modifier(LoadingRedactedModifier(condition: condition))
    }
}
