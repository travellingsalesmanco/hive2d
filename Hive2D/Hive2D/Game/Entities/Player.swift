//
//  Player.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class Player: GameEntity, Codable {
    init(player: PlayerInfoComponent, resource: ResourceComponent, network: NetworkComponent) {
        super.init()
        addComponent(resource)
        addComponent(player)
        addComponent(network)
    }

    func getNetId() -> NetworkComponent.Identifier {
        component(ofType: NetworkComponent.self)!.id
    }

    func getColor() -> PlayerColor {
        component(ofType: PlayerInfoComponent.self)!.color
    }

    func getResources() -> [ResourceType: CGFloat] {
        component(ofType: ResourceComponent.self)!.resources
    }

    enum CodingKeys: CodingKey {
        case netId
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(getNetId(), forKey: .netId)
    }

    required init(from decoder: Decoder) throws {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
