//
//  Task+handlingError.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

extension Task where Success == Void, Failure == Error {
    @MainActor
    @discardableResult
    init(priority: TaskPriority? = nil, handlingError viewModel: ErrorDisplayable, operation: @escaping () async throws
         -> Success) {
        self.init(priority: priority) {
            do {
                try await operation()
            } catch {
                viewModel.error = error
            }
        }
    }
}
