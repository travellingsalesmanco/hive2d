//
//  EdgeSprite.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 4/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class EdgeSprite: SKSpriteNode {

    init(playerColor: PlayerColor) {
        super.init(texture: nil,
                   color: playerColor.getColor(),
                   size: CGSize(width: 1, height: Constants.GamePlay.linkWidth))
        zPosition = 1
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
