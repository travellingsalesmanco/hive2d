//
//  CombatProjectile.swift
//  Hive2D
//
//  Created by John Phua on 24/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class CombatProjectile: GKEntity {
    init(sprite: SpriteComponent,
         transform: TransformComponent,
         movement: MovementComponent,
         player: PlayerComponent) {
        super.init()
        addComponent(transform)
        addComponent(movement)
        addComponent(sprite)
        addComponent(player)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
