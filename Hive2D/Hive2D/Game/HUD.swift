//
//  HUD.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 4/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    func createHudNodes(size: CGSize) {
        let text = SKLabelNode(text: "Hive2D")
        text.fontName = "AvenirNext-HeavyItalic"
        text.position = CGPoint(x: 0, y: size.height / 2 - text.frame.maxY)
        text.horizontalAlignmentMode = .center
        self.addChild(text)

        // Create palette for choosing type of nodes to build
        let buildNodePalette = BuildNodePalette(color: SKColor.darkGray, size: Constants.BuildNodePalette.size)
        buildNodePalette.position =
            CGPoint(x: size.width / 2 - buildNodePalette.size.width / 2 - Constants.BuildNodePalette.margin,
                    y: -size.height / 2 + buildNodePalette.size.height / 2)
        self.addChild(buildNodePalette)
    }
}
