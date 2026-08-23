//
//  AppAlert.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import Foundation

struct AppAlert {
    let title: String
    let message: String
    let actionButton: ActionButton?
    
    init(title: String, message: String, actionButton: ActionButton? = nil) {
        self.title = title
        self.message = message
        self.actionButton = actionButton
    }
}

extension AppAlert {
    struct ActionButton {
        let title: String
        let action: () -> ()
    }
}

extension AppAlert {
    static var mock1: Self {
        .init(
            title: "Sing Up Error",
            message: "Make sure all fields are completed before proceeding"
        )
    }
    
    static var mock2: Self {
        .init(
            title: "Sing Out",
            message: "Are you sure you want to sign out?",
            actionButton: .init(title: "Sign Out", action: { })
        )
    }
    
    static var mock3: Self {
        .init(
            title: .empty,
            message: .empty
        )
    }
}




