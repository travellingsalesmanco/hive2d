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
        let size = CGSize(width: Constants.GamePlay.hiveRadius,
                          height: Constants.GamePlay.hiveRadius)
        super.init(texture: texture, color: playerColor.getColor(), size: size)
        self.colorBlendFactor = 1
        self.zPosition = 10
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
