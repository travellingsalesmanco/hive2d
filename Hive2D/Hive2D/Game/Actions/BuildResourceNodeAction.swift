//
//  BuildNodeAction.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation
import CoreGraphics
import GameplayKit
import SpriteKit

struct BuildResourceNodeAction: GameAction {
    let playerId: String
    let playerName: String
    let position: CGPoint
    let netId: UUID
    let resourceType: ResourceType

    func handle(game: Game) {
        let spriteNode = SKSpriteNode(imageNamed: Constants.GameAssets.node)
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        let nodeComponent = NodeComponent(position: position)
        game.syncSpriteWithNode(spriteComponent: spriteComponent, nodeComponent: nodeComponent)

        let playerComponent = PlayerComponent(id: playerId, name: playerName)
        let resourceCollectorComponent =
            ResourceCollectorComponent(resourceType: resourceType, resourceCollectionRate:
                game.config.resourceCollectionRate)
        let resourceConsumerComponent = ResourceConsumerComponent(resourceType: resourceType, resourceConsumptionRate:
                game.config.resourceConsumptionRate)
        let networkComponent = NetworkComponent(id: netId)

        let resourceNode = ResourceNode(sprite: spriteComponent,
                                        node: nodeComponent,
                                        player: playerComponent,
                                        resourceCollector: resourceCollectorComponent,
                                        resourceConsumer: resourceConsumerComponent,
                                        network: networkComponent)

        guard game.checkOverlapping(node: nodeComponent) else {
              return
        }

        guard game.hasSufficientResources(for: resourceNode, resourceType: resourceType) else {
              return
        }

        game.add(entity: resourceNode)
        game.connectNodeToNearest(from: nodeComponent)
    }
}
