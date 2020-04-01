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

struct BuildNodeAction: GameAction {
    let playerId: String
    let playerName: String
    let position: CGPoint
    let netId: UUID
    let nodeType: NodeType

    func handle(game: Game) {
        switch nodeType {
        case .Combat:
            buildCombatNode(game: game)
        case .ResourceAlpha, .ResourceBeta, .ResourceGamma, .ResourceDelta, .ResourceEpsilon, .ResourceZeta:
            buildResourceNode(resourceNodeType: nodeType, game: game)
        }
    }

    private func buildCombatNode(game: Game) {
        let nodeComponent = NodeComponent(position: position)
        guard game.checkOverlapping(node: nodeComponent) else {
              return
        }

        let spriteNode = SKSpriteNode(imageNamed: Constants.GameAssets.node)
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        let playerComponent = PlayerComponent(id: playerId, name: playerName)
        let networkComponent = NetworkComponent(id: netId)
        let resourceConsumerComponent = ResourceConsumerComponent(resourceType: .Zeta, resourceConsumptionRate:
                game.config.resourceConsumptionRate)
        let defenceComponent = DefenceComponent(health: Constants.GamePlay.combatNodeHealth,
                                                healthRecoveryRate: Constants.GamePlay.combatNodeHealthRecoveryRate)
        let attackComponent = AttackComponent(attack: Constants.GamePlay.combatNodeAttack,
                                              range: Constants.GamePlay.combatNodeRange)

        let combatNode = CombatNode(sprite: spriteComponent,
                                    node: nodeComponent,
                                    player: playerComponent,
                                    resourceConsumer: resourceConsumerComponent,
                                    network: networkComponent,
                                    defence: defenceComponent,
                                    attack: attackComponent)
        guard game.hasSufficientResources(for: combatNode, resourceType: .Zeta) else {
              return
        }

        game.syncSpriteWithNode(spriteComponent: spriteComponent, nodeComponent: nodeComponent)
        game.add(entity: combatNode)
        game.connectNodeToNearest(from: nodeComponent)
    }

    private func buildResourceNode(resourceNodeType: NodeType, game: Game) {
        guard let resourceType = convertToResourceType(from: resourceNodeType) else {
            return
        }

        let nodeComponent = NodeComponent(position: position)
        guard game.checkOverlapping(node: nodeComponent) else {
              return
        }

        let spriteNode = SKSpriteNode(imageNamed: Constants.GameAssets.node)
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        let playerComponent = PlayerComponent(id: playerId, name: playerName)
        let networkComponent = NetworkComponent(id: netId)
        let resourceCollectorComponent =
            ResourceCollectorComponent(resourceType: resourceType, resourceCollectionRate:
                game.config.resourceCollectionRate)
        let resourceConsumerComponent = ResourceConsumerComponent(resourceType: resourceType, resourceConsumptionRate:
                game.config.resourceConsumptionRate)
        let defenceComponent = DefenceComponent(health: Constants.GamePlay.resourceNodeHealth,
                                                healthRecoveryRate: Constants.GamePlay.resourceNodeHealthRecoveryRate)

        let resourceNode = ResourceNode(sprite: spriteComponent,
                                        node: nodeComponent,
                                        player: playerComponent,
                                        resourceCollector: resourceCollectorComponent,
                                        resourceConsumer: resourceConsumerComponent,
                                        network: networkComponent,
                                        defence: defenceComponent)
        guard game.hasSufficientResources(for: resourceNode, resourceType: resourceType) else {
              return
        }

        game.syncSpriteWithNode(spriteComponent: spriteComponent, nodeComponent: nodeComponent)
        game.add(entity: resourceNode)
        game.connectNodeToNearest(from: nodeComponent)
    }

    private func convertToResourceType(from resourceNodeType: NodeType) -> ResourceType? {
        switch resourceNodeType {
        case .ResourceAlpha:
            return .Alpha
        case .ResourceBeta:
            return .Beta
        case .ResourceGamma:
            return .Gamma
        case .ResourceDelta:
            return .Delta
        case .ResourceEpsilon:
            return .Epsilon
        case .ResourceZeta:
            return .Zeta
        default:
            return nil
        }
    }
}
