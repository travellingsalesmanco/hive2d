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
    var radius: CGFloat

    init(position: CGPoint, radius: CGFloat = Constants.GamePlay.nodeRadius) {
        self.position = position
        self.radius = radius
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
