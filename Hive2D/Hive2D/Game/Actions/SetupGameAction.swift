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
    let playerNetworkingIds: [NetworkComponent.Identifier]
    let playerColors: [PlayerColor]
    let hiveStartingLocations: [CGPoint]
    let hiveNetworkingIds: [NetworkComponent.Identifier]

    func handle(game: Game) {
        for (idx, gamePlayer) in game.config.players.enumerated() {
            // Construct player info component
            let playerInfoComponent = PlayerInfoComponent(gamePlayer,
                                                          color: playerColors[idx])
            // Add player entities
            let resourceComponent = ResourceComponent(alpha: Constants.GamePlay.initialPlayerResource)
            let playerNetworkingComponent = NetworkComponent(id: playerNetworkingIds[idx])
            let playerEntity = Player(player: playerInfoComponent,
                                      resource: resourceComponent,
                                      network: playerNetworkingComponent)
            game.add(entity: playerEntity)

            // Create player component from player entity
            let playerComponent = PlayerComponent(player: playerEntity)
            // Create hive node
            let hiveSpriteNode = HiveSprite(playerColor: playerEntity.getColor())
            let hiveSpriteComponent = SpriteComponent(spriteNode: hiveSpriteNode)
            let hiveMinimapSprite = HiveSprite(playerColor: playerEntity.getColor())
            let hiveMinimapComponent = MinimapComponent(spriteNode: hiveMinimapSprite)
            let hiveNodeComponent = NodeComponent(radius: Constants.GamePlay.hiveRadius)
            let hiveTransformComponent = TransformComponent(position: hiveStartingLocations[idx])
            let hiveNetworkComponent = NetworkComponent(id: hiveNetworkingIds[idx])
            let hive = Hive(sprite: hiveSpriteComponent,
                            minimapDisplay: hiveMinimapComponent,
                            node: hiveNodeComponent,
                            transform: hiveTransformComponent,
                            player: playerComponent,
                            network: hiveNetworkComponent)
            game.add(entity: hive)
            if game.config.me == gamePlayer {
                game.player = playerEntity
                game.scene.camera?.position = hiveSpriteNode.position
            }

        }

        // Broadcast acknowledgement
        game.gameNetworking.sendGameAction(StartGameAction())
        // Set up disconnect message
        guard let player = game.player else {
            return
        }
        game.gameNetworking.onDisconnectSend(QuitGameAction(player: player, disconnected: true))
    }
}
