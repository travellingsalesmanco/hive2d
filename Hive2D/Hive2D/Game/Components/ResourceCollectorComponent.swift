//
//  ResourceCollectorComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class ResourceCollectorComponent: GameComponent {
    var resourceType: ResourceType
    var resourceCollectionRate: CGFloat
    var tier: CGFloat

    init(resourceType: ResourceType,
         resourceCollectionRate: CGFloat = Constants.GameConfig.normalResourceCollectionRate,
         tier: CGFloat = Constants.GamePlay.initialResourceTier) {
        self.resourceType = resourceType
        self.resourceCollectionRate = resourceCollectionRate
        self.tier = tier
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let player = entity?.component(ofType: PlayerComponent.self)?.player,
            let resourceStore = player.component(ofType: ResourceComponent.self) else {
            return
        }

        guard let oldResourceCount = resourceStore.resources[resourceType] else {
            return
        }

        resourceStore.resources[resourceType] = oldResourceCount + tier * resourceCollectionRate * CGFloat(seconds)
    }
}
