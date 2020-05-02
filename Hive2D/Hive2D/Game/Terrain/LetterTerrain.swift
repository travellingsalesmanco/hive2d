//
//  LetterTerrain.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 26/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

/// Letter terrain
class LetterTerrain: BaseTerrain {
    init(columns: Int, rows: Int, tileSize: CGSize) {
        // Define tile asset names
        let letterA = "letterA"
        let letterB = "letterB"
        let letterD = "letterD"
        let letterE = "letterE"
        let letterG = "letterG"
        let letterZ = "letterZ"
        let glass = "glass"

        // Order resourceTypes so that tileGroups passed into tileMapNode is deterministic
        let tileAssets: [String] = [letterA, letterB, letterD, letterE, letterG, letterZ, glass]

        // Map tiles to resource type
        let tileAssetToResourceType = [
            letterA: ResourceType.Alpha,
            letterB: ResourceType.Beta,
            letterD: ResourceType.Delta,
            letterE: ResourceType.Epsilon,
            letterG: ResourceType.Gamma,
            letterZ: ResourceType.Zeta
        ]

        // Map tiles to effects
        let boostResourceEffect = BoostResourceEffect(boost: 2)
        let boostHealthRecoveryEffect = BoostHealthRecoveryEffect(boost: 2)
        let tileAssetToEffects: [String: [TileEffect]] = [
            letterA: [boostResourceEffect],
            letterB: [boostResourceEffect],
            letterE: [boostResourceEffect, boostHealthRecoveryEffect],
            letterG: [boostHealthRecoveryEffect],
            letterZ: [boostResourceEffect]
        ]

        super.init(columns: columns, rows: rows, tileSize: tileSize,
                   tileAssets: tileAssets,
                   tileAssetToResourceType: tileAssetToResourceType,
                   tileAssetToEffects: tileAssetToEffects)
    }
}
