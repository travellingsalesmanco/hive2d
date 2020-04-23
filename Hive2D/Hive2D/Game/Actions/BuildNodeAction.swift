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

protocol BuildNodeAction: GameAction {
    var player: Player { get }
    var position: CGPoint { get }
    var netId: NetworkComponent.Identifier { get }
    var nodeType: NodeType { get }

    func getSprite() -> SKSpriteNode?
    func getMinimapSprite() -> SKSpriteNode?
    func getConsumedResourceType() -> ResourceType
    func getDefenceComponent() -> DefenceComponent
    func createNode(game: Game) -> Node?
}

extension BuildNodeAction {
    func handle(game: Game) {
        guard isBuildable(game: game) else {
            return
        }

        guard let node = createNode(game: game) else {
            return
        }
        consumeResourcesForBuilding()
        game.add(entity: node)

        let edges = buildEdges(from: node, to: getOwnNodesWithinRange(game: game))
        edges.forEach { game.add(entity: $0) }
    }

    var nodeComponent: NodeComponent {
        NodeComponent(radius: Constants.GamePlay.nodeRadius)
    }

    var playerComponent: PlayerComponent {
        PlayerComponent(player: player)
    }

    var networkComponent: NetworkComponent {
        NetworkComponent(id: netId)
    }

    var transformComponent: TransformComponent {
        TransformComponent(position: position)
    }

    var spriteComponent: SpriteComponent {
        SpriteComponent(spriteNode: getSprite() ?? SKSpriteNode())
    }

    var minimapComponent: MinimapComponent {
        MinimapComponent(spriteNode: getMinimapSprite() ?? SKSpriteNode())
    }

    var resourceConsumerComponent: ResourceConsumerComponent {
        ResourceConsumerComponent(resourceType: getConsumedResourceType())
    }

    var healthBarSprite: ResourceBarSprite {
        ResourceBarSprite(color: UIColor.green)
    }

    func isBuildable(game: Game) -> Bool {
        return hasNearbyNodes(game: game) && isNotColliding(game: game) && hasSufficientResources()
    }

    /// Check that node is within range of some other node that player owns
    func hasNearbyNodes(game: Game) -> Bool {
        return !getOwnNodesWithinRange(game: game).isEmpty
    }

    /// Check that node does not overlap with other nodes
    func isNotColliding(game: Game) -> Bool {
        let testNode = NodeComponent.Node(position: position, radius: Constants.GamePlay.nodeRadius)
        return !game.hasOverlappingNodes(node: testNode)
    }

    func hasSufficientResources() -> Bool {
        guard let resourceComponent = player.component(ofType: ResourceComponent.self) else {
            return false
        }

        return resourceComponent.hasSufficientResources(nodeType: nodeType)
    }

    func consumeResourcesForBuilding() {
        guard let resourceComponent = player.component(ofType: ResourceComponent.self) else {
            return
        }

        return resourceComponent.consumeResourcesToBuild(nodeType: nodeType)
    }

    /// Returns an array of nodes within range of node to be built excluding itself
    func getOwnNodesWithinRange(game: Game, range: CGFloat = Constants.GamePlay.nodeConnectRange) -> [GKEntity] {
        let nodes = game.query(includes: NodeComponent.self)
        let nodesWithinRange = nodes.filter { node in
            guard node.component(ofType: PlayerComponent.self)?.player == player else {
                return false
            }
            guard let node = node.component(ofType: NodeComponent.self)?.getTransformedNode() else {
                return false
            }
            let distance = node.position.distanceTo(position)
            // If distance squared is 0, it means its the same node, which we don't want
            guard distance != 0 else {
                return false
            }
            return distance < range
        }
        return nodesWithinRange
    }

    /// Returns edges that connect the node to be added to the other nodes that are within range
    func buildEdges(from node: Node, to nodes: [GKEntity]) -> [GKEntity] {
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
