//
//  FogOfWarComponent.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 26/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit
import SpriteKit

class FogOfWarComponent: GameComponent {
    static var maskRoot: SKNode?
    static var minimapMaskRoot: SKNode?

    var maskNode: SKNode
    var minimapMaskNode: SKNode

    override init() {
        let maskShape = SKShapeNode(circleOfRadius: Constants.GamePlay.nodeConnectRange)
        maskShape.fillColor = .red
        maskNode = SKSpriteNode.copyOfRendering(node: maskShape)
        minimapMaskNode = SKSpriteNode.copyOfRendering(node: maskShape)
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func syncPosition() {
        guard let transform = entity?.component(ofType: TransformComponent.self) else {
            fatalError("No TransformComponent on an entity with SpriteComponent.")
        }
        maskNode.position = transform.position
        minimapMaskNode.position = transform.position
    }

    override func didAddToEntity() {
        syncPosition()
    }

    override func didAddToGame() {
        FogOfWarComponent.maskRoot?.addChild(maskNode)
        FogOfWarComponent.minimapMaskRoot?.addChild(minimapMaskNode)
    }
    override func willRemoveFromGame() {
        maskNode.removeFromParent()
        minimapMaskNode.removeFromParent()
    }

    override func update(deltaTime seconds: TimeInterval) {
        syncPosition()
    }
}
