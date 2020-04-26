//
//  GameComponent.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 26/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class GameComponent: GKComponent {
    var game: Game? {
        (entity as? GameEntity)?.game
    }
    func didAddToGame() {
    }

    func willRemoveFromGame() {
    }
}
