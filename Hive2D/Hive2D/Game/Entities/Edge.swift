//
//  Edge.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 4/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class Edge: GKEntity {
    init(sprite: SpriteComponent,
         path: PathComponent,
         player: PlayerComponent) {
        super.init()
        addComponent(sprite)
        addComponent(path)
        addComponent(player)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
