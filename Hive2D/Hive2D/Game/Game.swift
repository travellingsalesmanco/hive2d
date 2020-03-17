//
//  Game.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 16/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class Game {
    var entities: [GKEntity] = [:]
    var scene: SKScene

    init(scene: SKScene) {
        self.scene = scene
    }

    func update() {

    }

    func add(entity: GKEntity) {
        entities.insert(entity)
    }
}
