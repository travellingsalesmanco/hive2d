//
//  NodeComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class NodeComponent: GameComponent {
    struct Node {
        let position: CGPoint
        let radius: CGFloat
        func intersects(other: Node) -> Bool {
            let dx = position.x - other.position.x
            let dy = position.y - other.position.y
            let testDistance = radius + other.radius
            return dx * dx + dy * dy <= testDistance * testDistance
        }
    }

    var radius: CGFloat

    init(radius: CGFloat) {
        self.radius = radius
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Returns the Node in world coordinates
    func getTransformedNode() -> Node {
        guard let transform = entity?.component(ofType: TransformComponent.self) else {
            fatalError("Cannot retrieve parent entity's TransformComponent")
        }
        return Node(position: transform.position, radius: radius * transform.scale.x)
    }
    func intersects(_ other: Node) -> Bool {
        getTransformedNode().intersects(other: other)
    }
}
