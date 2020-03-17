//
//  CombatNode.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class CombatNode: GKEntity {
    let node: NodeComponent
    let player: PlayerComponent
    let resourceConsumer: ResourceConsumerComponent

    init(node: NodeComponent, player: PlayerComponent, resourceConsumer: ResourceConsumerComponent) {
        self.node = node
        self.player = player
        self.resourceConsumer = resourceConsumer
    }
}
