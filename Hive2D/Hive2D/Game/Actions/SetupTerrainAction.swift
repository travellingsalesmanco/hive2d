//
//  SetupTerrainAction.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 24/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

struct SetupTerrainAction: GameAction {
    let terrainSeed: Int32

    // Setup terrain, then host setups game
    func handle(game: Game) {
        game.terrain = game.terrainFactory.createRandomTerrain(for: MineralTerrain.self, seed: terrainSeed)
        if game.isHost {
            game.setupGame()
        }
    }
}
