//
//  TransformComponent.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 15/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class TransformComponent: GKComponent {
    var position: CGPoint
    var scale: (x: CGFloat, y: CGFloat)
    var rotation: CGFloat
    var smoothed: Bool = false

    init(position: CGPoint = .zero, scale: (CGFloat, CGFloat) = (1, 1), rotation: CGFloat = 0) {
        self.position = position
        self.scale = scale
        self.rotation = rotation
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
