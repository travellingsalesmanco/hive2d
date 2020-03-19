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
    var code: String = "????"
    var host: GamePlayer
    var players: [String: GamePlayer]
    var settings: LobbySettings
    var started: Bool = false

    init(id: String, host: GamePlayer) {
        self.id = id
        self.host = host
        self.players = [host.id: host]
        self.settings = LobbySettings()
    }

    func isHost(playerId: String) -> Bool {
        return host.id == playerId
    }

    mutating func addPlayer(player: GamePlayer) {
        guard players[player.id] == nil else {
            return
        }
        self.players[player.id] = player
    }

    mutating func removePlayer(player: GamePlayer) {
        guard players[player.id] != nil else {
            return
        }
        self.players.removeValue(forKey: player.id)
    }
}
