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
    var scene: SKScene

    init(scene: SKScene, config: GameConfig) {
        self.scene = scene
    }

    func update() {

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
