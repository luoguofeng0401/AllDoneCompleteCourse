//
//  ErrorDisplayable.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import Foundation

@MainActor
protocol ErrorDisplayable: AnyObject {
    var error: Error? { get set }
}
