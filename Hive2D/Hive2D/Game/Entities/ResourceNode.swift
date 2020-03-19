//
//  ResourceNode.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 16/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class ResourceNode: GKEntity {

    init(node: NodeComponent, player: PlayerComponent, resourceCollector: ResourceCollectorComponent,
         network: NetworkComponent) {
    init(sprite: SpriteComponent, node: NodeComponent, player: PlayerComponent, resourceCollector: ResourceCollectorComponent) {
        super.init()
        addComponent(sprite)
        addComponent(node)
        addComponent(player)
        addComponent(resourceCollector)
        addComponent(network)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
