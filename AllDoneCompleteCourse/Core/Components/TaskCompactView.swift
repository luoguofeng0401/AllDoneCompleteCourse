//
//  TaskCompactView.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/29.
//

import SwiftUI

struct TaskCompactView: View {
    let task: TodoTask
    let isCompleted: Bool
    let onToggle: () -> ()
    
    var body: some View {
        HStack(spacing: 8) {
            toggleButtonView
            VStack(spacing: 6) {
                nameView
                descriptionView
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.appTheme.cellBackground)
        .cornerRadius(.cell)
        .shadow(.light)
    }
}

private extension TaskCompactView {
    var toggleButtonView: some View {
        Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
            .font(.title)
            .foregroundStyle(Color.appTheme.accent)
            .button(.press) {
                onToggle()
            }
    }
    
    var nameView: some View {
        Text(task.name)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    var descriptionView: some View {
        if let description = task.description {
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Image(systemName: "text.justify")
                Text(description)
                    .multilineTextAlignment(.leading)
            }
            .font(.footnote)
            .foregroundStyle(Color.appTheme.secondaryText)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

fileprivate struct Preview: View {
    @State private var tasks: [TodoTask] = .mocks
    @State private var CompletedTasks: Set<TodoTask> = .init()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                ForEach(tasks) { task in
                    TaskCompactView(task: task, isCompleted: isCompleted(task)) {
                        toggleCompletion(task)
                    }
                }
            }
            .padding()
        }
        .infinityFrame()
        .background(Color.appTheme.viewBackground)
    }
    
    func toggleCompletion(_ task: TodoTask) {
        withAnimation(.spring) {
            if CompletedTasks.contains(task) {
                CompletedTasks.remove(task)
            } else {
                CompletedTasks.insert(task)
            }
        }
    }
    
    func isCompleted(_ task: TodoTask) -> Bool {
        CompletedTasks.contains(task)
    }
}

#Preview {
    Preview()
}
