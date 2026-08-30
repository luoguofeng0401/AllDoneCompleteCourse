//
//  View+PlusFab.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/30.
//

import SwiftUI

struct PlusFabModifier: ViewModifier {
    let action: () -> ()
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Image(systemName: "plus")
                    .font(.title.weight(.medium))
                    .foregroundStyle(Color.appTheme.accentContrastText)
                    .padding(16)
                    .background(Color.appTheme.accent)
                    .clipShape(Circle())
                    .shadow(.heavy)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(8)
                    .button(.press) {
                        action()
                    }
            )
    }
}

extension View {
    func plusFab(action: @escaping () -> ()) -> some View {
        self.modifier(PlusFabModifier(action: action))
    }
}

fileprivate struct Preview: View {
    @State private var shouldShowSheet: Bool = false
    
    var body: some View {
        preview
            .plusFab {
                showSheet()
            }
            .sheet(isPresented: $shouldShowSheet) {
                sheetView
            }
    }
    
    private var preview: some View {
        Text("Tap Plus-Fab to show Sheet")
            .font(.title3.weight(.medium))
            .foregroundStyle(Color.appTheme.accent)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appTheme.viewBackground)
    }
    
    private var sheetView: some View {
        Text("Sheet Prensented")
            .font(.title.weight(.medium))
            .foregroundStyle(Color.appTheme.success)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appTheme.viewBackground)
    }
    
    private func showSheet() {
        shouldShowSheet = true
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
