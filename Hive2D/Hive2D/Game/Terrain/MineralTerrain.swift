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
    let resourceTypeToTileAsset = [
        ResourceType.Alpha: "copper",
        ResourceType.Beta: "iron",
        ResourceType.Delta: "ruby",
        ResourceType.Epsilon: "silver",
        ResourceType.Gamma: "gold",
        ResourceType.Zeta: "diamond"
    ]

    init(columns: Int, rows: Int, tileSize: CGSize) {

        var tileGroups = resourceTypeToTileAsset.map { (resourceType: ResourceType, tileAsset: String) in
            return Tile(imageName: tileAsset, size: tileSize, isBuildable: true, resourceType: resourceType)
        }
        let lava = Tile(imageName: "lava", size: tileSize, isBuildable: false, resourceType: nil)
        tileGroups.append(lava)
        let tileSet = SKTileSet(tileGroups: tileGroups)
        self.tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
    }
}
