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

    @IBOutlet private var gameArea: SKView!
    private var gameConfig: GameConfig!
    private var gameNetworking: GameNetworking!

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(gameConfig: gameConfig,
                              gameNetworking: gameNetworking)
        scene.gameDelegate = self
        guard let skView = self.gameArea else {
            return
        }

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }

    func setGameConfig(lobby: Lobby, me: GamePlayer, gameNetworking: GameNetworking) {
        self.gameConfig = GameConfig(lobby: lobby, me: me)
        self.gameNetworking = gameNetworking
    }
}

extension GameViewController: GameSceneDelegate {
    func gameEnded() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
