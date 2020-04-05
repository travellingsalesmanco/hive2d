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
    let hud = HUD()
    private var selectedNodeType: NodeType = .ResourceAlpha

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
        prevCameraPosition = cameraNode.position
        prevCameraScale = cameraNode.xScale
        self.addChild(cameraNode)
        self.camera = cameraNode
        self.camera?.zPosition = 50

        hud.createHudNodes(size: self.size)
        self.camera?.addChild(hud)
        setUpGestureRecognizers()
    }

    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        game.update(deltaTime)
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
        let node = atPoint(scenePoint)

        guard let nodeLabel = node.name else {
            // Touched empty space, emit a build node action
            game.buildNode(at: scenePoint, nodeType: selectedNodeType)
            return
        }

        switch nodeLabel {
        case "Alpha", "Beta", "Zeta", "Combat":
            selectNodeType(node: node, label: nodeLabel)
        default:
            return
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

    private func selectNodeType(node: SKNode, label: String) {
        guard let button = node as? BuildNodePaletteButton else {
            return
        }
        selectedNodeType = convertLabelToNodeType(label: label)
        button.setSelected()
    }

    private func convertLabelToNodeType(label: String) -> NodeType {
        if label == Constants.BuildNodePalette.resourceAlpha {
            return .ResourceAlpha
        } else if label == Constants.BuildNodePalette.resourceBeta {
            return .ResourceBeta
        } else if label == Constants.BuildNodePalette.resourceZeta {
            return .ResourceZeta
        } else {
            return .Combat
        }
    }
}
