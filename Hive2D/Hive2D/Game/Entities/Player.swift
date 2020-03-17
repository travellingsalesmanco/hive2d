//
//  Player.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class Player: GKEntity {
    let player: PlayerComponent
    let resource: ResourceComponent

    init(player: PlayerComponent, resource: ResourceComponent) {
        super.init()
        addComponent(player)
        addComponent(resource)
    }
}
