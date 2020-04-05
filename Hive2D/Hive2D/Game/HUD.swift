//
//  HUD.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 4/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    let resourceDisplay = ResourceCountDisplay(size: CGSize(width: 100, height: 100))

    func createHudNodes(size: CGSize, resources: [ResourceType: CGFloat]?) {
        let text = SKLabelNode(text: "Hive2D")
        text.fontName = "AvenirNext-HeavyItalic"
        text.position = CGPoint(x: 0, y: size.height / 2 - text.frame.maxY)
        text.horizontalAlignmentMode = .center
        self.addChild(text)

        // Create palette for choosing type of nodes to build
        let buildNodePalette = BuildNodePalette(color: SKColor.darkGray, size: Constants.BuildNodePalette.size)
        buildNodePalette.position =
            CGPoint(x: size.width / 2 - buildNodePalette.size.width / 2,
                    y: -size.height / 2 + buildNodePalette.size.height / 2)
        self.addChild(buildNodePalette)

        let resourceDisplayPositionY = -size.height / 2 + resourceDisplay.size.height / 2 + buildNodePalette.size.height
        let resourceDisplayPositionX = size.width / 2 - resourceDisplay.size.width / 2
        resourceDisplay.position = CGPoint(x: resourceDisplayPositionX, y: resourceDisplayPositionY)
        updateResourceDisplay(resources: resources)
        self.addChild(resourceDisplay)
    }

    func updateResourceDisplay(resources: [ResourceType: CGFloat]?) {
        resourceDisplay.updateResourceCount(resources: resources)
    }
}
