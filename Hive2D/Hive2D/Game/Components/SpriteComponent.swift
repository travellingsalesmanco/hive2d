//
//  SpriteComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 16/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    var spriteNode: SKSpriteNode

    init(spriteNode: SKSpriteNode) {
        self.spriteNode = spriteNode
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// RenderingSystem
/// Acts on SpriteComponent and TransformComponent to ensure rendered view is synchronized to logical properties
extension SpriteComponent {
    private func syncTransform() {
        guard let transform = entity?.component(ofType: TransformComponent.self) else {
            fatalError("No TransformComponent on an entity with SpriteComponent.")
        }
        spriteNode.position = transform.position
        spriteNode.xScale = transform.scale.x
        spriteNode.yScale = transform.scale.y
        spriteNode.zRotation = transform.rotation
    }

    override func didAddToEntity() {
        syncTransform()
    }

    override func update(deltaTime seconds: TimeInterval) {
        syncTransform()
    }
}
