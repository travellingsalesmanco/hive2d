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
    let playerNetId: UUID
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
        // Check that node is within range of some other node that player owns
        let nodesWithinRange = getNodesWithinRange(game: game)
        guard !nodesWithinRange.isEmpty else {
            return
        }

        let nodeComponent = NodeComponent(position: position)
        guard game.checkOverlapping(node: nodeComponent) else {
              return
        }

        guard let player = game.getPlayer(id: playerNetId) else {
            return
        }

        let spriteNode = CombatNodeSprite(playerColor: player.getColor())
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        let playerComponent = PlayerComponent(player: player)
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

        let edges = getEdges(to: nodesWithinRange)
        edges.forEach { game.add(entity: $0) }
    }

    private func buildResourceNode(resourceNodeType: NodeType, game: Game) {
        // Check that node is within range of some other node that player owns
        let nodesWithinRange = getNodesWithinRange(game: game)
        guard !nodesWithinRange.isEmpty else {
            return
        }

        guard let resourceType = convertToResourceType(from: resourceNodeType) else {
            return
        }

        let nodeComponent = NodeComponent(position: position)
        guard game.checkOverlapping(node: nodeComponent) else {
              return
        }
        guard let player = game.getPlayer(id: playerNetId) else {
            return
        }

        let spriteNode = ResourceNodeSprite(playerColor: player.getColor())
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        let playerComponent = PlayerComponent(player: player)
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

        let edges = getEdges(to: nodesWithinRange)
        edges.forEach { game.add(entity: $0) }
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

    /// Returns an array of nodes within range of node to be built excluding itself
    private func getNodesWithinRange(game: Game,
                                     range: CGFloat = Constants.GamePlay.nodeConnectRange) -> [GKEntity] {
        let nodes = game.query(includes: NodeComponent.self)
        guard let player = game.getPlayer(id: playerNetId) else {
            return []
        }
        let nodesWithinRange = nodes.filter { node in
            guard node.component(ofType: PlayerComponent.self)?.player == player else {
                return false
            }
            guard let nodeComponent = node.component(ofType: NodeComponent.self) else {
                return false
            }
            let distanceSquared = pow(nodeComponent.position.x - position.x, 2) +
                pow(nodeComponent.position.y - position.y, 2)
            // If distance squared is 0, it means its the same node, which we don't want
            guard distanceSquared != 0 else {
                return false
            }
            let rangeSquared = pow(range, 2)
            return distanceSquared < rangeSquared
        }
        return nodesWithinRange
    }

    /// Returns edges that connect the node to be added to the other nodes that are within range
    private func getEdges(to nodesWithinRange: [GKEntity]) -> [GKEntity] {
        let edges = nodesWithinRange.compactMap { node -> GKEntity? in
            guard let nodeComponent = node.component(ofType: NodeComponent.self) else {
                return nil
            }
            let pathComponent = PathComponent(start: position, end: nodeComponent.position)

            let path = CGMutablePath()
            path.move(to: position)
            path.addLine(to: nodeComponent.position)
            let shapeNode = SKShapeNode(path: path)
            guard let player = node.component(ofType: PlayerComponent.self)?.player else {
                return nil
            }
            shapeNode.strokeColor = player.getColor().getColor()
            // not sure about using a new SKView to extract texture from line
            guard let texture = SKView().texture(from: shapeNode) else {
                return nil
            }
            let spriteNode = SKSpriteNode(texture: texture)
            spriteNode.position = CGPoint(x: (position.x + nodeComponent.position.x) / 2,
                                          y: (position.y + nodeComponent.position.y) / 2)

            let spriteComponent = SpriteComponent(spriteNode: spriteNode)

            let playerComponent = PlayerComponent(player: player)

            let edge = Edge(sprite: spriteComponent, path: pathComponent, player: playerComponent)
            return edge
        }
        return edges
    }
}
