//
//  UpgradeNodeAction.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 5/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

struct UpgradeNodeAction: GameAction {
    // TODO: Change to node entity
    let nodeNetId: NetworkComponent.Identifier

    func handle(game: Game) {
        guard let node = NetworkComponent.getEntity(for: nodeNetId) else {
            return
        }
        guard let resourceCollectorComponent = node.component(ofType: ResourceCollectorComponent.self),
            let player = node.component(ofType: PlayerComponent.self)?.player ,
            let resourceComponent = player.component(ofType: ResourceComponent.self) else {
            return
        }
        let resourceTier = resourceCollectorComponent.tier
        let resourceType = resourceCollectorComponent.resourceType
        let resources = resourceComponent.resources
        guard let resource = resources[resourceType] else {
            return
        }
        let upgradeCost = resourceTier * game.config.tierUpgradeCost

        guard resourceTier < game.config.maxTier && resource >= upgradeCost else {
            return
        }

        resourceCollectorComponent.tier += 1
        guard let amountAvailale = resources[resourceType] else {
            return
        }
        resourceComponent.resources[resourceType] = amountAvailale - upgradeCost
    }
}
