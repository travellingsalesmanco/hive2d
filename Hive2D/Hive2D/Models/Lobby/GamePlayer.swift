//
//  LobbyPlayer.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

struct GamePlayer: Codable {
    var id: String
    // Display name of player
    var name: String

    init(name: String, id: String) {
        self.id = id
        self.name = name
    }
}
