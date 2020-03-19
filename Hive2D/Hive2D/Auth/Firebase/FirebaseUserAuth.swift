//
//  FirebaseUserAuth.swift
//  Hive2D
//
//  Created by John Phua on 19/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import FirebaseAuth

class FirebaseUserAuth: UserAuth {
    weak var delegate: UserAuthDelegate?

    static var userId: String?

    func logIn() {
        Auth.auth().signInAnonymously { [weak self] authResult, _ in
            guard let self = self else {
                return
            }
            guard let user = authResult?.user else {
                self.delegate?.logInFailure()
                return
            }
            UserAuthState.shared.set(userId: user.uid)
            self.delegate?.logInSuccess(userId: user.uid)
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            delegate?.logOutFailure()
            return
        }
        UserAuthState.shared.set(userId: nil)
        delegate?.logOutSuccess()
    }

}
