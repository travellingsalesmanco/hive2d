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

    init(columns: Int, rows: Int, tileSize: CGSize) {
        let copper = Tile(imageName: "stone_copper", size: tileSize,
                          isBuildable: true, resourceType: ResourceType.Alpha)
        let iron = Tile(imageName: "stone_iron", size: tileSize,
                        isBuildable: true, resourceType: ResourceType.Beta)
        let ruby = Tile(imageName: "stone_ruby", size: tileSize,
                        isBuildable: true, resourceType: ResourceType.Delta)
        let silver = Tile(imageName: "stone_silver", size: tileSize,
                          isBuildable: true, resourceType: ResourceType.Epsilon)
        let gold = Tile(imageName: "stone_gold", size: tileSize,
                        isBuildable: true, resourceType: ResourceType.Gamma)
        let diamond = Tile(imageName: "stone_diamond", size: tileSize,
                           isBuildable: true, resourceType: ResourceType.Zeta)
        let lava = Tile(imageName: "lava", size: tileSize,
                        isBuildable: false, resourceType: nil)
        let tileGroups = [copper, iron, ruby, silver, gold, diamond, lava]
        let tileSet = SKTileSet(tileGroups: tileGroups)
        self.tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
    }
}
