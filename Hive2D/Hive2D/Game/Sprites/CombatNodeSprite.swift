//
//  CombatNodeSprite.swift
//  Hive2D
//
//  Created by John Phua on 02/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class CombatNodeSprite: CompositeSprite {
    init(playerColor: PlayerColor) {
        let texture = SKTexture(imageNamed: Constants.GameAssets.combatNode)
        let size = CGSize(width: Constants.GamePlay.nodeRadius,
                          height: Constants.GamePlay.nodeRadius)
        super.init(texture: texture, color: playerColor.getColor(), size: size)
        self.colorBlendFactor = 1
        self.zPosition = 10
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
