//
//  DefenceComponent.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 1/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class DefenceComponent: GKComponent {
    var health: CGFloat
    var healthRecoveryRate: CGFloat
    var shield: CGFloat

    init(health: CGFloat, healthRecoveryRate: CGFloat, shield: CGFloat = 0) {
        self.health = health
        self.healthRecoveryRate = healthRecoveryRate
        self.shield = shield
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        health += healthRecoveryRate * CGFloat(seconds)
    }
}
