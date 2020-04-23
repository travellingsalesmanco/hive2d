//
//  QuitGameAction.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

struct QuitGameAction: GameAction {
    let player: Player
    var disconnected: Bool

    init(player: Player, disconnected: Bool = false) {
        self.player = player
        self.disconnected = disconnected
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let player = try container.decode(using: EntityFactory(), forKey: .player) as? Player else {
            throw DecodingError.valueNotFound(
                Player.Type.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Entity cannot be casted as Player."))
        }
        self.player = player
        self.disconnected = try container.decode(Bool.self, forKey: .disconnected)
    }

    func handle(game: Game) {
        print("QUITTING")
        // TODO: remove player from game
    }
}
