//
//  CombatNode.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class CombatNode: GKEntity {

    init(sprite: SpriteComponent, node: NodeComponent,
         player: PlayerComponent, resourceConsumer: ResourceConsumerComponent) {
        super.init()
        addComponent(sprite)
        addComponent(node)
        addComponent(player)
        addComponent(resourceConsumer)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
