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
    var tileMap: SKTileMapNode { get }
}

/// Provide standard implementations for methods accross all terrains
extension Terrain {
    func getTile(at point: CGPoint) -> Tile? {
        let row = tileMap.tileRowIndex(fromPosition: point)
        let col = tileMap.tileColumnIndex(fromPosition: point)
        return tileMap.tileGroup(atColumn: col, row: row) as? Tile
    }
}
