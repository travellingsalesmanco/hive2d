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
         size: CGSize) {
        super.init(fontNamed: fontName)
        self.position = position
        self.zPosition = 10
        self.text = text
        self.name = name
        self.color = color
        adjustFontSizeToFit(rect: CGRect(origin: CGPoint.zero, size: size))
    }

    func adjustFontSizeToFit(rect: CGRect) {
        let padding = CGFloat(20)
        let scalingFactor = min(rect.width / (frame.width + padding), rect.height / (frame.height + padding))
        fontSize *= scalingFactor

    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
