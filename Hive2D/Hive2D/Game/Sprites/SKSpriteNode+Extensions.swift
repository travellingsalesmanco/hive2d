//
//  SKSpriteNode+Extensions.swift
//  Hive2D
//
//  Created by John Phua on 04/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {

    func addSprite(sprite: SKNode, xOffset: CGFloat, yOffset: CGFloat) {
        self.addChild(sprite)
        sprite.position = CGPoint(x: self.size.width * xOffset, y: self.size.height * yOffset)
    }

    func addSprite(sprite: SKNode, xOffset: CGFloat, yOffset: CGFloat, xRatio: CGFloat? = nil, yRatio: CGFloat? = nil) {
        let currSize = sprite.calculateAccumulatedFrame().size
        let xScale = self.size.width / currSize.width
        let yScale = self.size.height / currSize.height
        addSprite(sprite: sprite, xOffset: xOffset, yOffset: yOffset)
        if let xRatio = xRatio {
            sprite.xScale = xRatio * xScale
        }
        if let yRatio = yRatio {
            sprite.yScale = yRatio * yScale
        }
    }
}
