//
//  Binding+isNotNil.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import SwiftUI

extension Binding {
    func isNotNil<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        .init {
            wrappedValue != nil
        } set: {
            if !$0 {
                wrappedValue = nil
            }
        }
    }
}
