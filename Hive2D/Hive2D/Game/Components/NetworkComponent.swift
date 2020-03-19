//
//  NetworkComponent.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 19/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class NetworkComponent: GKComponent {
    var id: UUID

    override init() {
        self.id = UUID()
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
