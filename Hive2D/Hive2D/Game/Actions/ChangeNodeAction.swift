//
//  ChangeNodeAction.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

struct ChangeNodeAction: GameAction {
    let nodeNetId: UUID

    func handle(game: Game) {
        guard let node = game.networkedEntities[nodeNetId] else {
            return
        }
        guard let resourceType = node.component(ofType: ResourceCollectorComponent.self)?.resourceType,
            let player = node.component(ofType: PlayerComponent.self)?.player,
            let resources = player.component(ofType: ResourceComponent.self)?.resources[resourceType] else {
            return
        }
        let upgradeCost = resourceType.getCost()
        if resources >= upgradeCost {
            guard let newResourceType = resourceType.getNextTier() else {
                return
            }
            guard let resourceCollectorComponent = node.component(ofType: ResourceCollectorComponent.self),
                let resourceConsumerComponent = node.component(ofType: ResourceConsumerComponent.self),
                let spriteComponent = node.component(ofType: SpriteComponent.self) else {
                    return
            }
            resourceCollectorComponent.resourceType = newResourceType
            resourceConsumerComponent.resourceType = newResourceType
            let newSprite = ResourceNodeSprite(playerColor: player.getColor(), resourceType: resourceType)
            game.updateSprite(spriteComponent: spriteComponent, with: newSprite)
        }
    }
}
