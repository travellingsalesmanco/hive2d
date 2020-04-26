//
//  PlayerComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class PlayerComponent: GameComponent {
    static func getPlayer(for entity: GameEntity) -> Player? {
        entity.component(ofType: PlayerComponent.self)?.player
    }

    unowned let player: Player

    init(player: Player) {
        self.player = player
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
