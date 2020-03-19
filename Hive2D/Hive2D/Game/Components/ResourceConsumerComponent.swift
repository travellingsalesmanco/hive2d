//
//  ResourceConsumerComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class ResourceConsumerComponent: GKComponent {
    var resourceConsumptionRate: CGFloat

    init(resourceConsumptionRate: CGFloat) {
        self.resourceConsumptionRate = resourceConsumptionRate
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
