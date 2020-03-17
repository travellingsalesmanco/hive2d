//
//  Game.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 16/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit
import SpriteKit

class Game {
    var entities = Set<GKEntity>()
    var scene: SKScene

    init(scene: SKScene, config: GameConfig) {
        self.scene = scene
    }

    func update() {

    }

    func add(entity: GKEntity) {
        entities.insert(entity)
        guard let spriteNode = entity.component(ofType: SpriteComponent.self)?.node else {
            return
        }
        scene.addChild(spriteNode)
    }

    func remove(entity: GKEntity) {
        guard let spriteNode = entity.component(ofType: SpriteComponent.self)?.node else {
            return
        }
        spriteNode.removeFromParent()
        entities.remove(entity)
    }
}
