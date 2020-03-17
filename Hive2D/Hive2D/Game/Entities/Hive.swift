//
//  Hive.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class Hive: GKEntity {
    let node: NodeComponent
    let player: PlayerComponent

    init(node: NodeComponent, player: PlayerComponent) {
        self.node = node
        self.player = player
    }
}
