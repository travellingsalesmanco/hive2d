//
//  DestroyNodeAction.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

struct DestroyNodeAction: GameAction {
    let nodeNetId: UUID

    func handle(game: Game) {
        guard let node = game.networkedEntities[nodeNetId] else {
            return
        }
        game.remove(entity: node)
    }
}
