//
//  ResourceNode.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 16/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//
import GameplayKit

class ResourceNode: Node {

    init(sprite: SpriteComponent,
         node: NodeComponent,
         player: PlayerComponent,
         resourceCollector: ResourceCollectorComponent,
         resourceConsumer: ResourceConsumerComponent,
         network: NetworkComponent,
         defence: DefenceComponent) {
        super.init(sprite: sprite, node: node, player: player, network: network)
        addComponent(resourceCollector)
        addComponent(resourceConsumer)
        addComponent(defence)
    }

}
