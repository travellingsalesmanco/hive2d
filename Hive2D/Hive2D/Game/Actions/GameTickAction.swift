//
//  GameTickAction.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 2/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

struct GameTickAction: GameAction {
    let duration: TimeInterval

    func handle(game: Game) {
        guard duration > 0 else {
            return
        }

        // TODO: only update required components
        game.entities.forEach {
            $0.update(deltaTime: duration)
        }
    }
}
