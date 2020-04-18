//
//  CombatNode.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class CombatNode: Node {

    init(sprite: SpriteComponent,
         node: NodeComponent,
         transform: TransformComponent,
         player: PlayerComponent,
         resourceConsumer: ResourceConsumerComponent,
         network: NetworkComponent,
         defence: DefenceComponent,
         attack: AttackComponent) {
        super.init(sprite: sprite, node: node, transform: transform,
                   player: player, network: network)
        addComponent(resourceConsumer)
        addComponent(defence)
        addComponent(attack)
    }
}
