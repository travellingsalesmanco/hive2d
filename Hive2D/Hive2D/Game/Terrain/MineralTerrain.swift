//
//  MineralTerrain.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

/// Mineral terrain
struct MineralTerrain: Terrain {
    let tileMap: SKTileMapNode
    let resourceTypeToTileAsset: [ResourceType: String]

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
