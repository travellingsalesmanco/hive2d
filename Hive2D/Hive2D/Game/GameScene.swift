//
//  GameScene.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    weak var gameDelegate: GameSceneDelegate?
    var game: Game!
    let gameConfig: GameConfig
    let gameNetworking: GameNetworking
    var hud: HUD!
    private var selectedNodeType: NodeType = .ResourceAlpha
    private var openedNodeMenu: NodeMenu?
    let cameraNode = SKCameraNode()
    let cameraScaleRange: ClosedRange<CGFloat>
    private var terrainNode: SKTileMapNode?

    // The actual game boundary
    private let gameRect: CGRect
    // Update time
    var lastUpdateTimeInterval: TimeInterval = 0

    init(gameConfig: GameConfig, gameNetworking: GameNetworking) {
        self.gameConfig = gameConfig
        self.gameNetworking = gameNetworking

        gameRect = CGRect(x: 0, y: 0, width: gameConfig.mapSize, height: gameConfig.mapSize)
        // Viewable height range (in game units)
        let hRange = Constants.GamePlay.viewableHeightRange
        // Display height (in display units)
        let sceneHeight = Constants.UI.sceneSize.height

        // Scaling required to map game units to display units
        cameraScaleRange = (hRange.lowerBound / sceneHeight)...(hRange.upperBound / sceneHeight)
        super.init(size: Constants.UI.sceneSize)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Called once when the scene is presented to the view
    override func didMove(to view: SKView) {
        // Set the game
        self.game = Game(scene: self, config: gameConfig, gameNetworking: gameNetworking)

        // Hook up the main sprite display system
        let gameSpritesRoot = SKNode()
        self.addChild(gameSpritesRoot)
        SpriteComponent.sceneRoot = gameSpritesRoot

        // Set the camera
        self.addChild(cameraNode)
        self.camera = cameraNode
        self.camera!.setScale(cameraScaleRange.lowerBound)
        self.camera!.zPosition = 50
        let boundsConstraint = SKConstraint.positionX(
            SKRange(lowerLimit: 0, upperLimit: gameConfig.mapSize),
            y: SKRange(lowerLimit: 0, upperLimit: gameConfig.mapSize)
        )
        boundsConstraint.enabled = true
        self.camera!.constraints = [boundsConstraint]

        // Set the HUD
        hud = HUD(size: self.size)
        hud.createHudNodes(resources: game.player?.getResources())
        hud.createMinimap(mapSize: gameConfig.mapSize)
        // Hook minimap node up to minimap system
        MinimapComponent.minimap = hud.minimapDisplay
        self.camera?.addChild(hud)

        // Set the gesture recognizers
        setUpGestureRecognizers()
    }

    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        game.update(deltaTime)
        hud.updateResourceDisplay(resources: game.player?.getResources())
        openedNodeMenu?.update()
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

        guard gameRect.contains(scenePoint) else {
            return
        }

        let node = atPoint(scenePoint)
        if let openedNodeMenu = openedNodeMenu {
            if node == openedNodeMenu.upgradeButton || node.parent == openedNodeMenu.upgradeButton {
                game.upgradeNode(node: openedNodeMenu.node)
                return
            }
        }
        openedNodeMenu?.removeFromParent()
        openedNodeMenu = nil

        // Check for open node menu
        let gameNodes = game.query(includes: SpriteComponent.self, NodeComponent.self, PlayerComponent.self)
        let filteredNodes = gameNodes.filter { gameNode in
            gameNode.component(ofType: SpriteComponent.self)?.spriteNode == node
            && gameNode.component(ofType: PlayerComponent.self)?.player == game.player
        }
        if let gameNode = filteredNodes.first {
            guard let nodeRadius = gameNode.component(ofType: NodeComponent.self)?.radius else {
                return
            }
            let menuSize = CGSize(width: nodeRadius * 3, height: nodeRadius * 2)
            let xOffset = CGFloat.zero
            let yOffset = -1 * menuSize.height
            let nodeMenu = NodeMenu(position: CGPoint(x: node.position.x + xOffset, y: node.position.y + yOffset),
                                    node: gameNode,
                                    tierUpgradeCost: gameConfig.tierUpgradeCost,
                                    maxTier: gameConfig.maxTier,
                                    size: menuSize)
            nodeMenu.update()
            openedNodeMenu = nodeMenu
            self.addChild(nodeMenu)
            return
        }

        // Touched space on terrain, emit a build node action
        if node == self.terrainNode {
            game.buildNode(at: scenePoint, nodeType: selectedNodeType)
            return
        }

        guard let nodeLabel = node.name else {
            return
        }
        // Build node palette stuff
        switch nodeLabel {
        case let nodeLabel where Constants.BuildNodePalette.nodeLabels.contains(nodeLabel):
            selectNodeType(node: node, label: nodeLabel)
        case "QuitGameLabel":
            quitGame()
        default:
            return
        }
    }

    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }

        let translationInView = sender.translation(in: view)
        let xSceneTranslation = -0.5 * translationInView.x * frame.width / view!.frame.width
        let ySceneTranslation = 0.5 * translationInView.y * frame.height / view!.frame.height
        let newPosition = CGPoint(x: camera.position.x + xSceneTranslation,
                                  y: camera.position.y + ySceneTranslation)
        sender.setTranslation(.zero, in: view)
        camera.position = newPosition
    }

    @objc func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }

        let newScale = camera.xScale / sender.scale

        guard cameraScaleRange.contains(newScale) else {
            return
        }

        camera.setScale(newScale)
    }

    private func quitGame() {
        game.quit()
        view?.presentScene(nil)
        gameDelegate?.gameEnded()
    }

    private func selectNodeType(node: SKNode, label: String) {
        guard let button = node as? BuildNodePaletteButton else {
            return
        }
        selectedNodeType = convertLabelToNodeType(label: label)
        button.setSelected()
    }

    private func convertLabelToNodeType(label: String) -> NodeType {
        return Constants.BuildNodePalette.labelToNodeType[label]!
    }
}

protocol GameSceneDelegate: AnyObject {
    func gameEnded()
}

extension GameScene: GameDelegate {
    func setTerrain(terrain: Terrain) {
        // Set the terrain
        terrain.tileMap.zPosition = -1
        terrain.tileMap.position = CGPoint(x: 0, y: 0)
        terrain.tileMap.anchorPoint = CGPoint(x: 0, y: 0)
        self.terrainNode = terrain.tileMap
        self.addChild(terrain.tileMap)

        // Update the HUD with terrain tiles
        hud.buildNodePalette?.updateButtonsWithTerrain(terrain: terrain)
    }
}
