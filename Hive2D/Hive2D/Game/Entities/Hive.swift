//
//  Hive.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class Hive: GKEntity {

    init(sprite: SpriteComponent, node: NodeComponent,
         transform: TransformComponent,
         player: PlayerComponent, network: NetworkComponent) {
        super.init()
        addComponent(transform)
        addComponent(sprite)
        addComponent(node)
        addComponent(player)
        addComponent(network)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
