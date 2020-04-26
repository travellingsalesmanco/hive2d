//
//  SKSpriteNode+Extensions.swift
//  Hive2D
//
//  Created by John Phua on 04/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    static func copyOfRendering(node: SKNode) -> SKSpriteNode {
        let texture = SKView().texture(from: node)
        return SKSpriteNode(texture: texture)
    }

    /// Adds `node` as child with its position offset from anchor point by the
    /// given multiples of this node's width/height
    func addChild(_ node: SKNode,
                  xOffsetByWidths: CGFloat, yOffsetByHeights: CGFloat) {
        self.addChild(node)
        node.position = CGPoint(x: self.size.width * xOffsetByWidths, y: self.size.height * yOffsetByHeights)
    }

    /// Adds `node` as child with its position offset from anchor point by the
    /// given multiples of this node's width/height; and its size set to the given ratio of
    /// this node's width and height
    func addChild(_ node: SKNode,
                  xOffsetByWidths: CGFloat, yOffsetByHeights: CGFloat,
                  widthRatio: CGFloat, heightRatio: CGFloat) {
        let currSize = node.calculateAccumulatedFrame().size
        addChild(node, xOffsetByWidths: xOffsetByWidths, yOffsetByHeights: yOffsetByHeights)
        let xScale = self.size.width / currSize.width
        let yScale = self.size.height / currSize.height
        node.xScale = widthRatio * xScale
        node.yScale = heightRatio * yScale
    }
}
