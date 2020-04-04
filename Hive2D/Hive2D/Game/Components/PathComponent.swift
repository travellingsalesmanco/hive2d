//
//  PathComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 4/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class PathComponent: GKComponent {
    var start: CGPoint
    var end: CGPoint

    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
