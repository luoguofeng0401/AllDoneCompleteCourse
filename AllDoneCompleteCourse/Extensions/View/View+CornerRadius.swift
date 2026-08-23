//
//  View+CornerRadius.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import SwiftUI

struct AppCornerRadius {
    let value: CGFloat
}

extension View {
    func cornerRadius(_ cornerRadius: AppCornerRadius) -> some View {
        self
            .cornerRadius(cornerRadius.value)
    }
}

extension AppCornerRadius {
    static var overall: Self = .init(value: 8)
    static var cell: Self = .init(value: 8)
    static var button: Self = .init(value: 8)
    static var textfield: Self = .init(value: 8)
}

fileprivate struct Preview: View {
    var body: some View {
        Text("Calculate")
            .foregroundStyle(Color.appTheme.accentContrastText)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.appTheme.accent)
            .cornerRadius(.button)
            .button(.press) {
                
            }
            .padding()
            .infinityFrame()
            .background(Color.appTheme.viewBackground)
    }
}

#Preview {
    Preview()
}
