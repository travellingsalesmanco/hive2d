//
//  EntityFactory.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

struct EntityFactory: DecodingFactory {
    enum CodingKeys: CodingKey {
        case netId
    }

    func create(from decoder: Decoder) throws -> GameEntity {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let netId = try container.decode(NetworkComponent.Identifier.self, forKey: .netId)
        guard let entity = NetworkComponent.getEntity(for: netId) else {
            throw DecodingError.valueNotFound(
                GameEntity.Type.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Entity does not exist in game."))
        }
        return entity
    }
}
