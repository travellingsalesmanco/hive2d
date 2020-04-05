//
//  Label.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 5/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

class Label: SKLabelNode {

    override init() {
        super.init()
    }

    init(position: CGPoint,
         text: String,
         name: String,
         color: UIColor = .white,
         fontName: String = "Avenir-Heavy",
         fontSize: CGFloat = 20) {
        super.init(fontNamed: fontName)
        self.position = position
        self.zPosition = 10
        self.text = text
        self.name = name
        self.color = color
        self.fontSize = fontSize
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
