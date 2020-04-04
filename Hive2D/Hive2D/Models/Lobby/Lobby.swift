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
    private var playerDict: [String: GamePlayer]
    var settings: LobbySettings
    var started: Bool = false
    var players: [GamePlayer] {
        playerDict.values.sorted(by: { $0.joinTime < $1.joinTime })
    }

    init(id: String, host: GamePlayer) {
        self.id = id
        self.host = host
        self.playerDict = [host.id: host]
        self.settings = LobbySettings()
    }

    func isHost(playerId: String) -> Bool {
        host.id == playerId
    }

    func gameCanStart() -> Bool {
        playerDict.count >= Constants.GameConfig.minPlayers
    }

    mutating func addPlayer(player: GamePlayer) {
        guard playerDict[player.id] == nil else {
            return
        }
        self.playerDict[player.id] = player
    }

    mutating func removePlayer(player: GamePlayer) {
        guard playerDict[player.id] != nil else {
            return
        }
        self.playerDict.removeValue(forKey: player.id)
    }
}
