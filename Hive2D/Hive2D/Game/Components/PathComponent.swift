//
//  PathComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 4/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class PathComponent: GKComponent {
    var start: GKEntity
    var end: GKEntity

    init(start: GKEntity, end: GKEntity) {
        guard start.component(ofType: NodeComponent.self) != nil,
            end.component(ofType: NodeComponent.self) != nil else {
                fatalError("PathComponent endpoints must be entities with NodeComponents")
        }
        self.start = start
        self.end = end
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let startPos = start.component(ofType: NodeComponent.self)?.getTransformedNode().position else {
            fatalError("Cannot get start node's position")
        }
        guard let endPos = end.component(ofType: NodeComponent.self)?.getTransformedNode().position else {
            fatalError("Cannot get end node's position")
        }
        guard let transform = entity?.component(ofType: TransformComponent.self) else {
            fatalError("Cannot get parent entity's TransformComponent")
        }
        let vector = endPos - startPos
        let midPoint = (startPos + endPos) / 2

        transform.position = midPoint
        transform.scale = (vector.magnitude, 1)
        transform.rotation = vector.angle

    }
}
