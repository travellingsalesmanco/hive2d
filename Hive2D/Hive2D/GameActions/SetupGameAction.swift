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
            let playerComponent = PlayerComponent(id: gamePlayer.id, name: gamePlayer.name)
            let resourceComponent = ResourceComponent(resources: Constants.GamePlay.initialPlayerResource)
            let networkComponent = NetworkComponent(id: playerNetworkingIds[idx])
            let playerEntity = Player(player: playerComponent, resource: resourceComponent, network: networkComponent)
            game.add(entity: playerEntity)

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
