//
//  NetworkComponent.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 19/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class NetworkComponent: GKComponent {
    let id: UUID

    init(id: UUID = UUID()) {
        self.id = id
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
