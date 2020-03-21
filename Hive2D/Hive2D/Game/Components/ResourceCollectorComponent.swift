//
//  ResourceCollectorComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class ResourceCollectorComponent: GKComponent {
    var resourceCollectionRate: CGFloat

    init(resourceCollectionRate: CGFloat) {
        self.resourceCollectionRate = resourceCollectionRate
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let resourceStore = entity?.component(ofType: ResourceComponent.self) else {
            return
        }
        resourceStore.resources += resourceCollectionRate * CGFloat(seconds)
    }
}
