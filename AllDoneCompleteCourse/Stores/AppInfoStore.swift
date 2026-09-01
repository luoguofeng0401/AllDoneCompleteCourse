//
//  AppInfoStore.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import Foundation

final class AppInfoStore {
    let name: String = "AllDone"
    let description: String = "AllDone is a must app for anyone who want to get their life organized. It help you manage your tasks."
    let developer: String = "Guofeng Luo"
    var version: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "_"
    }
    var compatibillity: String {
        if let minVersion = Bundle.main.infoDictionary?["MinimumOSVersion"] as? String {
            return "iOS \(minVersion)+"
        }
        return "_"
        
    }
}
