//
//  View+TextField.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import SwiftUI

extension View {
    func textField(sfSymbol: String, resetAction:( () -> () )? = nil ) -> some View {
        HStack(spacing: 5) {
            Image(systemName: sfSymbol)
                .frame(width: 30)
            self
            if let resetAction {
                Image(systemName: "xmark.circle")
                    .foregroundStyle(Color.appTheme.destructive)
                    .button(.press) {
                        resetAction()
                    }
            }
        }
        .foregroundStyle(Color.appTheme.accent)
        .padding(12)
        .background(Color.appTheme.cellBackground)
        .cornerRadius(.textfield)
    }
}
