//
//  ResourceComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class ResourceComponent: GKComponent {
    var resources: Float

    init(resources: Float) {
        self.resources = resources
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
