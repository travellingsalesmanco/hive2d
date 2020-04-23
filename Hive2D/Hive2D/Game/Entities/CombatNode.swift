//
//  CombatNode.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class CombatNode: Node {

    init(sprite: SpriteComponent,
         minimapDisplay: MinimapComponent,
         node: NodeComponent,
         transform: TransformComponent,
         player: PlayerComponent,
         resourceConsumer: ResourceConsumerComponent,
         network: NetworkComponent,
         defence: DefenceComponent,
         attack: AttackComponent) {
        super.init(sprite: sprite,
                   minimapDisplay: minimapDisplay,
                   node: node,
                   transform: transform,
                   player: player,
                   network: network)
        addComponent(resourceConsumer)
        addComponent(defence)
        addComponent(attack)
    }

    func getRange() -> CGFloat {
        component(ofType: AttackComponent.self)!.range
    }

    func getAttack() -> CGFloat {
        component(ofType: AttackComponent.self)!.attack
    }

    @available(*, unavailable)
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
