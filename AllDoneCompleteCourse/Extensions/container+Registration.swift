//
//  container+Registration.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import Foundation
import FactoryKit

extension Container {
    var appInfoStore: Factory<AppInfoStore> {
        self { MainActor.assumeIsolated { AppInfoStore() } }.singleton
    }
}
