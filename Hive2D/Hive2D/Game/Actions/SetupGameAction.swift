//
//  SetupGameAction.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 22/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation
import CoreGraphics
import GameplayKit
import SpriteKit

struct SetupGameAction: GameAction {
    let playerNetworkingIds: [UUID]
    let hiveStartingLocations: [CGPoint]
    let hiveNetworkingIds: [UUID]

    func handle(game: Game) {
        for (idx, gamePlayer) in game.config.players.enumerated() {
            // Construct player info component
            let playerInfoComponent = PlayerInfoComponent(id: gamePlayer.id, name: gamePlayer.name)
            // Add player entities
            let resourceComponent = ResourceComponent(alpha: Constants.GamePlay.initialPlayerResource)
            let playerNetworkingComponent = NetworkComponent(id: playerNetworkingIds[idx])
            let playerEntity = Player(player: playerInfoComponent,
                                      resource: resourceComponent,
                                      network: playerNetworkingComponent)

            game.addPlayer(id: playerNetworkingIds[idx], player: playerEntity)
            if game.config.me.id == gamePlayer.id {
                game.player = playerEntity
            }

            // Create player component from player entity
            let playerComponent = PlayerComponent(player: playerEntity)
            // Create hive node
            let hiveSpriteNode = SKSpriteNode(imageNamed: Constants.GameAssets.hive)
            let hiveSpriteComponent = SpriteComponent(spriteNode: hiveSpriteNode)
            let hiveNodeComponent = NodeComponent(position: hiveStartingLocations[idx])
            game.syncSpriteWithNode(spriteComponent: hiveSpriteComponent, nodeComponent: hiveNodeComponent)
            let hiveNetworkComponent = NetworkComponent(id: hiveNetworkingIds[idx])
            let hive = Hive(sprite: hiveSpriteComponent,
                            node: hiveNodeComponent,
                            player: playerComponent,
                            network: hiveNetworkComponent)
            game.add(entity: hive)
            // TODO: Does Hive need a playerComponent? Maybe add PlayerUnit(hive) component to playerEntity
        }
        // Broadcast acknowledgement
        game.gameNetworking.sendGameAction(StartGameAction())
    }
}
