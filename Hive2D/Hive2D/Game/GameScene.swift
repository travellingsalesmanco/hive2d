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

    /// Called once when the scene is presented to the view
    override func didMove(to view: SKView) {
        game = Game(scene: self)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        <#code#>
    }

    override func update(_ currentTime: TimeInterval) {

    }
}
