//
//  BuildCombatNodeAction.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 22/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

struct BuildCombatNodeAction: BuildNodeAction {
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

    func getSprite() -> SKSpriteNode? {
        let spriteNode = CombatNodeSprite(playerColor: player.getColor())
        spriteNode.addChild(healthBarSprite,
                            xOffsetByWidths: -0.6, yOffsetByHeights: 0.75,
                            widthRatio: 1.2, heightRatio: 0.25)
        return spriteNode
    }

    func getMinimapSprite() -> SKSpriteNode? {
        return CombatNodeSprite(playerColor: player.getColor())
    }

    func getConsumedResourceType() -> ResourceType {
        return .Zeta
    }

    func getDefenceComponent() -> DefenceComponent {
        let defenceComponent = DefenceComponent(health: Constants.GamePlay.combatNodeHealth,
                                                healthRecoveryRate: Constants.GamePlay.combatNodeHealthRecoveryRate)
        defenceComponent.healthBarSprite = healthBarSprite
        return defenceComponent
    }

    func getAttackComponent() -> AttackComponent {
        return AttackComponent(attack: Constants.GamePlay.combatNodeAttack,
                               range: Constants.GamePlay.combatNodeRange)
    }

    func createNode(game: Game) -> Node? {
        return CombatNode(sprite: spriteComponent,
                          minimapDisplay: minimapComponent,
                          node: nodeComponent,
                          transform: transformComponent,
                          player: playerComponent,
                          resourceConsumer: resourceConsumerComponent,
                          network: networkComponent,
                          defence: getDefenceComponent(),
                          attack: getAttackComponent())
    }
}
