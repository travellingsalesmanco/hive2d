//
//  Node.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 1/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class Node: GKEntity, Codable {
    init(sprite: SpriteComponent,
         minimapDisplay: MinimapComponent,
         node: NodeComponent,
         transform: TransformComponent,
         player: PlayerComponent,
         network: NetworkComponent) {
        super.init()
        addComponent(transform)
        addComponent(sprite)
        addComponent(minimapDisplay)
        addComponent(node)
        addComponent(player)
        addComponent(network)
    }

    func getNetId() -> NetworkComponent.Identifier {
        component(ofType: NetworkComponent.self)!.id
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
