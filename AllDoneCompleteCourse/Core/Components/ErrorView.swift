//
//  ErrorView.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import SwiftUI

struct ErrorView: View {
    @Binding var error: Error?
    
    private var appError: AppError {
        error.asAppError()
    }
    
    var body: some View {
        VStack(spacing: 16) {
            heading
            maeesgeView
            understandButtonView
        }
        .padding()
        .background(Color.appTheme.cellBackground)
        .cornerRadius(.cell)
        .frame(width: UIScreen.main.bounds.width / 1.2)
    }
}

private extension ErrorView {
    var heading: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(appError.title)
        }
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundStyle(Color.appTheme.error)
    }

    
    var maeesgeView: some View {
        Text(appError.message)
            .foregroundStyle(Color.appTheme.secondaryText)
            .multilineTextAlignment(.center)
    }
    
    var understandButtonView: some View {
        Text("Understand")
            .destructiveButton()
            .button(.press) {
                dismiss()
            }
    }
}

private extension ErrorView {
    func dismiss() {
        error = nil
    }
}

fileprivate struct Preview: View {
    @State private var error: Error? = AuthError.mock
    
    var body: some View {
        ErrorView(error: $error)
            .infinityFrame()
            .background(Color.appTheme.info)
    }
}

#Preview {
    Preview()
}
