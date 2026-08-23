//
//  View+hideKeyboardOnTap.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        self
            .onTapGesture {
            hideKeyboard()
        }
    }
}
