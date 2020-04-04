//
//  GameNetworking.swift
//  Hive2D
//
//  Created by John Phua on 14/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

protocol GameNetworking {
    var gameActionQueue: GameActionQueue { get }
    func sendGameAction(_: GameAction)
    func onDisconnectSend(_: GameAction)
}
