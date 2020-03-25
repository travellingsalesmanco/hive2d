//
//  StartGameAction.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

struct StartGameAction: GameAction {
    func handle(game: Game) {
        game.connectedPlayersCount += 1
        if game.connectedPlayersCount == game.config.players.count {
            game.gameStarted = true
        }
    }
}
