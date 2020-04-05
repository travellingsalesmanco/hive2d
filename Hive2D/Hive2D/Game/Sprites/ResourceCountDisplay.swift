//
//  ResourceCountDisplay.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 5/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class ResourceCountDisplay: SKSpriteNode {
    var resourceToNode = [ResourceType: SKLabelNode]()
    private var offsetY = CGFloat.zero

    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    convenience init(size: CGSize) {
        self.init(color: SKColor.darkGray, size: size)

        let title = SKLabelNode(text: "Resources")
        title.fontName = "AvenirNext-Regular"
        title.fontSize = 12
        title.position = CGPoint(x: -size.width / 2 + title.frame.width / 2, y: size.height / 2 - title.frame.height)
        title.horizontalAlignmentMode = .center
        self.addChild(title)
        offsetY += title.frame.height
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func updateResourceCount(resources: [ResourceType: CGFloat]?) {
        guard let resources = resources else {
            return
        }

        for (type, amount) in resources.sorted(by: { $0.0.rawValue < $1.0.rawValue }) {
            if let node = resourceToNode[type] {
                node.text = getResourceCountString(resource: type.rawValue, amount: amount)
            } else {
                let resourceRow = createNode(type: type, amount: amount)
                resourceRow.position = CGPoint(x: -size.width / 2,
                                               y: size.height / 2 - resourceRow.frame.height - offsetY)
                self.addChild(resourceRow)
                resourceToNode[type] = resourceRow
                offsetY += resourceRow.frame.height
            }

        }
    }

    private func createNode(type: ResourceType, amount: CGFloat) -> SKLabelNode {
        let label = getResourceCountString(resource: type.rawValue, amount: amount)
        let node = SKLabelNode(text: label)
        node.fontName = "AvenirNext-Regular"
        node.fontSize = 12
        node.horizontalAlignmentMode = .left
        return node
    }

    private func getResourceCountString(resource: String, amount: CGFloat) -> String {
        resource + ": " + String(Int(amount))
    }
}
