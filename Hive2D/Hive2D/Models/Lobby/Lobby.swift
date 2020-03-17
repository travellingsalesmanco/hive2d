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
    var host: LobbyPlayer
    var players: [LobbyPlayer]
    var settings: LobbySettings
    var started: Bool = false

    init(id: String, code: String, host: LobbyPlayer) {
        self.id = id
        self.code = code
        self.host = host
        self.players = [host]
        self.settings = LobbySettings()
    }
}
