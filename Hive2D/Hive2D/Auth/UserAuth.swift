//
//  UserAuth.swift
//  Hive2D
//
//  Created by John Phua on 19/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

protocol UserAuth {
    var delegate: UserAuthDelegate? { get set }
    // Currently needs no parameters as we are signing in anonymously
    // Communicates result through delegate
    func logIn()
    func logOut()
}
