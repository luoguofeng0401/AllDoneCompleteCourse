//
//  TasksViewModel.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/27.
//

import SwiftUI
import Combine
import FactoryKit

@MainActor
final class TasksViewModel: ObservableObject {
    @Published var searchText: String = .empty
    @Published var todoLists: [TodoList] = .init()
    @Published var selectedTodoList: TodoList?
    @Published var currentTasks: [TodoTask] = .init()
    @Published var currentCompletedTasks: [TodoTask] = .init()
    @Published var selectedTodoListId: String?
    @Published var isViewLoading: Bool = true
    @Published var shouldShowNewTodoView: Bool = false
    @Published var shouldShowNewTodoListView: Bool = false
    @Published var shouldScrollToTop: Bool = false
    @Published var shouldShowSettings: Bool = false
    @Published var completedTaskIds: Set<String> = .init()
    @Published var alert: AppAlert?
    @Published var error: Error?
    private var cancellables = Set<AnyCancellable>()
    @Injected(\.authStore) var authStore
    @Injected(\.todoStore) var todoStore
    @Injected(\.appInfoStore) var appInfoStore
    
    let scrollViewAnchor: UUID = .init()
    
    init() {
        loadData()
        setSubscribers()
    }
    
    var shouldShowResetSearch: Bool {
        !searchText.isEmpty
    }
    
    var shouldShowEmptyStateForTasks: Bool {
        currentTasks.isEmpty && currentCompletedTasks.isEmpty && searchText.isEmpty
    }
    
    var shouldShowEmptySearchStateForTasks: Bool {
        currentTasks.isEmpty && currentCompletedTasks.isEmpty && !searchText.isEmpty
    }
    
    var shouldShowNewEntryView: Bool {
        shouldShowNewTodoView || shouldShowNewTodoListView
    }
}

extension TasksViewModel {
    func isTodoListSelected(todoListId: String?) -> Bool {
        selectedTodoListId == todoListId
    }
    
    func selectTodoList(todoListId: String?) {
        selectedTodoListId = todoListId
    }
    
    func isTaskCompleted(taskId: String) -> Bool {
        completedTaskIds.contains(taskId)
    }
    
    func addTask(name: String, description: String = "") async throws {
        guard let selectedTodoListId else { return }
        try await todoStore.addTask(todoListId: selectedTodoListId, name: name, description: description.isEmpty ? nil : description)
    }
    
    func addTodoList(name: String) async throws {
        guard let userId = authStore.getAuthenticatedUser()?.uid else { return }
        guard !todoLists.contains(matchingName: name) else {
            alert = .init(
                title: "List Already Exists",
                message: "You already have a to-do list named \(name). Please choose a different name."
            )
            return
        }
        try todoStore.addTodoList(name: name, ownerId: userId)
    }
    
    func deleteTodoList(todoList: TodoList) async throws {
        guard let todoListId = todoList.id else { return }
        guard todoList.name != TodoList.DefaultTodoList.inbox.description else {
            alert = .init(
                title: "Cannot Delete Inbox",
                message: "The Inbox list is a default list and cannot be deleted."
            )
            return
        }
        try await todoStore.deleteTodoList(todoListId: todoListId)
    }
    
    func completeTask(taskId: String, index: Int) async throws {
        guard let currentTodoListId = selectedTodoListId else { return }
        completedTaskIds.insert(taskId)
        try? await Task.sleep(for: .seconds(2))
        completedTaskIds.remove(taskId)
        try await todoStore.deleteTask(todoListId: currentTodoListId, taskId: taskId)
    }
    
    func resetSearch() {
        searchText = .empty
    }
    
    func toggleNewTodoView() {
        withAnimation(.spring) {
            shouldShowNewTodoListView = false
            shouldShowNewTodoView.toggle()
        }
    }
    
    func toggleNewTodoListView() {
        withAnimation(.spring) {
            shouldShowNewTodoView = false
            shouldShowNewTodoListView.toggle()
        }
    }
    
    func scrollToTop(_ proxy: ScrollViewProxy) {
        withAnimation(.spring) {
            proxy.scrollTo(scrollViewAnchor, anchor: .top)
            shouldScrollToTop = false
        }
    }
}

private extension TasksViewModel {
    func loadData() {
        guard let userId = authStore.getAuthenticatedUser()?.uid else { return }
        Task(handlingError: self) {
            self.isViewLoading = true
            defer { self.isViewLoading = false }
            self.todoLists = try await self.todoStore.getTodoLists(for: userId)
            self .selectedTodoListId = self.todoLists.firstId()
        }
    }
    
    func setSubscribers() {
        guard let userId = authStore.getAuthenticatedUser()?.uid else { return }
        
        $searchText
            .combineLatest($selectedTodoList, $completedTaskIds)
            .sink { [weak self] searchText, selectedTodoList, completedTaskIds in
                guard let self else { return }
                (currentTasks, currentCompletedTasks) = (selectedTodoList?.tasks ?? [])
                    .filtered(by: searchText)
                    .sortedByDate()
                    .partitionedByCompletion(using: completedTaskIds)
            }
            .store(in: &cancellables)
        
        todoStore.todoListsPublisher(userId: userId)
            .sink {_ in } receiveValue: { [weak self] todoLists in
                guard let self else { return }
                Task(handlingError: self) {
                    self.todoLists = await self.todoStore.loadTasksIntoTodoLists(todoLists: todoLists)
                    self.subscribeToTasks(for: todoLists)
                }
            }
            .store(in: &cancellables)
        
        subscribeToTasks(for: todoLists)
        
        $selectedTodoListId
            .sink { [weak self] selectedTodoListId in
                guard let self else { return }
                updateCurrentTodoList(with: selectedTodoListId)
            }
            .store(in: &cancellables)
        
        $shouldShowNewTodoView
            .combineLatest($shouldShowNewTodoListView)
            .map { $0 || $1}
            .assign(to: &$shouldScrollToTop)
    }
    
    func subscribeToTasks(for todoLists: [TodoList]) {
        let taskPublishers = self.todoStore.taskPublisher(todoLists: todoLists)
        taskPublishers.forEach { todoListId, Publisher in
            Publisher
                .sink { _ in } receiveValue: { [weak self] tasks in
                    guard let self else { return }
                    updateTasks(for: todoListId, with: tasks)
                }
                .store(in: &cancellables)
        }
    }
    
    func updateTasks(for todoListId: String, with tasks: [TodoTask]) {
        guard let index = todoLists.firstIndex(matchingId: todoListId) else { return }
        var updatedTodoLists = todoLists
        updatedTodoLists[index].tasks = tasks
        todoLists = updatedTodoLists
        if selectedTodoList?.id == todoListId {
            selectedTodoList = updatedTodoLists[index]
        }
    }
    
    func updateCurrentTodoList(with selectedTodoListId: String?) {
        selectedTodoList = todoLists.first(matchingId: selectedTodoListId)
    }
}

extension TasksViewModel {
    var appName: String {
        appInfoStore.name
    }
}

extension TasksViewModel: ErrorDisplayable { }

extension TasksViewModel: AlertDisplayable { }


