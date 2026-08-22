//
//  AuthData.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import Foundation
import FirebaseAuth

struct AuthData {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
    
    init(email: String) {
        uid = UUID().uuidString
        self.email = email
    }
}

extension AuthData {
    static var mock: Self {
        .init(email: "luoguofeng01@gmail.com")
    }
}
