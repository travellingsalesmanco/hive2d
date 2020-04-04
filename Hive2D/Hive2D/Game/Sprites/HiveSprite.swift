//
//  HiveSprite.swift
//  Hive2D
//
//  Created by John Phua on 02/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class HiveSprite: CompositeSprite {
    init(playerColor: PlayerColor) {
        let texture = SKTexture(imageNamed: Constants.GameAssets.hive)
        super.init(texture: texture, color: playerColor.getColor(), size: texture.size())
        self.colorBlendFactor = 1
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
