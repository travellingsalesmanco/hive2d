//
//  ResourceNodeSprite.swift
//  Hive2D
//
//  Created by John Phua on 02/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class ResourceNodeSprite: CompositeSprite {
    init(playerColor: PlayerColor,
         resourceType: ResourceType = Constants.GamePlay.initialResourceType) {
        let texture = SKTexture(imageNamed: Constants.GameAssets.resourceNode)
        super.init(texture: texture, color: playerColor.getColor(), size: texture.size())
        self.colorBlendFactor = 1
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
