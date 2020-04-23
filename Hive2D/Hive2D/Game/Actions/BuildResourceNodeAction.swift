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

    var resourceType: ResourceType {
        convertToResourceType(from: nodeType)
    }

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

    func getSprite() -> SKSpriteNode? {
        guard let spriteNode = ResourceNodeSprite(playerColor: player.getColor(),
                                                  resourceType: resourceType) else {
            return nil
        }
        spriteNode.addChild(healthBarSprite,
                            xOffsetByWidths: -0.6, yOffsetByHeights: 0.75,
                            widthRatio: 1.2, heightRatio: 0.25)
        return spriteNode
    }

    func getMinimapSprite() -> SKSpriteNode? {
        return ResourceNodeSprite(playerColor: player.getColor(), resourceType: resourceType)
    }

    func getConsumedResourceType() -> ResourceType {
        // TODO: What should this be?
        .Alpha
    }

    func getDefenceComponent() -> DefenceComponent {
        let defenceComponent = DefenceComponent(health: Constants.GamePlay.resourceNodeHealth,
                                                healthRecoveryRate: Constants.GamePlay.resourceNodeHealthRecoveryRate)
        defenceComponent.healthBarSprite = healthBarSprite
        return defenceComponent
    }

    func getResourceCollectorComponent() -> ResourceCollectorComponent {
        return ResourceCollectorComponent(resourceType: resourceType)
    }

    func createNode(game: Game) -> Node? {
        return ResourceNode(sprite: spriteComponent,
                            minimapDisplay: minimapComponent,
                            node: nodeComponent,
                            transform: transformComponent,
                            player: playerComponent,
                            resourceCollector: getResourceCollectorComponent(),
                            resourceConsumer: resourceConsumerComponent,
                            network: networkComponent,
                            defence: getDefenceComponent())
    }

    private func convertToResourceType(from nodeType: NodeType) -> ResourceType {
        if nodeType == .ResourceAlpha {
            return .Alpha
        } else if nodeType == .ResourceBeta {
            return .Beta
        } else if nodeType == .ResourceGamma {
            return .Gamma
        } else if nodeType == .ResourceDelta {
            return .Delta
        } else if nodeType == .ResourceEpsilon {
            return .Epsilon
        } else {
            return .Zeta
        }
    }
}
