//
//  QuitGameAction.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

struct QuitGameAction: GameAction {
    let playerNetId: UUID
    var disconnected: Bool = false

    func handle(game: Game) {
        print("QUITTING")
        // TODO: remove player from game
    }
}
