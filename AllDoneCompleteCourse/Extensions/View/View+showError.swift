//
//  View+showError.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import SwiftUI

extension View {
    func showError(item: Binding<Error?>) -> some View {
        showModal(item: item) { error in
            ErrorView(error: item)
                .transition(
                    .move(edge: .bottom)
                    .combined(with: .opacity)
                )
        }
    }
}

fileprivate struct Preview: View {
    @State private var error: Error?
    
    var body: some View {
        Text("Show  Error")
            .primaryButton()
            .button(.press) {
                error = AuthError.mock
            }
            .padding()
            .infinityFrame()
            .background(Color.appTheme.viewBackground)
            .showError(item: $error)
    }
}

#Preview {
    Preview()
        .preferredColorScheme(.light)
}

#Preview {
    Preview()
        .preferredColorScheme(.dark)
}
