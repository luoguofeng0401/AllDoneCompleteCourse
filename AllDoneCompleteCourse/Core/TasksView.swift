//
//  TasksView.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/27.
//

import SwiftUI

struct TasksView: View {
    @StateObject var viewModel: TasksViewModel = .init()
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            VStack(spacing: 12) {
                searchBarView
                todoListSelectionView
                ScrollView {
                    VStack(spacing: 0) {
                        ScrollViewTopAnchorView
                        newTodoListView
                        newTodoView
                    }
                    tasksView
                        .padding(.bottom)
                }
                .onChange(of: viewModel.shouldScrollToTop) { _, shouldScrollToTop in
                    if shouldScrollToTop { viewModel.scrollToTop(scrollViewProxy) }
                }
            }
        }
        .padding(.top)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.appTheme.viewBackground)
        .toolbar { toolbarItems }
        .loadingRedacted(when: viewModel.isViewLoading)
        .showError(item: $viewModel.error)
        .showAlert(item: $viewModel.alert)
        .hideKeyboardOnTap()
        .animation(.spring, value: viewModel.shouldShowEmptyStateForTasks)
        .animation(.spring, value: viewModel.shouldShowEmptySearchStateForTasks)
        .sheet(isPresented: $viewModel.shouldShowSettings) {
            SettingsView()
        }
        .plusFab {
            viewModel.toggleNewTodoView()
        }
    }
}
    
private extension TasksView {
    var searchBarView: some View {
        TextField("Search Tasks", text: $viewModel.searchText)
            .textField(
                sfSymbol: "magnifyingglass",
                resetAction: viewModel.shouldShowResetSearch ? { viewModel.resetSearch() } : nil
            )
            .padding(.horizontal)
            .animation(.spring, value: viewModel.shouldShowResetSearch)
    }
    
    var todoListSelectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.todoLists) { todoList in
                    TodoListNameView(
                        name: todoList.name,
                        isSelected: viewModel.isTodoListSelected(todoListId: todoList.id)
                    )
                    .button(.press) {
                        viewModel.selectTodoList(todoListId: todoList.id)
                    }
                    .contextMenu {
                        deleteTodoListButton(todoList: todoList)
                    }
                    .animation(.spring, value: viewModel.selectedTodoListId)
                }
                
                addNewTodoListButton
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
    
    @ViewBuilder
    var newTodoListView: some View {
        if viewModel.shouldShowNewTodoListView {
            NewTodoListView(
                confirmAction: { name in
                    Task(handlingError: viewModel) {
                        try await viewModel.addTodoList(name: name)
                    }
                }, dismissAction: {
                    viewModel.toggleNewTodoListView()
                })
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
    
    @ViewBuilder
    var newTodoView: some View {
        if viewModel.shouldShowNewTodoView {
            NewTodoView(
                confirmAction: { name, description in
                    Task(handlingError: viewModel) {
                        try await viewModel.addTask(name: name, description: description)
                    }
                }, dismissAction: {
                    viewModel.toggleNewTodoView()
                })
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
    
    @ViewBuilder
    var tasksView: some View {
        if viewModel.shouldShowEmptyStateForTasks {
            emptyTasksView
        } else if viewModel.shouldShowEmptySearchStateForTasks {
            emptySearchTasksView
        } else {
            VStack(spacing: 12) {
                currentTasksView
                completedTasksView
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            .animation(.spring, value: viewModel.completedTaskIds)
        }
    }
    
    var emptyTasksView: some View {
        VStack(spacing: 24) {
            Image(.todoList)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 1.5)
            VStack(spacing: 8) {
                Text("An empty list, a fresh start!")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.appTheme.info)
                Text("Add your first task and task control of your day.")
                    .font(.callout)
                    .foregroundStyle(Color.appTheme.info)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(24)
    }
    
    var emptySearchTasksView: some View {
        VStack(spacing: 24) {
            Image(.search)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 1.5)
            VStack(spacing: 12) {
                Text("No tasks found")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.appTheme.info)
                let taskName = viewModel.searchText
                Text("Add \"\(taskName)\" as a new task")
                    .primaryButton()
                    .button(.press) {
                        Task(handlingError: viewModel) {
                            try await viewModel.addTask(name: taskName)
                            viewModel.resetSearch()
                        }
                    }
            }
        }
        .padding(24)
    }
    
    var currentTasksView: some View {
        ForEach(Array((viewModel.currentTasks).enumerated()), id: \.element.id) { index, task in
            TaskCompactView(
                task: task,
                isCompleted: viewModel.isTaskCompleted(taskId: task.id)) {
                    Task(handlingError: viewModel) {
                        try await viewModel.completeTask(taskId: task.id, index: index)
                    }
                }
        }
    }
    
    var completedTasksView: some View {
        ForEach(Array((viewModel.currentCompletedTasks).enumerated()), id: \.element.id) { index, task in
            TaskCompactView(
                task: task,
                isCompleted: viewModel.isTaskCompleted(taskId: task.id)) {
                    Task(handlingError: viewModel) {
                        try await viewModel.completeTask(taskId: task.id, index: index)
                    }
                }
        }
    }
    
    @ViewBuilder
    var ScrollViewTopAnchorView: some View {
        if viewModel.shouldShowNewEntryView {
            Color.clear.frame(height: 1)
                .id(viewModel.scrollViewAnchor)
        }
    }
    
    func deleteTodoListButton(todoList: TodoList) -> some View {
        Label("Delete Todo List", systemImage: "trash")
            .button {
                Task(handlingError: viewModel) {
                    try await viewModel.deleteTodoList(todoList: todoList)
                }
            }
    }
    
    var addNewTodoListButton: some View {
        Image(systemName: "plus.circle.fill")
            .foregroundStyle(Color.appTheme.alternateAccent)
            .button(.press) {
                viewModel.toggleNewTodoListView()
            }
    }
    
    @ToolbarContentBuilder
    var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .principal) { mainHeader }
        ToolbarItem(placement: .topBarTrailing) { settingButton }
    }
    
    var mainHeader: some View {
        HStack(spacing: 5) {
            Image(systemName: "checkmark.square")
                .foregroundStyle(Color.appTheme.text)
            Text(viewModel.appName)
        }
        .fontWeight(.semibold)
    }
    
    var settingButton: some View {
        Image(systemName: "gear")
            .foregroundStyle(Color.appTheme.accent)
            .fontWeight(.semibold)
            .button {
                viewModel.shouldShowSettings = true
            }
    }
}


#Preview {
    
    NavigationStack {
        TasksView()
            .injectMockData()
    }
}
