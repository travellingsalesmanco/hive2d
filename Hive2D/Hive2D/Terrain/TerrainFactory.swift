//
//  TerrainFactory.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 22/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

/// Factory to generate different types of terrains
/// Abstracts the creation of terrains
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
        case mineral:
            return MineralTerrain(columns: cols, rows: rows, tileSize: tileSize)
        }
    }

    func createRandomTerrain(for terrainType: TerrainType) -> Terrain {
        let terrain = createEmptyTerrain(for: terrainType)
        let tileMap = terrain.tileMap
        let tileGroups = Array(terrain.tileToResource.keys)
        let noiseMap = createNoiseMap(columns: cols, rows: rows)
        for col in 0..<cols {
            for row in 0..<rows {
                let location = vector2(Int32(row), Int32(col))
                // value in noise map is bounded from -1 to 1
                let value = noiseMap.value(at: location)
                // convert bounds to 0 to 2 and scale to number of tile groups in tile map
                let tileIndex = (value + 1) * tileGroups.count / 2
                let tileGroup = tileGroups[tileIndex[])
                tileMap.setTileGroup(tileGroup, forColumn: col, row: row)
             }
        }
    }

    /// Generate a noise map from a given noise source and for a grid specified by number of tiles in the columns and rows
    private func createNoiseMap(source: GKNoiseSource = GKPerlinNoiseSource(), columns: Int, rows: Int) -> GKNoiseMap {
        let noise = GKNoise.init(source)
        let size = vector2(1.0, 1.0)
        let origin = vector2(0, 0)
        let sampleCount = vector2(columns, rows)
        let map = GKNoiseMap.init(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
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
    init(columns: Int, rows: Int, tileSize: CGSize) {
        guard let tileSet = SKTileSet(named: "terrain-mineral") else {
            fatalError("Mineral tile set not found")
        }
        self.tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)

        guard let copper = tileSet.tileGroups.first(where: { $0.name == "copper"}),
            let iron = tileSet.tileGroups.first(where: { $0.name == "iron"}),
            let ruby = tileSet.tileGroups.first(where: { $0.name == "ruby"}),
            let silver = tileSet.tileGroups.first(where: { $0.name == "silver"}),
            let gold = tileSet.tileGroups.first(where: { $0.name == "gold"}),
            let diamond = tileSet.tileGroups.first(where: { $0.name == "diamond"}) else {
                fatalError("One or more Mineral tile groups are missing")
        }
        self.tileToResource = [copper: ResourceType.Alpha,
                               iron: ResourceType.Beta,
                               ruby: ResourceType.Delta,
                               silver: ResourceType.Epsilon,
                               gold: ResourceType.Gamma,
                               diamond: ResourceType.Zeta]
    }
}
