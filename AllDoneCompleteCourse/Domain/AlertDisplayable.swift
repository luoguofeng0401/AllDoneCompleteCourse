//
//  AlertDisplayable.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import Foundation

@MainActor
protocol AlertDisplayable {
    var alert: AppAlert? { get set }
}
