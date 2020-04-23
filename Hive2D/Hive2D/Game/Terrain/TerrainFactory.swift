//
//  TerrainFactory.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 22/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

/// Factory to generate different types of terrains
/// Initialize with the number of columns, rows, and size of each tile
struct TerrainFactory {
    let cols: Int
    let rows: Int
    let tileSize: CGSize

    init(cols: Int, rows: Int, tileSize: CGSize) {
        self.cols = cols
        self.rows = rows
        self.tileSize = tileSize
    }

    func createEmptyTerrain(for terrainType: TerrainType) -> Terrain {
        switch terrainType {
        case .mineral:
            return MineralTerrain(columns: cols, rows: rows, tileSize: tileSize)
        }
    }

    func createRandomTerrain(for terrainType: TerrainType) -> Terrain {
        let terrain = createEmptyTerrain(for: terrainType)
        let tileMap = terrain.tileMap
        tileMap.enableAutomapping = true
        let tileGroups = tileMap.tileSet.tileGroups
        let noiseMap = createNoiseMap(columns: cols, rows: rows)
        for col in 0..<cols {
            for row in 0..<rows {
                let location = vector2(Int32(row), Int32(col))
                // value in noise map is bounded from -1 to 1
                let value = noiseMap.value(at: location)
                // translate bounds to 0 to 2, and scale to number of tile groups in tile map
                let scaledValue = (value + 1.0) * Float(tileGroups.count / 2)
                // min because bounds are closed range
                let tileIndex = min(Int(scaledValue), tileGroups.count - 1)
                let tileGroup = tileGroups[tileIndex]
                tileMap.setTileGroup(tileGroup, forColumn: col, row: row)
             }
        }
        return terrain
    }

    /// Generate a noise map from a given noise source and for a grid with given number of tiles in columns and rows
    private func createNoiseMap(columns: Int, rows: Int,
                                source: GKNoiseSource = GKPerlinNoiseSource()) -> GKNoiseMap {
        let noise = GKNoise(source)
        let size = vector2(1.0, 1.0)
        let origin = vector2(0.0, 0.0)
        let sampleCount = vector2(Int32(columns), Int32(rows))
        let map = GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
        return map
    }
}

/// Enumeration for custom terrains
enum TerrainType {
    case mineral
}

// MARK: Custom terrain classes go here

/// Basic Terrain
fileprivate class MineralTerrain: Terrain {
    let tileMap: SKTileMapNode
//    private(set) var tileToResource = [SKTileGroup: ResourceType]()
//    let tileSetName = "terrain-mineral"

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
        // Only tiles with resource type mappings are buildable
//        let tileNameToResource = ["stone_copper": ResourceType.Alpha,
//                                  "stone_iron": ResourceType.Beta,
//                                  "stone_ruby": ResourceType.Delta,
//                                  "stone_silver": ResourceType.Epsilon,
//                                  "stone_gold": ResourceType.Gamma,
//                                  "stone_diamond": ResourceType.Zeta]
//        var tileNames = Array(tileNameToResource.keys)
//        tileNames.append("lava")
//
//        var tileGroups = [SKTileGroup]()
//        for name in tileNames {
//            let texture = SKTexture(imageNamed: name)
//            let definition = SKTileDefinition(texture: texture, size: tileSize)
//            let group = SKTileGroup(tileDefinition: definition)
//            if let resourceType = tileNameToResource[name] {
//                self.tileToResource[group] = resourceType
//            }
//            tileGroups.append(group)
//        }
        let tileSet = SKTileSet(tileGroups: tileGroups)
        self.tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        print(tileMap.tileSize)

//        guard let tileSet = SKTileSet(named: self.tileSetName) else {
//            fatalError("Mineral tile set not found")
//        }

//        self.tileMap.position = CGPoint(x: 0, y: 0)
//        self.tileMap.anchorPoint = CGPoint(x: 0.5, y: 0.5)

//        guard let copper = tileSet.tileGroups.first(where: { $0.name == "copper" }),
//            let iron = tileSet.tileGroups.first(where: { $0.name == "iron" }),
//            let ruby = tileSet.tileGroups.first(where: { $0.name == "ruby" }),
//            let silver = tileSet.tileGroups.first(where: { $0.name == "silver" }),
//            let gold = tileSet.tileGroups.first(where: { $0.name == "gold" }),
//            let diamond = tileSet.tileGroups.first(where: { $0.name == "diamond" }) else {
//                fatalError("One or more Mineral tile groups are missing")
//        }
//        self.tileToResource = [copper: ResourceType.Alpha,
//                               iron: ResourceType.Beta,
//                               ruby: ResourceType.Delta,
//                               silver: ResourceType.Epsilon,
//                               gold: ResourceType.Gamma,
//                               diamond: ResourceType.Zeta]
    }
}
