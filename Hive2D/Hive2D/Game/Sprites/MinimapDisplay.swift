//
//  MinimapDisplay.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 5/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class MinimapDisplay: SKSpriteNode {
    /// Placeholder node to act as parent of all game elements on minimap.
    /// This allows us to scale them separately from other minimap elements (e.g. text)
    var root: SKNode
    var gameElementsRoot: SKCropNode

    init(size: CGSize, mapSize: CGFloat) {
        root = SKNode()
        gameElementsRoot = SKCropNode()
        super.init(texture: nil, color: SKColor.darkGray, size: size)
        root.setScale(size.height / mapSize)
        addChild(root, xOffsetByWidths: -0.5, yOffsetByHeights: -0.5)
        root.addChild(gameElementsRoot)

        let title = SKLabelNode(text: "Minimap")
        title.fontName = "AvenirNext-Regular"
        title.fontSize = 24
        title.fontColor = SKColor.white
        title.position = CGPoint(x: 0, y: size.height / 2 + title.frame.height / 2)
        title.horizontalAlignmentMode = .center
        self.addChild(title)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addMinimapElement(_ sprite: SKNode) {
        gameElementsRoot.addChild(sprite)
    }
}
