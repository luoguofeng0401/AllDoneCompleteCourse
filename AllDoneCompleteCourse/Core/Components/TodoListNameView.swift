//
//  TodoListNameView.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/29.
//

import SwiftUI

struct TodoListNameView: View {
    let name: String
    let isSelected: Bool
    var body: some View {
        Text(name)
            .fontWeight(.medium)
            .foregroundStyle(isSelected ? Color.appTheme.accentContrastText : Color.appTheme.text)
            .frame(minWidth: 60)
            .padding(12)
            .background(isSelected ? Color.appTheme.accent : Color.appTheme.cellBackground)
            .cornerRadius(.cell)
            .shadow(.light)
    }
}

fileprivate struct Preview: View {
    @State private var selectedTodo: String = "Inbox"
    let todoLists = ["Inbox", "Home", "Work", "Groceries"]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(todoLists, id: \.self) { name in
                    TodoListNameView(name: name, isSelected: selectedTodo == name)
                        .button(.press) {
                            selectTodo(name: name)
                        }
                }
            }
            .padding()
        }
        .infinityFrame()
        .background(Color.appTheme.viewBackground)
    }
    
    private func selectTodo(name: String) {
        withAnimation(.easeIn) {
            selectedTodo = name
        }
    }
}
#Preview {
    Preview()
}
