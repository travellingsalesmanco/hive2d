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
    let playerNetId: UUID // TODO: Change to Player Entity
    let position: CGPoint
    let netId: NetworkComponent.Identifier
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

        let testNode = NodeComponent.Node(position: position, radius: Constants.GamePlay.nodeRadius)
        guard !game.hasOverlappingNodes(node: testNode) else {
              return
        }

        guard let player = game.getPlayer(id: playerNetId) else {
            return
        }

        let spriteNode = CombatNodeSprite(playerColor: player.getColor())
        let healthBar = ResourceBarSprite(color: UIColor.green)
        spriteNode.addChild(healthBar,
                            xOffsetByWidths: -0.6, yOffsetByHeights: 0.75,
                            widthRatio: 1.2, heightRatio: 0.25)
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        let minimapSprite = CombatNodeSprite(playerColor: player.getColor())
        let minimapComponent = MinimapComponent(spriteNode: minimapSprite)
        let nodeComponent = NodeComponent(radius: testNode.radius)
        let transformComponent = TransformComponent(position: position)
        let playerComponent = PlayerComponent(player: player)
        let networkComponent = NetworkComponent(id: netId)
        let resourceConsumerComponent = ResourceConsumerComponent(resourceType: .Zeta)
        let defenceComponent = DefenceComponent(health: Constants.GamePlay.combatNodeHealth,
                                                healthRecoveryRate: Constants.GamePlay.combatNodeHealthRecoveryRate)
        defenceComponent.healthBarSprite = healthBar
        let attackComponent = AttackComponent(attack: Constants.GamePlay.combatNodeAttack,
                                              range: Constants.GamePlay.combatNodeRange)

        let combatNode = CombatNode(sprite: spriteComponent,
                                    minimapDisplay: minimapComponent,
                                    node: nodeComponent,
                                    transform: transformComponent,
                                    player: playerComponent,
                                    resourceConsumer: resourceConsumerComponent,
                                    network: networkComponent,
                                    defence: defenceComponent,
                                    attack: attackComponent)
        guard game.hasSufficientResources(for: combatNode, nodeType: .Combat) else {
              return
        }

        game.add(entity: combatNode)

        let edges = buildEdges(from: combatNode, to: nodesWithinRange)
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

        let testNode = NodeComponent.Node(position: position, radius: Constants.GamePlay.nodeRadius)
        guard !game.hasOverlappingNodes(node: testNode) else {
            return
        }
        guard let player = game.getPlayer(id: playerNetId) else {
            return
        }

        guard let spriteNode = ResourceNodeSprite(playerColor: player.getColor(),
                                                  resourceType: resourceType) else {
            return
        }
        guard let minimapSprite = ResourceNodeSprite(playerColor: player.getColor(),
                                                     resourceType: resourceType) else {
                                                    return
        }
        let nodeComponent = NodeComponent(radius: testNode.radius)
        let transformComponent = TransformComponent(position: position)
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        let minimapComponent = MinimapComponent(spriteNode: minimapSprite)
        let healthBar = ResourceBarSprite(color: UIColor.green)
        spriteNode.addChild(healthBar,
                            xOffsetByWidths: -0.6, yOffsetByHeights: 0.75,
                            widthRatio: 1.2, heightRatio: 0.25)
        let playerComponent = PlayerComponent(player: player)
        let networkComponent = NetworkComponent(id: netId)
        let resourceCollectorComponent =
            ResourceCollectorComponent(resourceType: resourceType, resourceCollectionRate:
                game.config.resourceCollectionRate)
        let resourceConsumerComponent = ResourceConsumerComponent(resourceType: resourceType, resourceConsumptionRate:
                game.config.resourceConsumptionRate)
        let defenceComponent = DefenceComponent(health: Constants.GamePlay.resourceNodeHealth,
                                                healthRecoveryRate: Constants.GamePlay.resourceNodeHealthRecoveryRate)
        defenceComponent.healthBarSprite = healthBar

        let resourceNode = ResourceNode(sprite: spriteComponent,
                                        minimapDisplay: minimapComponent,
                                        node: nodeComponent,
                                        transform: transformComponent,
                                        player: playerComponent,
                                        resourceCollector: resourceCollectorComponent,
                                        resourceConsumer: resourceConsumerComponent,
                                        network: networkComponent,
                                        defence: defenceComponent)
        guard game.hasSufficientResources(for: resourceNode, nodeType: resourceNodeType) else {
              return
        }

        game.add(entity: resourceNode)

        let edges = buildEdges(from: resourceNode, to: nodesWithinRange)
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
            guard let node = node.component(ofType: NodeComponent.self)?.getTransformedNode() else {
                return false
            }
            let distanceSquared = pow(node.position.x - position.x, 2) +
                pow(node.position.y - position.y, 2)
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
    private func buildEdges(from node: Node, to nodes: [GKEntity]) -> [GKEntity] {
        let edges = nodes.compactMap { targetNode -> GKEntity? in
            guard let player = targetNode.component(ofType: PlayerComponent.self)?.player else {
                return nil
            }
            let pathComponent = PathComponent(start: node, end: targetNode)

            let spriteNode = EdgeSprite(playerColor: player.getColor())
            let minimapSprite = EdgeSprite(playerColor: player.getColor())
            let minimapComponent = MinimapComponent(spriteNode: minimapSprite)
            let transformComponent = TransformComponent()
            let spriteComponent = SpriteComponent(spriteNode: spriteNode)
            let playerComponent = PlayerComponent(player: player)

            return Edge(sprite: spriteComponent,
                        minimapDisplay: minimapComponent,
                        path: pathComponent,
                        transform: transformComponent,
                        player: playerComponent)
        }
        return edges
    }
}
