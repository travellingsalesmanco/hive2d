//
//  BuildResourceNodeAction.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 22/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

struct BuildResourceNodeAction: BuildNodeAction {
    let player: Player
    let position: CGPoint
    let netId: NetworkComponent.Identifier
    let nodeType: NodeType

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
        guard let player = try container.decode(using: EntityFactory(), forKey: .player) as? Player else {
            throw DecodingError.valueNotFound(
                Player.Type.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Entity cannot be casted as Player."))
        }
        self.player = player
        self.position = try container.decode(CGPoint.self, forKey: .position)
        self.netId = try container.decode(NetworkComponent.Identifier.self, forKey: .netId)
        self.nodeType = try container.decode(NodeType.self, forKey: .nodeType)
    }

    func getSpriteComponent(healthBar: ResourceBarSprite) -> SpriteComponent {
        guard let spriteNode = ResourceNodeSprite(playerColor: player.getColor(), resourceType: resourceType) else {
            return SpriteComponent(spriteNode: SKSpriteNode())
        }
        spriteNode.addChild(healthBar,
                            xOffsetByWidths: -0.6, yOffsetByHeights: 0.75,
                            widthRatio: 1.2, heightRatio: 0.25)
        return SpriteComponent(spriteNode: spriteNode)
    }

    func getMinimapComponent() -> MinimapComponent {
        guard let spriteNode = ResourceNodeSprite(playerColor: player.getColor(), resourceType: resourceType) else {
            return MinimapComponent(spriteNode: SKSpriteNode())
        }
        return MinimapComponent(spriteNode: spriteNode)
    }

    func getConsumedResourceType() -> ResourceType {
        // TODO: What should this be?
        resourceType
    }

    func getDefenceComponent(healthBar: ResourceBarSprite) -> DefenceComponent {
        let defenceComponent = DefenceComponent(health: Constants.GamePlay.resourceNodeHealth,
                                                healthRecoveryRate: Constants.GamePlay.resourceNodeHealthRecoveryRate)
        defenceComponent.healthBarSprite = healthBar
        return defenceComponent
    }

    func getResourceCollectorComponent(rate: CGFloat, game: Game) -> ResourceCollectorComponent {
        var resourceCollectionRate = rate
        if let terrainTile = getTerrainTile(game: game) {
            resourceCollectionRate =
                terrainTile.boostResourceCollectionRate(resourceType: resourceType,
                                                        resourceCollectionRate: game.config.resourceCollectionRate)
        }
        return ResourceCollectorComponent(resourceType: resourceType, resourceCollectionRate: resourceCollectionRate)
    }

    func createNode(game: Game) -> Node? {
        let healthBar = ResourceBarSprite(color: UIColor.green)
        return ResourceNode(sprite: getSpriteComponent(healthBar: healthBar),
                            minimapDisplay: getMinimapComponent(),
                            node: nodeComponent,
                            transform: transformComponent,
                            player: playerComponent,
                            resourceCollector: getResourceCollectorComponent(rate: game.config.resourceCollectionRate,
                                                                             game: game),
                            resourceConsumer: getResourceConsumerComponent(rate: game.config.resourceConsumptionRate),
                            network: networkComponent,
                            defence: getDefenceComponent(healthBar: healthBar))
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
