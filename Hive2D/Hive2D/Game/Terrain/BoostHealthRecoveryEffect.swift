//
//  BoostHealthRecoveryEffect.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 26/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

/// Boost the recovery effect of a node
struct BoostHealthRecoveryEffect: TileEffect {
    let boost: CGFloat

    init(boost: CGFloat) {
        self.boost = boost
    }

    func run(node: Node, tile: Tile) {
        node.component(ofType: DefenceComponent.self)?.healthRecoveryRate *= boost
    }
}
