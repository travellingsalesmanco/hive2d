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
    }

}
