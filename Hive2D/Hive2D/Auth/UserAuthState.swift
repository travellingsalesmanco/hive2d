//
//  UserAuthState.swift
//  Hive2D
//
//  Created by John Phua on 19/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

// Singleton AuthState object to be used to identify the current user
class UserAuthState {
    static let shared = UserAuthState()

    private let queue = DispatchQueue(label: "tsco.Hive2D.userAuthState", attributes: .concurrent)
    private var userId: String?

    private init() {}

    func set(userId: String?) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            self.userId = userId
        }
    }

    func get() -> String? {
        queue.sync {
            self.userId
        }
    }

    var isLoggedIn: Bool {
        queue.sync {
            self.userId != nil
        }
    }

}
