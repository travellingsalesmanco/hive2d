//
//  ResourceBarSprite.swift
//  Hive2D
//
//  Created by John Phua on 04/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class ResourceBarSprite: SKNode {
    var background: SKSpriteNode
    var bar: SKSpriteNode
    var progress: CGFloat {
        didSet {
            let value = max(min(progress, 1.0), 0.0)
            bar.xScale = value
        }
    }

    init(color: UIColor) {
        let barSize = CGSize(width: 1_000, height: 10)
        self.background = SKSpriteNode(color: UIColor.white, size: barSize)
        self.bar = SKSpriteNode(color: color, size: barSize)
        bar.xScale = 0.0
        bar.zPosition = 1_000.0
        background.zPosition = 999.0
        bar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        background.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        self.progress = 1
        super.init()

        addChild(background)
        addChild(bar)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
