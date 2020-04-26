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
        // Order resourceTypes so that tileGroups passed into tileMapNode is deterministic
        let resourceTypes: [ResourceType] = [.Alpha, .Beta, .Delta, .Epsilon, .Gamma, .Zeta]

        // Add tiles
        var tileGroups = [Tile]()
        for resourceType in resourceTypes {
            guard let tileAsset = resourceTypeToTileAsset[resourceType] else {
                fatalError("No tile asset mapped to resource type: \(resourceType)")
            }
            let tileBehavior = BoostResourceBehavior(boost: 2)
            let tile = Tile(imageName: tileAsset, size: tileSize, isBuildable: true,
                            behavior: tileBehavior, resourceType: resourceType)
            tileGroups.append(tile)
        }
        let lava = Tile(imageName: "lava", size: tileSize, isBuildable: false)
        tileGroups.append(lava)

        // Setup tile map
        let tileSet = SKTileSet(tileGroups: tileGroups)
        self.tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
    }
}
