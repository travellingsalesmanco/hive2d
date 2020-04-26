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

    func createEmptyTerrain (for terrainType: Terrain.Type) -> Terrain {
        switch terrainType {
        case is MineralTerrain.Type:
            return MineralTerrain(columns: cols, rows: rows, tileSize: tileSize)
        default:
            fatalError("Terrain class does not exist")
        }
    }

    func createRandomTerrain(for terrainType: Terrain.Type, seed: Int32) -> Terrain {
        let terrain = createEmptyTerrain(for: terrainType)
        let tileMap = terrain.tileMap
        tileMap.enableAutomapping = true
        let tileGroups = tileMap.tileSet.tileGroups
        let noiseMap = createNoiseMap(columns: cols, rows: rows, seed: seed)
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
    private func createNoiseMap(columns: Int, rows: Int, seed: Int32,
                                componentNoiseSources: [GKCoherentNoiseSource]
                                    = Constants.Terrain.componentNoises,
                                selectionNoiseSource: GKCoherentNoiseSource
                                    = Constants.Terrain.selectionNoise) -> GKNoiseMap {
        let componentNoises = componentNoiseSources.map { source -> GKNoise in
            source.seed = seed
            return GKNoise(source)
        }
        selectionNoiseSource.seed = seed
        let selectionNoise = GKNoise(selectionNoiseSource)
        let noise = GKNoise(componentNoises: componentNoises, selectionNoise: selectionNoise)
        let size = vector2(1.0, 1.0)
        let origin = vector2(0.0, 0.0)
        let sampleCount = vector2(Int32(columns), Int32(rows))
        let map = GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
        return map
    }
}
