//
//  Node.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 1/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class Node: GKEntity {
    init(sprite: SpriteComponent,
         node: NodeComponent,
         transform: TransformComponent,
         player: PlayerComponent,
         network: NetworkComponent) {
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
