//
//  NewTodoListView.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/29.
//

import SwiftUI

struct NewTodoListView: View {
    @State private var name: String = .empty
    @State private var shouldDismissAfterConfirmation: Bool = false
    var confirmAction: (String) -> ()
    var dismissAction: () -> ()
    
    var body: some View {
        VStack(spacing: 5) {
            newTaskView
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

private extension NewTodoListView {
    var newTaskView: some View {
        HStack(spacing: 5) {
            Image(systemName: "list.dash")
                .frame(width: 30)
            TextField("New Todo List", text: $name)
        }
        .foregroundStyle(Color.appTheme.accent)
        .padding([.horizontal, .top], 12)
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
    
    var dismissButton: some View {
        Image(systemName: "chevron.up")
            .font(.title2)
            .fontWeight(.light)
            .foregroundStyle(Color.appTheme.destructive)
            .button {
                dismissAction()
            }
    }
    
    var mainButtons: some View {
        HStack(spacing: 12) {
            Image(systemName: "rectangle.stack")
                .font(.title2)
                .foregroundStyle(shouldDismissAfterConfirmation ? Color.appTheme.text : Color.appTheme.alternateAccent)
                .cornerRadius(.button)
                .shadow(.regular)
                .button {
                    toggleDismissAfterConfirmation()
                }
            
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(Color.appTheme.accent)
                .button(.press) {
                    confirmAction(name)
                    resetValues()
                    if shouldDismissAfterConfirmation {
                        dismissAction()
                    }
                }
                .disabled(!shouldAllowConfirm)
                .opacity(shouldAllowConfirm ? 1 : 0.5)
                .animation(.spring, value: shouldAllowConfirm)
        }
    }
}
private extension NewTodoListView {
    func resetValues() {
        name = .empty
    }
    
    func toggleDismissAfterConfirmation() {
        withAnimation(.bouncy) {
            shouldDismissAfterConfirmation.toggle()
        }
    }
}

fileprivate struct Preview: View {
    var body: some View {
        NewTodoListView(confirmAction: {_ in}, dismissAction: { })
            .padding()
            .infinityFrame()
            .background(Color.appTheme.viewBackground)
    }
}
    

#Preview {
    Preview()
}
