//
//  GameViewController.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 15/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameArea: UIView!
    var gameConfig: GameConfig!
    var gameNetworking: GameNetworking!

    override func viewDidLoad() {
        super.viewDidLoad()
//        let boundHeight = view.bounds.size.height
//        let scaleFactor = boundHeight / Constants.GameBounds.gameBoundHeight
//        let boundWidth = view.bounds.size.width * scaleFactor
//
//        let scene = GameScene(gameConfig: gameConfig,
//                              gameNetworking: gameNetworking,
//                              size: CGSize(width: boundWidth, height: boundHeight))
//        let skView = self.view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.ignoresSiblingOrder = true
//        scene.scaleMode = .aspectFill
//        skView.presentScene(scene)
    }

    func setGameConfig(lobby: Lobby, gameNetworking: GameNetworking) {
        self.gameConfig = GameConfig(lobby: lobby)
        self.gameNetworking = gameNetworking
    }
}
