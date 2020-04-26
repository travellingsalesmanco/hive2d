//
//  PlayerInfo.swift
//  Hive2D
//
//  Created by John Phua on 02/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class PlayerInfoComponent: GameComponent {
    let id: String
    let name: String
    let color: PlayerColor

    init(_ gamePlayer: GamePlayer, color: PlayerColor) {
        self.id = gamePlayer.id
        self.name = gamePlayer.name
        self.color = color
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
