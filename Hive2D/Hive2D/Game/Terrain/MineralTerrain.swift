//
//  MineralTerrain.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

/// Mineral terrain
class MineralTerrain: BaseTerrain {
    init(columns: Int, rows: Int, tileSize: CGSize) {
        // Define tile asset names
        let copper = "copper"
        let iron = "iron"
        let ruby = "ruby"
        let silver = "silver"
        let gold = "gold"
        let diamond = "diamond"
        let lava = "lava"

        // Order resourceTypes so that tileGroups passed into tileMapNode is deterministic
        let tileAssets: [String] = [copper, iron, ruby, silver, gold, diamond, lava]

        // Map tiles to resource type
        let tileAssetToResourceType = [
            copper: ResourceType.Alpha,
            iron: ResourceType.Beta,
            ruby: ResourceType.Delta,
            silver: ResourceType.Epsilon,
            gold: ResourceType.Gamma,
            diamond: ResourceType.Zeta
        ]

        // Map tiles to effects
        let boostResourceEffect = BoostResourceEffect(boost: 2)
        let boostHealthRecoveryEffect = BoostHealthRecoveryEffect(boost: 2)
        let tileAssetToEffects: [String: [TileEffect]] = [
            copper: [boostResourceEffect],
            iron: [boostResourceEffect],
            silver: [boostHealthRecoveryEffect],
            gold: [boostResourceEffect, boostHealthRecoveryEffect],
            diamond: [boostResourceEffect]
        ]

        super.init(columns: columns, rows: rows, tileSize: tileSize,
                   tileAssets: tileAssets,
                   tileAssetToResourceType: tileAssetToResourceType,
                   tileAssetToEffects: tileAssetToEffects)
    }
}
