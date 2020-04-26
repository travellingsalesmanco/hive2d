//
//  MovementComponent.swift
//  Hive2D
//
//  Created by John Phua on 24/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class MovementComponent: GameComponent {
    var start: GameEntity
    var end: GameEntity
    private var progress: CGFloat = 0
    var progressPerTick: CGFloat = 0
    var completed: Bool = false

    init(start: GameEntity, end: GameEntity, progressPerTick: CGFloat) {
        guard start.component(ofType: NodeComponent.self) != nil,
            end.component(ofType: NodeComponent.self) != nil else {
                fatalError("PathComponent endpoints must be entities with NodeComponents")
        }
        self.start = start
        self.end = end
        self.progressPerTick = progressPerTick
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        progress += progressPerTick

        // Set completion when reached destination
        if progress > 1 {
            self.completed = true
            return
        }

        guard let startPos = start.component(ofType: NodeComponent.self)?.getTransformedNode().position else {
            fatalError("Cannot get start node's position")
        }
        guard let endPos = end.component(ofType: NodeComponent.self)?.getTransformedNode().position else {
            fatalError("Cannot get end node's position")
        }

        guard let transform = entity?.component(ofType: TransformComponent.self) else {
            fatalError("Cannot get parent entity's TransformComponent")
        }

        // Move transform along start to end
        let vector = endPos - startPos
        let position = startPos + vector * progress

        transform.smoothed = true
        transform.position = position
    }
}
