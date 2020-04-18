//
//  MinimapDisplaySprite.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 19/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class MinimapComponent: SpriteComponent {
    static var minimap: MinimapDisplay?

    override func didAddToEntity() {
        MinimapComponent.minimap?.addGameElement(spriteNode)
    }
    override func willRemoveFromEntity() {
        spriteNode.removeFromParent()
    }

}
