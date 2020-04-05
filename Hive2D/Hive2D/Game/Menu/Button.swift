//
//  Button.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 5/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class Button: SKSpriteNode {

    init(position: CGPoint,
         size: CGSize,
         label: String,
         name: String,
         color: UIColor = #colorLiteral(red: 0.2354771495, green: 0.7054982781, blue: 0.3705690503, alpha: 1),
         fontName: String = "Avenir-Medium",
         fontSize: CGFloat = 20) {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let shape = SKShapeNode(rect: rect, cornerRadius: 10)
        shape.fillColor = color
        let texture = SKView().texture(from: shape)
        super.init(texture: texture, color: color, size: size)
        self.zPosition = 10
        self.name = name
        setUserInteraction(true)

        let labelNode = SKLabelNode(text: label)
        labelNode.name = "\(name)Label"
        labelNode.verticalAlignmentMode = .center
        labelNode.horizontalAlignmentMode = .center
        labelNode.fontName = fontName
        labelNode.fontSize = fontSize
        labelNode.zPosition = 1
        self.addChild(labelNode)
    }

    func setUserInteraction(_ bool: Bool) {
        isUserInteractionEnabled = bool
        if isUserInteractionEnabled {
            alpha = 1
        } else {
            alpha = 0.5
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
