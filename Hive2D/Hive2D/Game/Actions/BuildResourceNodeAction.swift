//
//  BuildResourceNodeAction.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 22/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

struct BuildResourceNodeAction: BuildNodeAction {
    var player: Player
    var position: CGPoint
    var netId: NetworkComponent.Identifier
    var nodeType: NodeType

    init(player: Player, position: CGPoint, netId: NetworkComponent.Identifier, nodeType: NodeType) {
        self.player = player
        self.position = position
        self.netId = netId
        self.nodeType = nodeType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        player = try container.decode(using: PlayerFactory(), forKey: .player)
        position = try container.decode(CGPoint.self, forKey: .position)
        netId = try container.decode(NetworkComponent.Identifier.self, forKey: .netId)
        nodeType = try container.decode(NodeType.self, forKey: .nodeType)
    }

    func handle(game: Game) {
        guard isBuildable(game: game) else {
            return
        }

        guard let resourceType = convertToResourceType(from: nodeType) else {
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
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        let minimapComponent = MinimapComponent(spriteNode: minimapSprite)
        let healthBar = ResourceBarSprite(color: UIColor.green)
        spriteNode.addChild(healthBar,
                            xOffsetByWidths: -0.6, yOffsetByHeights: 0.75,
                            widthRatio: 1.2, heightRatio: 0.25)
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
        guard game.hasSufficientResources(for: resourceNode, nodeType: nodeType) else {
              return
        }

        game.add(entity: resourceNode)

        let edges = buildEdges(from: resourceNode, to: getOwnNodesWithinRange(game: game))
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
}
