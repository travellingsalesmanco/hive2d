//
//  MinimapDisplaySprite.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 19/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class MinimapComponent: RenderComponent {
    static var minimap: MinimapDisplay?

    override func didAddToGame() {
        MinimapComponent.minimap?.addMinimapElement(spriteNode)
    }
    override func willRemoveFromGame() {
        spriteNode.removeFromParent()
    }
}
