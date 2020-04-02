//
//  Player.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class Player: GKEntity {
    init(player: PlayerInfoComponent, resource: ResourceComponent, network: NetworkComponent) {
        super.init()
        addComponent(resource)
        addComponent(player)
        addComponent(network)
    }

    func getId() -> UUID {
        self.component(ofType: NetworkComponent.self)!.id
    }

    func getColor() -> PlayerColor {
        self.component(ofType: PlayerInfoComponent.self)!.color
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
