//
//  Player.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class Player: GKEntity {

    init(player: PlayerComponent, resource: ResourceComponent, network: NetworkComponent) {
        super.init()
        addComponent(player)
        addComponent(resource)
        addComponent(network)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
