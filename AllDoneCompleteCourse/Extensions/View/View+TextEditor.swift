//
//  View+TextEditor.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/29.
//

import SwiftUI

struct TextEditorModifier: ViewModifier {
    @Binding var text: String
    let placeholder: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            placeholderText
            textEditorView(with: content)
        }
        .background(Color.appTheme.cellBackground)
        .foregroundStyle(Color.appTheme.text)
    }
    
    @ViewBuilder
    private var placeholderText: some View {
        if text.isEmpty {
            Text(placeholder)
                .padding(.leading, 3)
                .foregroundStyle(Color(UIColor.systemGray2))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
    
    private func textEditorView(with content: Content) -> some View {
        content
        .scrollContentBackground(.hidden)
        .background(Color.appTheme.cellBackground)
        .opacity(text.isEmpty ? 0.25 : 1)
        .padding(.top, -10)
    }
}

extension View {
    func textEditor(text: Binding<String>, placeholder: String) -> some View {
        self.modifier(TextEditorModifier(text: text, placeholder: placeholder))
    }
}

fileprivate struct Preview: View {
    @State private var description: String = .empty
    
    var body: some View {
        textEditorView
            .padding()
            .infinityFrame()
            .background(Color.appTheme.viewBackground)
    }
    
    private var textEditorView: some View {
        TextEditor(text: $description)
            .textEditor(text: $description, placeholder: "Description...")
            .frame(height: 50)
    }
}

#Preview {
    Preview()
}
