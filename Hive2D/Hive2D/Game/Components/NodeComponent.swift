//
//  NodeComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class NodeComponent: GKComponent {
    var position: CGPoint

    init(position: CGPoint) {
        self.position = position
    }
}
