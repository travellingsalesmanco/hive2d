//
//  LetterTerrain.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 26/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

/// Letter terrain
struct LetterTerrain: Terrain {
    let tileMap: SKTileMapNode
    let resourceTypeToTileAsset: [ResourceType: String]

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

        // Add reverse mapping from resource type to tile asset
        var resourceTypeToTileAsset = [ResourceType: String]()

        // Add tiles
        var tiles = [Tile]()
        tileAssets.forEach { tileAsset in
            // Create tile
            let tile: Tile
            if let resourceType = tileAssetToResourceType[tileAsset] {
                tile = Tile(imageName: tileAsset, size: tileSize, isBuildable: true,
                            resourceType: resourceType)
                resourceTypeToTileAsset[resourceType] = tileAsset
            } else {
                tile = Tile(imageName: tileAsset, size: tileSize, isBuildable: false)
            }
            // Add effects to tile
            if let effects = tileAssetToEffects[tileAsset] {
                tile.addEffect(effects)
            }
            tiles.append(tile)
        }

        // Setup tile map
        let tileSet = SKTileSet(tileGroups: tiles)
        self.tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        self.resourceTypeToTileAsset = resourceTypeToTileAsset
    }
}
