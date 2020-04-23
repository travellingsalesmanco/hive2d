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

    func getSpriteComponent(healthBar: ResourceBarSprite) -> SpriteComponent
    func getMinimapComponent() -> MinimapComponent
    func getConsumedResourceType() -> ResourceType
    func getDefenceComponent(healthBar: ResourceBarSprite) -> DefenceComponent
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

    func getResourceConsumerComponent(rate: CGFloat) -> ResourceConsumerComponent {
        ResourceConsumerComponent(resourceType: getConsumedResourceType(), resourceConsumptionRate: rate)
    }

    func isBuildable(game: Game) -> Bool {
        hasNearbyNodes(game: game) && !hasOverlappingNodes(game: game)
            && hasSufficientResources() && isTerrainBuildable(game: game)
    }

    /// Check that node is within range of some other node that player owns
    func hasNearbyNodes(game: Game) -> Bool {
        !getOwnNodesWithinRange(game: game).isEmpty
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

    /// Get the terrain tile at position
    func getTerrainTile(game: Game) -> Tile? {
        game.terrain?.getTile(at: position)
    }

    /// Check if terrain tile at position allows building of nodes
    func isTerrainBuildable(game: Game) -> Bool {
        // If terrain tile doesn't exist or is not buildable, do nothing.
        guard let terrainTile = getTerrainTile(game: game) else {
            return false
        }
        return terrainTile.isBuildable
    }

    /// Check that node does not overlap with other nodes
    func hasOverlappingNodes(game: Game) -> Bool {
        let toCheck = NodeComponent.Node(position: position, radius: Constants.GamePlay.nodeRadius)
        let nodes = game.query(includes: NodeComponent.self)
        return nodes.contains {
            $0.component(ofType: NodeComponent.self)!.getTransformedNode().intersects(other: toCheck)
        }
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
