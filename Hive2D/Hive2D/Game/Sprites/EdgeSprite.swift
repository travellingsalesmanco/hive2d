//
//  EdgeSprite.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 4/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class EdgeSprite: SKSpriteNode {
    init(from: CGPoint, to: CGPoint, playerColor: PlayerColor) {
        let path = CGMutablePath()
        path.move(to: from)
        path.addLine(to: to)

        let shapeNode = SKShapeNode(path: path)
        shapeNode.strokeColor = playerColor.getColor()
        shapeNode.glowWidth = Constants.GamePlay.linkGlowWidth

        let texture = SKView().texture(from: shapeNode)
        super.init(texture: texture, color: shapeNode.strokeColor, size: texture!.size())
        self.position = CGPoint(x: (from.x + to.x) / 2,
                                y: (from.y + to.y) / 2)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
