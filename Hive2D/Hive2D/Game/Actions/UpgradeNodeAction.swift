//
//  UpgradeNodeAction.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 5/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

struct UpgradeNodeAction: GameAction {
    let node: Node

    init(node: Node) {
        self.node = node
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let node = try container.decode(using: EntityFactory(), forKey: .node) as? Node else {
            throw DecodingError.valueNotFound(
                Node.Type.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Entity cannot be casted as Node."))
        }
        self.node = node
    }

    func handle(game: Game) {
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
