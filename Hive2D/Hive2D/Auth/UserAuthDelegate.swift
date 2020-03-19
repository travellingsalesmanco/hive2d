//
//  UserAuthDelegate.swift
//  Hive2D
//
//  Created by John Phua on 19/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

protocol UserAuthDelegate: AnyObject {
    func logInSuccess(userId: String)
    func logOutSuccess()
    func logInFailure()
    func logOutFailure()
}
