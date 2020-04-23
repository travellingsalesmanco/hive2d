//
//  Game.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 16/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit
import SpriteKit
import NotificationCenter

class Game {
    var entities = Set<GKEntity>()
    var player: Player?
    unowned let scene: SKScene
    let config: GameConfig
    let gameNetworking: GameNetworking
    var connectedPlayersCount: Int = 0
    var isHost: Bool
    var gameStarted: Bool = false
    // Time at which last game tick action was called
    var lastGameTick: TimeInterval = 0
    // Time elapsed since game started
    var timeElapsed: TimeInterval = 0
    let terrain: Terrain

    init(scene: SKScene, config: GameConfig, gameNetworking: GameNetworking, terrain: Terrain) {
        self.scene = scene
        self.config = config
        self.gameNetworking = gameNetworking
        self.isHost = config.host.id == config.me.id
        self.terrain = terrain
        if self.isHost {
            setupGame()
        }
    }

    func update(_ dt: TimeInterval) {
        if gameStarted {
            timeElapsed += dt
        }

        handleGameActionsInQueue()

        if isHost {
            sendGameTick()
        }
    }

    func setupGame() {
        let playerNetworkingIds = config.players.map { _ in
            NetworkComponent.generateIdentifier()
        }
        let hiveStartingLocations = config.players.map { _ in
            CGPoint(x: CGFloat.random(in: config.mapSize / 4 ... config.mapSize * 3 / 4),
                    y: CGFloat.random(in: config.mapSize / 4 ... config.mapSize * 3 / 4))
        }
        let hiveNetworkingIds = hiveStartingLocations.map { _ in
            NetworkComponent.generateIdentifier()
        }
        let playerColors = PlayerColor.pickColors(count: config.players.count)
        gameNetworking.sendGameAction(
            SetupGameAction(playerNetworkingIds: playerNetworkingIds,
                            playerColors: playerColors,
                            hiveStartingLocations: hiveStartingLocations,
                            hiveNetworkingIds: hiveNetworkingIds)
        )
    }

    func buildNode(at point: CGPoint, nodeType: NodeType) {
        guard gameStarted else {
            return
        }

        guard let player = player else {
            return
        }

        if nodeType == .Combat {
            gameNetworking.sendGameAction(
                BuildCombatNodeAction(player: player,
                                      position: point,
                                      netId: NetworkComponent.generateIdentifier(),
                                      nodeType: nodeType)
            )
        } else {
            gameNetworking.sendGameAction(
                BuildResourceNodeAction(player: player,
                                        position: point,
                                        netId: NetworkComponent.generateIdentifier(),
                                        nodeType: nodeType)
            )
        }
    }

    func sendGameTick() {
        let duration = timeElapsed - lastGameTick
        // Send one game tick per second
        guard duration >= 1 else {
            return
        }
        gameNetworking.sendGameAction(GameTickAction(duration: duration))
        lastGameTick += duration
    }

    func getPlayer(for entity: GKEntity) -> Player? {
        entity.component(ofType: PlayerComponent.self)?.player
    }

    func add(entity: GKEntity) {
        entities.insert(entity)
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.spriteNode {
            scene.addChild(spriteNode)
        }
    }

    func remove(entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.spriteNode {
            spriteNode.removeFromParent()
        }
        entities.remove(entity)
    }

    func query(includes types: GKComponent.Type...) -> [GKEntity] {
        entities.filter { entity in
            for type in types {
                if entity.component(ofType: type) == nil {
                    return false
                }
            }
            return true
        }
    }

    private func handleGameActionsInQueue() {
        let actions = gameNetworking.gameActionQueue.dequeueAll()
        for action in actions {
            action.handle(game: self)
        }
    }

    /// Sends DestroyNodeAction for all nodes with health <= 0
    func clearDestroyedNodes() {
        let nodes = query(includes: DefenceComponent.self)
        for node in nodes {
            guard let health = node.component(ofType: DefenceComponent.self)?.health,
                let node = node as? Node else {
                continue
            }

            if health <= 0 {
                gameNetworking.sendGameAction(DestroyNodeAction(node: node))
            }
        }
    }

    func updateSprite(spriteComponent: SpriteComponent, with newSprite: SKSpriteNode) {
        let oldSprite = spriteComponent.spriteNode
        newSprite.position = oldSprite.position
        newSprite.size = oldSprite.size
        oldSprite.children.forEach { childSprite in
            childSprite.removeFromParent()
            newSprite.addChild(childSprite)
        }
        oldSprite.removeFromParent()
        spriteComponent.spriteNode = newSprite
        scene.addChild(newSprite)
    }

    func upgradeNode(node: GKEntity) {
        guard let node = node as? Node else {
            return
        }
        gameNetworking.sendGameAction(UpgradeNodeAction(node: node))
    }

    func quit() {
        guard let player = player else {
            return
        }
        gameNetworking.sendGameAction(QuitGameAction(player: player))
    }
}
