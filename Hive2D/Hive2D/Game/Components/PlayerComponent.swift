//
//  PlayerComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class PlayerComponent: GKComponent {
    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
