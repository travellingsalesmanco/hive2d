//
//  FirebaseGame.swift
//  Hive2D
//
//  Created by John Phua on 17/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Firebase

class FirebaseGame: GameNetworking {
    var gameId: String

    private(set) var gameActionQueue: GameActionQueue
//    private let gameRef: DatabaseReference

    init(gameId: String) {
        self.gameId = gameId
        gameActionQueue = GameActionQueue(gameId: gameId)
        // TODO: add firebase listener to grab actions
    }

    func sendGameAction(_: GameAction) {
        // TODO: send to firebase
        return
    }
}
