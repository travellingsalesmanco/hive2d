//
//  SpriteComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 16/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class SpriteComponent: RenderComponent {
    static var sceneRoot: SKNode?

    override func didAddToGame() {
        SpriteComponent.sceneRoot?.addChild(spriteNode)
    }
    override func willRemoveFromGame() {
        spriteNode.removeFromParent()
    }
}
