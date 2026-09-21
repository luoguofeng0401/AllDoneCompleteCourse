//
//  NewTodoView.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/29.
//

import SwiftUI

struct NewTodoView: View {
    @State private var name: String = .empty
    @State private var description: String = .empty
    @State private var shouldDismissAfterCOnfirmation: Bool = true
    var confirmAction: (String, String) -> ()
    var dismissAction: () -> ()
    
    var body: some View {
        VStack(spacing: 5) {
            newTaskView
            textEditorView
            actionButtons
        }
        .background(Color.appTheme.cellBackground)
        .cornerRadius(.cell)
        .shadow(.regular)
    }
    
    var shouldAllowConfirm: Bool {
        !name.isEmpty
    }
}

private extension NewTodoView {
    var newTaskView: some View {
        HStack(spacing: 5) {
            Image(systemName: "square")
                .frame(width: 30)
            TextField("New Task", text: $name)
        }
        .foregroundStyle(Color.appTheme.accent)
        .padding([.horizontal, .top], 12)
        .background(Color.appTheme.cellBackground)
    }
    
    var textEditorView: some View {
        HStack(alignment: .top, spacing: 2) {
            Image(systemName: .empty)
                .frame(width: 30)
                .opacity(0)
            
            TextEditor(text: $description)
                .textEditor(text: $description, placeholder: "Description...")
                .frame(height: 50)
        }
        .foregroundStyle(Color.appTheme.accent)
        .padding(12)
        .background(Color.appTheme.cellBackground)
    }
    
    var actionButtons: some View {
        HStack(spacing: 10) {
            dismissButton
            Spacer()
            mainButtons
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
    }
    
    var mainButtons: some View {
        HStack(spacing: 12) {
            Image(systemName: "rectangle.stack")
                .font(.title2)
                .foregroundStyle(shouldDismissAfterCOnfirmation ? Color.appTheme.text : Color.appTheme.alternateAccent)
                .cornerRadius(.button)
                .shadow(.regular)
                .button(.press) {
                    toggleDismissAfterConfirmation()
                }
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(Color.appTheme.accent)
                .button(.press) {
                    confirmAction(name, description)
                    resetValues()
                    if shouldDismissAfterCOnfirmation {
                        dismissAction()
                    }
                }
                .disabled(!shouldAllowConfirm)
                .opacity(shouldAllowConfirm ? 1 : 0.5)
                .animation(.spring, value: shouldAllowConfirm)
        }
    }
    
    var dismissButton: some View {
        Image(systemName: "chevron.up")
            .font(.title2)
            .fontWeight(.light)
            .foregroundStyle(Color.appTheme.destructive)
            .button {
                dismissAction()
            }
    }
}

private extension NewTodoView {
    func resetValues() {
        name = .empty
        description = .empty
    }
    
    func toggleDismissAfterConfirmation() {
        withAnimation(.bouncy) {
            shouldDismissAfterCOnfirmation.toggle()
        }
    }
}

fileprivate struct Preview: View {
    var body: some View {
        NewTodoView(confirmAction: {_,_ in}, dismissAction: {})
            .padding()
            .infinityFrame()
            .background(Color.appTheme.viewBackground)
    }
}

#Preview {
    Preview()
}
