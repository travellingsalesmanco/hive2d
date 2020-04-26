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
    let resourceTypeToTileAsset = [
        ResourceType.Alpha: "letter-A",
        ResourceType.Beta: "letter-B",
        ResourceType.Delta: "letter-D",
        ResourceType.Epsilon: "letter-E",
        ResourceType.Gamma: "letter-G",
        ResourceType.Zeta: "letter-Z"
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
            let tile = Tile(imageName: tileAsset, size: tileSize, isBuildable: true,
                            resourceType: resourceType)
            tileGroups.append(tile)
        }
        let lava = Tile(imageName: "glass", size: tileSize, isBuildable: false)
        tileGroups.append(lava)

        // Add tile effects
        let boostResourceEffect = BoostResourceEffect(boost: 2)
        let boostHealthRecoveryEffect = BoostHealthRecoveryEffect(boost: 2)
        for tile in tileGroups {
            switch tile.resourceType {
            case .Alpha, .Beta, .Zeta:
                tile.addEffect(boostResourceEffect)
            default:
                tile.addEffect(boostHealthRecoveryEffect)
            }
        }

        // Setup tile map
        let tileSet = SKTileSet(tileGroups: tileGroups)
        self.tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
    }
}
