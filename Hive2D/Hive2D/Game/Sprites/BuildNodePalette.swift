//
//  BuildNodePalette.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 4/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class BuildNodePalette: SKSpriteNode {
    var buttons = [BuildNodePaletteButton]()

    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)

        let nodeSize = Constants.BuildNodePalette.nodeSize
        let nodeSpacing = Constants.BuildNodePalette.nodeSpacing
        let leftmostX = -self.size.width / 2 + nodeSize.height / 2 + Constants.BuildNodePalette.padding

        var position = CGPoint(x: leftmostX + nodeSize.height * 0 * nodeSpacing,
                               y: -Constants.BuildNodePalette.nodePadding)
        let resourceAlpha = createNode(image: Constants.GameAssets.resourceNode,
                                       position: position,
                                       size: nodeSize,
                                       name: Constants.BuildNodePalette.resourceAlpha)
        self.addChild(resourceAlpha)
        resourceAlpha.setSelected()

        position.x += nodeSize.height * nodeSpacing
        let resourceBeta = createNode(image: Constants.GameAssets.resourceNode,
                                      position: position,
                                      size: nodeSize,
                                      name: Constants.BuildNodePalette.resourceBeta)
        self.addChild(resourceBeta)

        position.x += nodeSize.height * nodeSpacing
        let resourceZeta = createNode(image: Constants.GameAssets.resourceNode,
                                      position: position,
                                      size: nodeSize,
                                      name: Constants.BuildNodePalette.resourceZeta)
        self.addChild(resourceZeta)

        position.x += nodeSize.height * nodeSpacing
        let combatNode = createNode(image: Constants.GameAssets.combatNode,
                                    position: position,
                                    size: nodeSize,
                                    name: Constants.BuildNodePalette.combat)
        self.addChild(combatNode)

        buttons.append(contentsOf: [resourceAlpha, resourceBeta, resourceZeta, combatNode])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func createNode(image: String, position: CGPoint, size: CGSize, name: String) -> BuildNodePaletteButton {
        let node = BuildNodePaletteButton(texture: SKTexture(imageNamed: image))
        node.delegate = self
        node.size = size
        node.position = position
        node.name = name
        let label = SKLabelNode(text: name)
        label.position = CGPoint(x: 0, y: node.size.height / 2 + Constants.BuildNodePalette.nodePadding)
        label.fontName = "AvenirNext-Bold"
        label.fontColor = SKColor.white
        label.fontSize = 15
        node.addChild(label)
        return node
    }
}

extension BuildNodePalette: BuildNodePaletteButtonDelegate {
    func buttonDidSelect(selected: BuildNodePaletteButton) {
        buttons.forEach {
            if $0 !== selected {
                $0.setUnselected()
            }
        }
    }
}
