//
//  GameScene.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var game: Game!
    let gameConfig: GameConfig
    let gameNetworking: GameNetworking!

    init(gameConfig: GameConfig, gameNetworking: GameNetworking, size: CGSize) {
        self.gameConfig = gameConfig
        self.gameNetworking = gameNetworking
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Called once when the scene is presented to the view
    override func didMove(to view: SKView) {
        self.game = Game(scene: self, config: gameConfig)
        self.isUserInteractionEnabled = true
    }

    /// Send game actions based on user interaction touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        let firstNode = atPoint(location)
        if firstNode != self {
            // Do stuff based on SKSpriteNode that was touched
            return
        } else {
            // Touched empty space, emit a build node action
            // TODO: Provide Player and Location argument to BuildNodeAction
            gameNetworking.sendGameAction(BuildNodeAction())
        }
    }

    override func update(_ currentTime: TimeInterval) {

    }
}
