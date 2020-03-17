//
//  GameNetworking.swift
//  Hive2D
//
//  Created by John Phua on 14/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

protocol GameNetworking {
    var gameId: String { get set }
    var gameActionQueue: GameActionQueue { get }
    func sendGameAction(_: GameAction)
//    func getActionsFrom(id: String) -> [GameAction]
//    func getActionsFrom(id: String, limit: Int) -> [GameAction]
//    func getActionsAfter(id: String) -> [GameAction]
//    func getActionsAfter(id: String, limit: Int) -> [GameAction]
}
