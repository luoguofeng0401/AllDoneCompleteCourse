//
//  Container+Registration.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import FactoryKit

extension Container {
    var appInfoStore: Factory<AppInfoStore> {
        self { MainActor.assumeIsolated { AppInfoStore() } }.singleton
    }
    var authStore: Factory<any AuthStoreProtocol> {
        self { MainActor.assumeIsolated { AuthStore() } }.singleton
    }
    var userStore: Factory<any UserStoreProtocol> {
        self { MainActor.assumeIsolated { UserStore() } }.singleton
    }
    var todoStore: Factory<any TodoStoreProtocol> {
        self { MainActor.assumeIsolated { TodoStore() } }.singleton
    }
}
