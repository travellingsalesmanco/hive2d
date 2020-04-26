//
//  GameEntity.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 26/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class GameEntity: GKEntity {
    weak var game: Game?

    func didAddToGame() {
        components.compactMap {
            $0 as? GameComponent
        }.forEach {
            $0.didAddToGame()
        }
    }

    func willRemoveFromGame() {
        components.compactMap {
            $0 as? GameComponent
        }.forEach {
            $0.willRemoveFromGame()
        }
    }

}
