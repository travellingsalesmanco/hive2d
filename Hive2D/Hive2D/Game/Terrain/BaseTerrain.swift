//
//  BaseTerrain.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 2/5/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class BaseTerrain: Terrain {
    var tileMap: SKTileMapNode

    var resourceTypeToTileAsset: [ResourceType : String]

    init(columns: Int,
         rows: Int,
         tileSize: CGSize,
         tileAssets: [String],
         tileAssetToResourceType: [String: ResourceType],
         tileAssetToEffects: [String: [TileEffect]]) {
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
