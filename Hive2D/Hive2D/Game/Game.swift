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
    // TODO: Remove this once actions are using Player entities
    var playerEntities = [UUID: Player]()
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

    init(scene: SKScene, config: GameConfig, gameNetworking: GameNetworking) {
        self.scene = scene
        self.config = config
        self.gameNetworking = gameNetworking
        self.isHost = config.host.id == config.me.id
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

        // TOOD: REFACTOR
        if nodeType == .Combat {
            gameNetworking.sendGameAction(
                BuildCombatNodeAction(playerNetId: player.getNetId(),
                                position: point,
                                netId: NetworkComponent.generateIdentifier(),
                                nodeType: nodeType)
            )
        } else {
            gameNetworking.sendGameAction(
                BuildResourceNodeAction(playerNetId: player.getNetId(),
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

    func hasSufficientResources(for node: Node, nodeType: NodeType) -> Bool {
        let player = getPlayer(for: node)
        guard let resourceComponent = player?.component(ofType: ResourceComponent.self) else {
            return false
        }

        guard let nodeCosts = config.nodeCostMap.getResourceCosts(for: nodeType) else {
            return false
        }

        // Check that all resources required to build node are available in player's resources
        let resources = resourceComponent.resources
        for (resourceType, amountRequired) in nodeCosts {
            guard let amountAvailable = resources[resourceType] else {
                return false
            }
            if amountAvailable < amountRequired {
                return false
            }
        }

        // Deduct resources used
        for (resourceType, amountRequired) in nodeCosts {
            guard let amountAvailable = resources[resourceType] else {
                return false
            }
            resourceComponent.resources[resourceType] = amountAvailable - amountRequired
        }

        return true
    }

    func hasOverlappingNodes(node toCheck: NodeComponent.Node) -> Bool {
        let nodes = query(includes: NodeComponent.self)
        return nodes.contains {
            $0.component(ofType: NodeComponent.self)!.getTransformedNode().intersects(other: toCheck)
        }
    }

    // TODO: Remove this once actions are using Player entities
    func addPlayer(id: UUID, player: Player) {
        playerEntities[id] = player
    }

    // TODO: Remove this once actions are using Player entities
    func getPlayer(id: UUID) -> Player? {
        playerEntities[id]
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

    func resolveCombat(duration: TimeInterval) {
        let attackers = query(includes: AttackComponent.self)
        let defenders = query(includes: DefenceComponent.self)

        for attacker in attackers {
            guard let attackerId = attacker.component(ofType: NetworkComponent.self)?.id,
                let attackerNode = attacker.component(ofType: NodeComponent.self)?.getTransformedNode(),
                let attackerWeapon = attacker.component(ofType: AttackComponent.self),
                let attackerPlayerId = attacker.component(ofType: PlayerComponent.self)?.player.getNetId() else {
                continue
            }

            let defendersInRange = defenders.filter { defender in
                guard let defenderNode = defender.component(ofType: NodeComponent.self)?.getTransformedNode() else {
                    return true
                }
                let distanceSquared = pow(attackerNode.position.x - defenderNode.position.x, 2) +
                    pow(attackerNode.position.y - defenderNode.position.y, 2)
                let rangeSquared = pow(attackerWeapon.range + defenderNode.radius, 2)
                return distanceSquared <= rangeSquared
            }

            for defender in defendersInRange {
                guard let defenderId = defender.component(ofType: NetworkComponent.self)?.id,
                    let defenderDefence = defender.component(ofType: DefenceComponent.self),
                    let defenderPlayerId = defender.component(ofType: PlayerComponent.self)?.player.getNetId() else {
                    continue
                }

                // Check that attacker is not defender
                guard attackerId != defenderId, attackerPlayerId != defenderPlayerId else {
                    continue
                }

                let defenceMultiplier = defenderDefence.shield == 0 ? 1 : 1 / defenderDefence.shield
                defenderDefence.health -= attackerWeapon.attack * defenceMultiplier * CGFloat(duration)
            }
        }

        if isHost {
            clearDestroyedNodes()
        }
    }

    /// Sends DestroyNodeAction for all nodes with health <= 0
    func clearDestroyedNodes() {
        let nodes = query(includes: DefenceComponent.self)
        for node in nodes {
            guard let health = node.component(ofType: DefenceComponent.self)?.health,
                let nodeId = node.component(ofType: NetworkComponent.self)?.id else {
                continue
            }

            if health <= 0 {
                gameNetworking.sendGameAction(DestroyNodeAction(nodeNetId: nodeId))
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
        guard let nodeId = node.component(ofType: NetworkComponent.self)?.id else {
            return
        }
        gameNetworking.sendGameAction(UpgradeNodeAction(nodeNetId: nodeId))
    }

    func quit() {
        guard let player = player else {
            return
        }
        gameNetworking.sendGameAction(QuitGameAction(playerNetId: player.getNetId()))
    }
}
