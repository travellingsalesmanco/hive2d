//
//  GameScene.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let game: Game

    init() {
        self.game = Game(scene: self)
    }

    override func update(_ currentTime: TimeInterval) {

    }
}
