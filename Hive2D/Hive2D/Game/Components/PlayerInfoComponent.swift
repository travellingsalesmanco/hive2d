//
//  PlayerInfo.swift
//  Hive2D
//
//  Created by John Phua on 02/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class PlayerInfoComponent: GKComponent {
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
