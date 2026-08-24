//
//  View+showAlert.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import SwiftUI

extension View {
    func showAlert(item: Binding<AppAlert?>) -> some View {
        showModal(item: item) { alert in
            AlertView(alert: item)
                .transition(
                    .move(edge: .bottom)
                    .combined(with: .opacity)
                )
        }
    }
}

fileprivate struct Preview: View {
    @State var alert: AppAlert?
    
    var body: some View {
        Text("Show Alert")
            .primaryButton()
            .button(.press) {
                alert = AppAlert.mock1
            }
            .padding()
            .infinityFrame()
            .background(Color.appTheme.viewBackground)
            .showAlert(item: $alert)
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
