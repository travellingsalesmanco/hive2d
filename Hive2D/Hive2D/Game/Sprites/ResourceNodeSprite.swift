//
//  ResourceNodeSprite.swift
//  Hive2D
//
//  Created by John Phua on 02/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class ResourceNodeSprite: SKSpriteNode {
    init?(playerColor: PlayerColor,
          resourceType: ResourceType) {
        guard let image = Constants.GamePlay.resourceTypeToAsset[resourceType] else {
            return nil
        }
        let texture = SKTexture(imageNamed: image)
        let size = CGSize(width: Constants.GamePlay.nodeRadius, height: Constants.GamePlay.nodeRadius)
        super.init(texture: texture, color: playerColor.getColor(), size: size)
        self.colorBlendFactor = 1
        self.zPosition = 10
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
