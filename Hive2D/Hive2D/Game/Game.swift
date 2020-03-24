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
    let scene: SKScene
    let config: GameConfig
    let gameNetworking: GameNetworking
    var connectedPlayersCount: Int = 0
    var gameStarted: Bool = false

    init(scene: SKScene, config: GameConfig, gameNetworking: GameNetworking) {
        self.scene = scene
        self.config = config
        self.gameNetworking = gameNetworking
        if config.host.id == config.me.id {
            setupGame()
        }
    }

    func update(_ dt: TimeInterval) {
        handleGameActionsInQueue()

        guard gameStarted else {
            return
        }
        entities.forEach {
            $0.update(deltaTime: dt)
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
        gameNetworking.sendGameAction(
            .SetupGame(SetupGameAction(playerNetworkingIds: playerNetworkingIds,
                                       hiveStartingLocations: hiveStartingLocations,
                                       hiveNetworkingIds: hiveNetworkingIds))
        )
    }

    func buildNode(at point: CGPoint) {
        gameNetworking.sendGameAction(
            .BuildNode(BuildNodeAction(playerId: config.me.id,
                                       playerName: config.me.name,
                                       position: point,
                                       netId: UUID()))
        )
    }

    /// Ensures sprite position is same as node position
    func syncSpriteWithNode(spriteComponent: SpriteComponent, nodeComponent: NodeComponent) {
        spriteComponent.spriteNode.position = nodeComponent.position
        spriteComponent.spriteNode.size = CGSize(width: nodeComponent.radius, height: nodeComponent.radius)
    }

    func hasSufficientResources(for resourceNode: ResourceNode) -> Bool {
        let player = getPlayer(for: resourceNode)
        let resources = player!.component(ofType: ResourceComponent.self)!.resources
        let cost = resourceNode.component(ofType: ResourceConsumerComponent.self)!.resourceConsumptionRate
        return resources > cost
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

    func getPlayer(for entity: GKEntity) -> Player? {
        let playerComponent = entity.component(ofType: PlayerComponent.self)!
        let players = query(includes: ResourceComponent.self)
        return players.first { $0.component(ofType: PlayerComponent.self)!.id == playerComponent.id } as? Player
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
        return entities.filter { entity in
            for type in types {
                if entity.component(ofType: type) == nil {
                    return false
                }
            }
            return true
        }
    }


    func connectNodeToNearest(from: NodeComponent) {
        let nodes = query(includes: NodeComponent.self)
            .map { $0.component(ofType: NodeComponent.self) }
        var closestNode: NodeComponent?
        var closestDistance = CGFloat.infinity
        nodes.forEach { node in
            guard node != nil && node != from else {
                return
            }
            let distanceX = pow(node!.position.x - from.position.x, 2)
            let distanceY = pow(node!.position.y - from.position.y, 2)
            let distanceSquared = distanceX + distanceY
            if distanceSquared < closestDistance {
                closestNode = node
                closestDistance = distanceSquared
            }
        }
        connectNode(from: from, to: closestNode!)
    }

    func connectNode(from: NodeComponent, to: NodeComponent) {
        let path = CGMutablePath()
        path.move(to: from.position)
        path.addLine(to: to.position)
        let edge = SKShapeNode(path: path)
        edge.strokeColor = .red
        scene.addChild(edge)
    }

    private func handleGameActionsInQueue() {
        let actions = gameNetworking.gameActionQueue.dequeueAll()
        for action in actions {
            switch action {
            case let .SetupGame(action):
                handleSetupGame(action)
            case let .StartGame(action):
                handleStartGame(action)
            case let .QuitGame(action):
                handleQuitGame(action)
            case let .BuildNode(action):
                handleBuildNode(action)
            case let .ChangeNode(action):
                handleChangeNode(action)
            case let .DestroyNode(action):
                handleDestroyNode(action)
            }
        }
    }

    func handleSetupGame(_ action: SetupGameAction) {
        for (idx, gamePlayer) in config.players.enumerated() {
            let playerComponent = PlayerComponent(id: gamePlayer.id, name: gamePlayer.name)
            let resourceComponent = ResourceComponent(resources: Constants.GamePlay.initialPlayerResource)
            let networkComponent = NetworkComponent(id: action.playerNetworkingIds[idx])
            let playerEntity = Player(player: playerComponent, resource: resourceComponent, network: networkComponent)
            add(entity: playerEntity)

            let hiveSpriteNode = SKSpriteNode(imageNamed: Constants.GameAssets.hive)
            let hiveSpriteComponent = SpriteComponent(spriteNode: hiveSpriteNode)
            let hiveNodeComponent = NodeComponent(position: action.hiveStartingLocations[idx])
            syncSpriteWithNode(spriteComponent: hiveSpriteComponent, nodeComponent: hiveNodeComponent)
            let hiveNetworkComponent = NetworkComponent(id: action.hiveNetworkingIds[idx])
            let hive = Hive(sprite: hiveSpriteComponent,
                            node: hiveNodeComponent,
                            player: playerComponent,
                            network: hiveNetworkComponent)
            add(entity: hive)
            // TODO: Does Hive need a playerComponent? Maybe add PlayerUnit(hive) component to playerEntity
        }
        // Broadcast acknowledgement
        gameNetworking.sendGameAction(.StartGame(StartGameAction()))
    }
    func handleStartGame(_ action: StartGameAction) {
        // Start the game when everyone acknowledges game setup
        connectedPlayersCount += 1
        if connectedPlayersCount == config.players.count {
            gameStarted = true
        }
    }
    func handleQuitGame(_ action: QuitGameAction) {
        // TODO
    }

    func handleBuildNode(_ action: BuildNodeAction) {
        let spriteNode = SKSpriteNode(imageNamed: Constants.GameAssets.node)
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        let nodeComponent = NodeComponent(position: action.position)
        syncSpriteWithNode(spriteComponent: spriteComponent, nodeComponent: nodeComponent)

        let playerComponent = PlayerComponent(id: action.playerId, name: action.playerName)
        let resourceCollectorComponent =
            ResourceCollectorComponent(resourceCollectionRate: config.resourceCollectionRate)
        let resourceConsumerComponent =
            ResourceConsumerComponent(resourceConsumptionRate: config.resourceConsumptionRate)
        let networkComponent = NetworkComponent(id: action.netId)
        let resourceNode = ResourceNode(sprite: spriteComponent,
                                        node: nodeComponent,
                                        player: playerComponent,
                                        resourceCollector: resourceCollectorComponent,
                                        resourceConsumer: resourceConsumerComponent,
                                        network: networkComponent)

        guard checkOverlapping(node: nodeComponent) else {
            return
        }
        guard hasSufficientResources(for: resourceNode) else {
            return
        }
        add(entity: resourceNode)
        connectNodeToNearest(from: nodeComponent)
    }
    func handleDestroyNode(_ action: DestroyNodeAction) {
        guard let node = networkedEntities[action.nodeNetId] else {
            return
        }
        remove(entity: node)
    }
    func handleChangeNode(_ action: ChangeNodeAction) {
//        guard let node = networkedEntities[action.nodeNetId] else {
//            return
//        }
        // Change stuff
    }
}
