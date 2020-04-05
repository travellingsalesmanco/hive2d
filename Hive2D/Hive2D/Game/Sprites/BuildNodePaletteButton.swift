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

    func setSelected() {
        self.color = SKColor.yellow
        self.colorBlendFactor = 1
        delegate?.buttonDidSelect(selected: self)
    }

    func setUnselected() {
        self.color = SKColor.white
        self.colorBlendFactor = 1
    }
}

protocol BuildNodePaletteButtonDelegate: AnyObject {
    func buttonDidSelect(selected: BuildNodePaletteButton)
}
