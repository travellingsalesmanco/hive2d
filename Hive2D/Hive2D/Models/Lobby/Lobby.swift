//
//  Lobby.swift
//  Hive2D
//
//  Created by John Phua on 14/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

struct Lobby: Codable {
    var id: String
    // Code to join room
    var code: String
    var host: GamePlayer
    var players: [String: GamePlayer]
    var settings: LobbySettings
    var started: Bool = false

    init(id: String, code: String, host: GamePlayer) {
        self.id = id
        self.code = code
        self.host = host
        self.players = [host.id.uuidString: host]
        self.settings = LobbySettings()
    }
}
