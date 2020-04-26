//
//  CombatProjectileSprite.swift
//  Hive2D
//
//  Created by John Phua on 24/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class CombatProjectileSprite: SKSpriteNode {
    init(playerColor: PlayerColor) {
        let texture = SKTexture(imageNamed: Constants.GameAssets.projectile)
        let size = CGSize(width: Constants.GamePlay.projectileRadius,
                          height: Constants.GamePlay.projectileRadius)
        super.init(texture: texture, color: playerColor.getColor(), size: size)

        self.colorBlendFactor = 1
        self.zPosition = 2
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
