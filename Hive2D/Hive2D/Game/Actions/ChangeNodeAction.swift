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
        guard let resourceCollectorComponent = node.component(ofType: ResourceCollectorComponent.self),
            let player = node.component(ofType: PlayerComponent.self)?.player ,
            let resourceStore = player.component(ofType: ResourceComponent.self)?.resources else {
            return
        }
        let resourceTier = resourceCollectorComponent.tier
        let resourceType = resourceCollectorComponent.resourceType
        guard let resources = resourceStore[resourceType] else {
            return
        }
        let upgradeCost = resourceTier * Constants.GamePlay.tierUpgradeCost

        guard resourceTier < Constants.GamePlay.maxTier && resources >= upgradeCost else {
            return
        }

        resourceCollectorComponent.tier += 1

//        guard let resourceCollectorComponent = node.component(ofType: ResourceCollectorComponent.self),
//            let resourceConsumerComponent = node.component(ofType: ResourceConsumerComponent.self),
//            let spriteComponent = node.component(ofType: SpriteComponent.self) else {
//                return
//        }
//        resourceCollectorComponent.resourceType = newResourceType
//        resourceConsumerComponent.resourceType = newResourceType
//        guard let newSprite = ResourceNodeSprite(playerColor: player.getColor(), resourceType: resourceType) else {
//            return
//        }
//        game.updateSprite(spriteComponent: spriteComponent, with: newSprite)
    }
}
