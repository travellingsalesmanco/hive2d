//
//  AttackComponent.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 1/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class AttackComponent: GKComponent {
    var attack: CGFloat
    var range: CGFloat

    init(attack: CGFloat, range: CGFloat) {
        self.attack = attack
        self.range = range
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
