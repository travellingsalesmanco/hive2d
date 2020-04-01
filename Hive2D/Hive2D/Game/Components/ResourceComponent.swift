//
//  ResourceComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class ResourceComponent: GKComponent {
    var resources = [ResourceType: CGFloat]()

    init(alpha: CGFloat = 0,
         beta: CGFloat = 0,
         gamma: CGFloat = 0,
         delta: CGFloat = 0,
         epsilon: CGFloat = 0,
         zeta: CGFloat = 0) {

        self.resources[.Alpha] = alpha
        self.resources[.Beta] = beta
        self.resources[.Gamma] = gamma
        self.resources[.Delta] = delta
        self.resources[.Epsilon] = epsilon
        self.resources[.Zeta] = zeta
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
