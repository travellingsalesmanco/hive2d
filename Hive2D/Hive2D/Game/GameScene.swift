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

    // Update time
    var lastUpdateTimeInterval: TimeInterval = 0

    private var prevCameraPosition = CGPoint.zero
    private var prevCameraScale = CGFloat.zero

    init(gameConfig: GameConfig, gameNetworking: GameNetworking, size: CGSize) {
        self.gameConfig = gameConfig
        self.gameNetworking = gameNetworking
        super.init(size: size)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Called once when the scene is presented to the view
    override func didMove(to view: SKView) {
        self.game = Game(scene: self, config: gameConfig, gameNetworking: gameNetworking)

        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        prevCameraPosition = cameraNode.position
        prevCameraScale = cameraNode.xScale
        self.addChild(cameraNode)
        self.camera = cameraNode

        setUpGestureRecognizers()
    }

    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        handleGameActionsInQueue()

        game.update(deltaTime)
    }

    private func handleGameActionsInQueue() {
        let actionQueue = gameNetworking.gameActionQueue
        while let action = actionQueue.dequeue() {
            switch action {
            case let .SetupGame(action: value):
                game.handleSetupGame(value)
            case let .StartGame(action: value):
                game.handleStartGame(value)
            case let .QuitGame(action: value):
                game.handleQuitGame(value)
            case let .BuildNode(action: value):
                game.handleBuildNode(value)
            case let .ChangeNode(action: value):
                game.handleChangeNode(value)
            case let .DestroyNode(action: value):
                game.handleDestroyNode(value)
            }
        }
    }

    private func setUpGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        view?.addGestureRecognizer(tapGesture)
        view?.addGestureRecognizer(panGesture)
        view?.addGestureRecognizer(pinchGesture)
        self.isUserInteractionEnabled = true
    }

    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        let viewPoint = sender.location(in: self.view)
        let scenePoint = convertPoint(fromView: viewPoint)
        let firstNode = atPoint(scenePoint)

        if firstNode != self {
            // Do stuff based on SKSpriteNode that was touched
            return
        } else {
            // Touched empty space, emit a build node action
            // TODO: Provide player id and name based on UserAuthState.shared.get() to BuildNodeAction
            gameNetworking.sendGameAction(.BuildNode(action: BuildNodeAction(playerId: gameConfig.host.id,
                                                                             playerName: gameConfig.host.name,
                                                                             position: CGPoint())))
//            game.buildResourceNode(position: scenePoint)
        }
    }

    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }

        if sender.state == .began {
            self.prevCameraPosition = camera.position
        }

        let translation = sender.translation(in: self.view)
        let newPosition = CGPoint(x: self.prevCameraPosition.x + translation.x * -1,
                                  y: self.prevCameraPosition.y + translation.y)
        camera.position = newPosition
    }

    @objc func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }

        if sender.state == .began {
            self.prevCameraScale = camera.xScale
        }

        let newScale = self.prevCameraScale * 1 / sender.scale
        guard newScale <= Constants.GamePlay.maxCameraScale, newScale >= Constants.GamePlay.minCameraScale else {
            return
        }

        camera.setScale(newScale)
    }
}
