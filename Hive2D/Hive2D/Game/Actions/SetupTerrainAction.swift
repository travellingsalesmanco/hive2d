//
//  SetupTerrainAction.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 24/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import CoreGraphics

struct SetupTerrainAction: GameAction {
    let cols: Int
    let rows: Int
    let tileSize: CGSize
    let seed: Int32
    let type: TerrainType

    // Setup terrain, then host setups game
    func handle(game: Game) {
        let terrainFactory = TerrainFactory(cols: cols, rows: rows, tileSize: tileSize)
        game.terrain = terrainFactory.makeRandomTerrain(for: type, seed: seed)
        if game.isHost {
            game.setupGame()
        }
    }
}
