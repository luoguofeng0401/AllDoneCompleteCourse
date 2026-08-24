//
//  AppError.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import Foundation

protocol AppError: LocalizedError {
    var title: String { get }
    var message: String { get }
    static func fromFirebaseError(_ error: NSError) -> AppError
}
