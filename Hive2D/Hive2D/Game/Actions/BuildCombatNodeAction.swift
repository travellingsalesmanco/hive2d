//
//  BuildCombatNodeAction.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 22/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

struct BuildCombatNodeAction: BuildNodeAction {
    let player: Player
    let position: CGPoint
    let netId: NetworkComponent.Identifier
    let nodeType: NodeType

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
        guard let spriteNode = CombatNodeSprite(playerColor: player.getColor(), nodeType: nodeType) else {
            return SpriteComponent(spriteNode: SKSpriteNode())
        }
        spriteNode.addChild(healthBar,
                            xOffsetByWidths: -0.6, yOffsetByHeights: 0.75,
                            widthRatio: 1.2, heightRatio: 0.25)
        return SpriteComponent(spriteNode: spriteNode)
    }

    func getMinimapComponent() -> MinimapComponent {
        guard let spriteNode = CombatNodeSprite(playerColor: player.getColor(), nodeType: nodeType) else {
            return MinimapComponent(spriteNode: SKSpriteNode())
        }
        return MinimapComponent(spriteNode: spriteNode)
    }

    func getConsumedResourceType() -> ResourceType {
        .Zeta
    }

    func getDefenceComponent(healthBar: ResourceBarSprite) -> DefenceComponent {
        let defenceComponent = DefenceComponent(health: Constants.GamePlay.combatNodeHealth,
                                                healthRecoveryRate: Constants.GamePlay.combatNodeHealthRecoveryRate)
        defenceComponent.healthBarSprite = healthBar
        return defenceComponent
    }

    func getAttackComponent() -> AttackComponent {
        if nodeType == .CombatMulti {
            return AttackComponent(attacker:
                MultiTargetAttacker(damagePerSecond: Constants.GamePlay.combatNodeAttack,
                                    range: Constants.GamePlay.combatNodeRange,
                                    position: position))
        } else {
            return AttackComponent(attacker:
                SingleTargetAttacker(damagePerSecond: Constants.GamePlay.combatNodeAttack,
                                     range: Constants.GamePlay.combatNodeRange,
                                     position: position))
        }
    }

    func createNode(game: Game) -> Node? {
        let healthBar = ResourceBarSprite(color: UIColor.green)
        return CombatNode(sprite: getSpriteComponent(healthBar: healthBar),
                          minimapDisplay: getMinimapComponent(),
                          node: nodeComponent,
                          transform: transformComponent,
                          player: playerComponent,
                          resourceConsumer: getResourceConsumerComponent(rate: game.config.resourceConsumptionRate),
                          network: networkComponent,
                          defence: getDefenceComponent(healthBar: healthBar),
                          attack: getAttackComponent())
    }
}
