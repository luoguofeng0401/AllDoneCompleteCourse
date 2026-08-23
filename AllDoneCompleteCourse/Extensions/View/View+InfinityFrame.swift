//
//  View+InfinityFrame.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import SwiftUI

extension View {
    func infinityFrame() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
