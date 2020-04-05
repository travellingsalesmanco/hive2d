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

        // Display resource count for player
        let resourceDisplayPositionY = -size.height / 2 + resourceDisplay.size.height / 2 + buildNodePalette.size.height
        let resourceDisplayPositionX = size.width / 2 - resourceDisplay.size.width / 2
        resourceDisplay.position = CGPoint(x: resourceDisplayPositionX, y: resourceDisplayPositionY)
        updateResourceDisplay(resources: resources)
        self.addChild(resourceDisplay)

        let quitGameButton = Button(position: CGPoint(x: -size.width / 2, y: size.height / 2),
                                    size: CGSize(width: 100, height: 30),
                                    label: "Quit Game",
                                    name: "QuitGame",
                                    color: UIColor.red)
        quitGameButton.position = CGPoint(x: -size.width / 2 + quitGameButton.size.width,
                                          y: size.height / 2 - quitGameButton.size.height)
        self.addChild(quitGameButton)
    }

    func updateResourceDisplay(resources: [ResourceType: CGFloat]?) {
        resourceDisplay.updateResourceCount(resources: resources)
    }
}
