//
//  MinimapDisplay.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 5/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class MinimapDisplay: SKSpriteNode {
    let scaleFactor: CGFloat
    private var currentSprites = [SKSpriteNode: SKSpriteNode]()

    init(size: CGSize, mapSize: CGFloat) {
        scaleFactor = size.height / mapSize
        super.init(texture: nil, color: SKColor.darkGray, size: size)

        let title = SKLabelNode(text: "Minimap")
        title.fontName = "AvenirNext-Regular"
        title.fontSize = 24
        title.fontColor = SKColor.white
        title.position = CGPoint(x: 0, y: size.height / 2 + title.frame.height / 2)
        title.horizontalAlignmentMode = .center
        self.addChild(title)
    }

    required init?(coder aDecoder: NSCoder) {
        scaleFactor = CGFloat(1)
        super.init(coder: aDecoder)
    }

    func updateSpritePositions(_ sprites: [SKSpriteNode]) {
        let spriteSet = Set(sprites)
        let currentSpriteSet = Set(currentSprites.keys)
        let newSprites = spriteSet.subtracting(currentSpriteSet)
        let staleSprites = currentSpriteSet.subtracting(spriteSet)
        newSprites.forEach {
            let minimapSprite = SKSpriteNode(texture: $0.texture, color: $0.color, size: $0.size)
            minimapSprite.setScale(scaleFactor)
            minimapSprite.position = CGPoint(
                x: $0.position.x * scaleFactor - size.width / 2,
                y: $0.position.y * scaleFactor - size.height / 2
            )
            currentSprites[$0] = minimapSprite
            addChild(minimapSprite)
        }
        staleSprites.forEach {
            currentSprites[$0]?.removeFromParent()
            currentSprites.removeValue(forKey: $0)
        }
    }
}
