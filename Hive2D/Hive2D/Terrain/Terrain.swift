//
//  Terrain.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 21/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

/// Terrain protocol for which all custom terrains must conform to
protocol Terrain {
    let tileMap: SKTileMapNode
    let tileToResource: [SKTileGroup:ResourceType]
}

/// Provide standard implementations for methods accross all terrains
extension Terrain {
    func getTile(at point: CGpoint) -> SKTileGroup {
        let row = tileMap.tileRowIndex(fromPosition: point)
        let col = tileMap.tileColIndex(fromPosition: point)
        return tileMap.tileGroup(atColumn: col, row: row)
    }

    /// Retrieve the resource corresponding to the tile at the given point in the scene
    /// - Returns: resource type corresponding to tile, or nil if there is no such mapping
    func getResource(at point: CGPoint) -> ResourceType? {
        let tile = getTile(at: point)
        guard let resource = tileToResource[tile] else {
            return nil
        }
        return resource
    }
}
