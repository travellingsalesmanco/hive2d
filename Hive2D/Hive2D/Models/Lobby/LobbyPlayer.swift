//
//  LobbyPlayer.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

struct LobbyPlayer: Codable {
    var id: UUID
    // Display name of player
    var name: String

    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
