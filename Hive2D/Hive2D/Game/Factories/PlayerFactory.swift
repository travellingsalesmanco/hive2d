//
//  PlayerFactory.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

struct PlayerFactory: DecodingFactory {
    enum CodingKeys: CodingKey {
        case netId
    }

    func create(from decoder: Decoder) throws -> Player {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let netId = try container.decode(NetworkComponent.Identifier.self, forKey: .netId)
        guard let player = NetworkComponent.getEntity(for: netId) as? Player else {
            throw DecodingError.valueNotFound(
                Player.Type.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Decoded player is not found in game."))
        }
        return player
    }
}
