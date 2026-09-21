//
//  AlertView.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import SwiftUI

struct AlertView: View {
    @Binding var alert: AppAlert?
    
    var appAlert: AppAlert {
        alert ?? .empty
    }
    
    var body: some View {
        VStack(spacing: 16) {
            headingView
            messageView
            actionButtons
        }
        .padding(12)
        .background(Color.appTheme.cellBackground)
        .cornerRadius(.cell)
        .frame(width: UIScreen.main.bounds.width / 1.2)
    }
}

private extension AlertView {
    var headingView: some View {
        HStack(spacing: 5) {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(appAlert.title)
        }
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundStyle(Color.appTheme.error)
    }
    var messageView: some View {
        Text(appAlert.message)
            .foregroundStyle(Color.appTheme.secondaryText)
            .multilineTextAlignment(.center)
    }
    
    var actionButtons: some View {
        HStack(spacing: 5) {
            if let actionButton = appAlert.actionButton {
                cancelButtonView
                Text(actionButton.title)
                    .destructiveButton()
                    .button(.press) {
                        actionButton.action()
                    }
            } else {
                understandButtonView
            }
        }
    }
    
    var understandButtonView: some View {
        Text("Understand")
            .destructiveButton()
            .button(.press) {
                dismiss()
            }
    }
    
    var cancelButtonView: some View {
        Text("Cancel")
            .plainButton()
            .button(.press) {
                dismiss()
            }
    }
}

private extension AlertView {
    func dismiss() {
        alert = nil
    }
}

fileprivate struct Preview: View {
    @State private var simpleAlert: AppAlert? = .mock1
    @State private var customActionAlert: AppAlert? = .mock2
    
    var body: some View {
        VStack(spacing: 20) {
            AlertView(alert: $simpleAlert)
            AlertView(alert: $customActionAlert)
        }
        .infinityFrame()
        .background(Color.appTheme.info)
    }
}
#Preview {
    Preview()
}
