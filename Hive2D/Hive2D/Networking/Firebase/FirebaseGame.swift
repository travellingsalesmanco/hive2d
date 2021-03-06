//
//  FirebaseGame.swift
//  Hive2D
//
//  Created by John Phua on 17/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Firebase

class FirebaseGame: GameNetworking {
    private(set) var gameActionQueue: GameActionQueue
    private let gameRef: DatabaseReference
    private var disconnectRef: DatabaseReference?
    private var gameHandle: DatabaseHandle?
    init(gameId: String) {
        gameActionQueue = GameActionQueue(gameId: gameId)
        gameRef = FirebaseConstants.gameRef.child(gameId)
        gameHandle = gameRef.observe(.childAdded, with: { [weak self] snapshot in
            guard let self = self else {
                return
            }
            self.handleAddAction(actionSnapshot: snapshot)
        })
    }

    deinit {
        guard let gameHandle = gameHandle else {
            return
        }
        gameRef.removeObserver(withHandle: gameHandle)
        disconnectRef?.cancelDisconnectOperations()
    }

    func sendGameAction(_ action: GameAction) {

        let newActionRef = gameRef.childByAutoId()
        guard let codableAction = CodableGameAction(action) else {
            return
        }
        let dataDict = FirebaseCodable<CodableGameAction>.toDict(codableAction)
        newActionRef.setValue(dataDict)
    }

    private func handleAddAction(actionSnapshot: DataSnapshot) {
        let actionDict = actionSnapshot.value as Any

        // Add to queue if action is successfully decoded
        guard let action = FirebaseCodable<CodableGameAction>.fromDict(actionDict) else {
            return
        }
        self.gameActionQueue.enqueue(action: action.gameAction)
    }

    func onDisconnectSend(_ action: GameAction) {
        disconnectRef = gameRef.childByAutoId()
        guard let codableAction = CodableGameAction(action) else {
            return
        }
        let dataDict = FirebaseCodable<CodableGameAction>.toDict(codableAction)
        disconnectRef?.onDisconnectSetValue(dataDict)
    }

}
