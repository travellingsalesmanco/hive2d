//
//  LobbyPlayer.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

struct GamePlayer: Codable {
    let id: String
    // Display name of player
    var name: String
    let joinTime: Date

    init(name: String, id: String) {
        self.id = id
        self.name = name
        self.joinTime = Date()
    }
}

extension GamePlayer: Equatable {
    static func == (lhs: GamePlayer, rhs: GamePlayer) -> Bool {
        lhs.id == rhs.id
    }
}
