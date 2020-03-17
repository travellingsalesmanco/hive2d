//
//  ResourceNode.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 16/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class ResourceNode: GKEntity {
    let node: NodeComponent
    let player: PlayerComponent
    let resourceCollector: ResourceCollectorComponent

    init(node: NodeComponent, player: PlayerComponent, resourceCollector: ResourceCollectorComponent) {
        super.init()
        addComponent(node)
        addComponent(player)
        addComponent(resourceCollector)
    }
}
