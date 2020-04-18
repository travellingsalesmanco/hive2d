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
         minimapDisplay: MinimapComponent,
         node: NodeComponent,
         transform: TransformComponent,
         player: PlayerComponent,
         resourceCollector: ResourceCollectorComponent,
         resourceConsumer: ResourceConsumerComponent,
         network: NetworkComponent,
         defence: DefenceComponent) {
        super.init(sprite: sprite,
                   minimapDisplay: minimapDisplay,
                   node: node,
                   transform: transform,
                   player: player,
                   network: network)
        addComponent(resourceCollector)
        addComponent(resourceConsumer)
        addComponent(defence)
    }

}
