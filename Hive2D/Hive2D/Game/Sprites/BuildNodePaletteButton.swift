//
//  BuildNodePaletteButton.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 5/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class BuildNodePaletteButton: SKSpriteNode {
    weak var delegate: BuildNodePaletteButtonDelegate?

    static func createNode(image: String, position: CGPoint, size: CGSize, name: String) -> BuildNodePaletteButton {
        let node = BuildNodePaletteButton(texture: SKTexture(imageNamed: image))
        node.size = size
        node.position = position
        node.name = name
        let label = SKLabelNode(text: name)
        label.position = CGPoint(x: 0, y: node.size.height / 2 + Constants.BuildNodePalette.nodePadding)
        label.fontName = "AvenirNext-Bold"
        label.fontColor = SKColor.white
        label.fontSize = 15
        node.addChild(label)
        node.zPosition = 10
        return node
    }

    func setSelected() {
        self.color = SKColor.yellow
        self.colorBlendFactor = 0.6
        delegate?.buttonDidSelect(selected: self)
    }

    func setUnselected() {
        self.color = SKColor.white
        self.colorBlendFactor = 0.6
    }
}

protocol BuildNodePaletteButtonDelegate: AnyObject {
    func buttonDidSelect(selected: BuildNodePaletteButton)
}
