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


    init(scene: SKScene, config: GameConfig) {
        self.scene = scene
        self.config = config
        initPlayerAndHives(config: config)
    }

    func update() {

    }

    func initPlayerAndHives(config: GameConfig) {
        for player in config.players {
            addPlayer(player: player)
            addHive(player: player)
        }
    }

    func addPlayer(player: GamePlayer) {
        let playerComponent = PlayerComponent(id: player.id, name: player.name)
        let resourceComponent = ResourceComponent(resources: Constants.GamePlay.initialPlayerResource)
        let playerEntity = Player(player: playerComponent, resource: resourceComponent)
        add(entity: playerEntity)
    }

    func addHive(player: GamePlayer) {
        let positionX = CGFloat.random(in: scene.size.width / 4 ... scene.size.width * 3 / 4)
        let positionY = CGFloat.random(in: scene.size.height / 4 ... scene.size.height * 3 / 4)
        let position = CGPoint(x: positionX, y: positionY)
        let spriteNode = SKSpriteNode(imageNamed: Constants.GamePlay.NodeImages.Player1.hive)
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        let nodeComponent = NodeComponent(position: position)
        syncSpriteWithNode(spriteComponent: spriteComponent, nodeComponent: nodeComponent)
        let playerComponent = PlayerComponent(id: player.id, name: player.name)
        let hive = Hive(sprite: spriteComponent, node: nodeComponent, player: playerComponent)
        add(entity: hive)
    }

    func syncSpriteWithNode(spriteComponent: SpriteComponent, nodeComponent: NodeComponent) {
        spriteComponent.spriteNode.position = nodeComponent.position
    }

    func buildResourceNode(position: CGPoint) {
        let spriteNode = SKSpriteNode(imageNamed: Constants.GamePlay.NodeImages.Player1.node)
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        let nodeComponent = NodeComponent(position: position)
        syncSpriteWithNode(spriteComponent: spriteComponent, nodeComponent: nodeComponent)
        // TODO: test with UserAuthState using multiple devices
//        let id = UUID(uuidString: UserAuthState.shared.get()!)!
        // DEBUG: use host ID as placeholder
        let id = config.host.id

        let playerComponent = PlayerComponent(id: id,
                                              name: config.players.first(where: { player -> Bool in
                                                player.id == id
                                              })!.name)
        let resourceCollectorComponent =
            ResourceCollectorComponent(resourceCollectionRate: config.resourceCollectionRate)
        let resourceNode = ResourceNode(sprite: spriteComponent,
                                        node: nodeComponent,
                                        player: playerComponent,
                                        resourceCollector: resourceCollectorComponent)
        add(entity: resourceNode)
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

    func handleStartGame(_ action: StartGameAction) {
        // Start the game when numPlayer StartGameActions seen
    }
    func handleQuitGame(_ action: QuitGameAction) {
        // TODO
    }

    func handleBuildNode(_ action: BuildNodeAction) {
        let nodeComponent = NodeComponent(position: action.position)
        let playerComponent = PlayerComponent(id: action.playerId)
        let nodeEntity = ResourceNode(
            node: nodeComponent,
            player: playerComponent,
            resourceCollector: ResourceCollectorComponent(),
            network: NetworkComponent()
        )
        add(entity: nodeEntity)
    }
    func handleDestroyNode(_ action: DestroyNodeAction) {
        guard let node = networkedEntities[action.nodeNetId] else {
            return
        }
        remove(entity: node)
    }
    func handleChangeNode(_ action: ChangeNodeAction) {
        guard let node = networkedEntities[action.nodeNetId] else {
            return
        }
        // Change stuff
    }
}
