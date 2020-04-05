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
    var networkedEntities = [UUID: GKEntity]()
    var playerEntities = [UUID: Player]()
    var player: Player?
    let scene: SKScene
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
            UUID()
        }
        let hiveStartingLocations = config.players.map { _ in
            CGPoint(x: CGFloat.random(in: scene.size.width / 4 ... scene.size.width * 3 / 4),
                    y: CGFloat.random(in: scene.size.height / 4 ... scene.size.height * 3 / 4))
        }
        let hiveNetworkingIds = hiveStartingLocations.map { _ in
            UUID()
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
        gameNetworking.sendGameAction(
            BuildNodeAction(playerNetId: player.getId(),
                            position: point,
                            netId: UUID(),
                            nodeType: nodeType)
        )
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

    /// Ensures sprite position is same as node position
    func syncSpriteWithNode(spriteComponent: SpriteComponent, nodeComponent: NodeComponent) {
        spriteComponent.spriteNode.position = nodeComponent.position
        spriteComponent.spriteNode.size = CGSize(width: nodeComponent.radius, height: nodeComponent.radius)
    }

    func hasSufficientResources(for node: Node, nodeType: NodeType) -> Bool {
        let player = getPlayer(for: node)
        guard let resources = player?.component(ofType: ResourceComponent.self)?.resources else {
            return false
        }

        guard let nodeCosts = config.nodeCostMap.getResourceCosts(for: nodeType) else {
            return false
        }

        // Check that all resources required to build node are available in player's resources
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
            player?.component(ofType: ResourceComponent.self)?.resources[resourceType] =
                amountAvailable - amountRequired
        }

        return true
    }

    func checkOverlapping(node toCheck: NodeComponent) -> Bool {
        let nodes = query(includes: NodeComponent.self)
        for node in nodes {
            let nodeComponent = node.component(ofType: NodeComponent.self)!
            let distanceX = pow(nodeComponent.position.x - toCheck.position.x, 2)
            let distanceY = pow(nodeComponent.position.y - toCheck.position.y, 2)
            let distance = sqrt(distanceX + distanceY)
            if distance <= nodeComponent.radius + toCheck.radius {
                return false
            }
        }
        return true
    }

    func addPlayer(id: UUID, player: Player) {
        playerEntities[id] = player
    }

    func getPlayer(id: UUID) -> Player? {
        playerEntities[id]
    }

    func getPlayer(for entity: GKEntity) -> Player? {
        guard let player = entity.component(ofType: PlayerComponent.self)?.player else {
            return nil
        }
        return player
    }

    func add(entity: GKEntity) {
        entities.insert(entity)
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.spriteNode {
            scene.addChild(spriteNode)
        }
        if let netId = entity.component(ofType: NetworkComponent.self)?.id {
            networkedEntities[netId] = entity
        }
    }

    func remove(entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.spriteNode {
            spriteNode.removeFromParent()
        }
        if let netId = entity.component(ofType: NetworkComponent.self)?.id {
            networkedEntities.removeValue(forKey: netId)
        }
        entities.remove(entity)
    }

    // TODO: Fix query not able to accept multiple component types as input
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
                let attackerNode = attacker.component(ofType: NodeComponent.self),
                let attackerWeapon = attacker.component(ofType: AttackComponent.self),
                let attackerPlayerId = attacker.component(ofType: PlayerComponent.self)?.player.getId() else {
                continue
            }

            let defendersInRange = defenders.filter { defender in
                guard let defenderNode = defender.component(ofType: NodeComponent.self) else {
                    return true
                }
                let distanceSquared = pow(attackerNode.position.x - defenderNode.position.x, 2) +
                    pow(attackerNode.position.y - defenderNode.position.y, 2)
                let rangeSquared = pow(attackerWeapon.range + defenderNode.radius, 2)
                return distanceSquared > rangeSquared
            }

            for defender in defendersInRange {
                guard let defenderId = defender.component(ofType: NetworkComponent.self)?.id,
                    let defenderDefence = defender.component(ofType: DefenceComponent.self),
                    let defenderPlayerId = defender.component(ofType: PlayerComponent.self)?.player.getId() else {
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
}
