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

        func translateX(_ position: CGPoint) -> CGPoint {
            position + CGPoint(x: nodeSize.height * nodeSpacing, y: 0)
        }

        let buttonTypes: [NodeType] = [.ResourceAlpha, .ResourceBeta, .ResourceZeta, .CombatSingle, .CombatMulti]

        for buttonType in buttonTypes {
            let node = BuildNodePaletteButton.createNode(
                image: Constants.GameAssets.nodeTypeToAsset[buttonType]!,
                position: position,
                size: nodeSize,
                name: Constants.BuildNodePalette.nodeTypeToLabel[buttonType]!)
            node.delegate = self
            self.addChild(node)
            buttons.append(node)
            if buttonType == .ResourceAlpha {
                node.setSelected()
            }
            position = translateX(position)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func updateButtonsWithTerrain(terrain: Terrain) {
        for button in buttons {
            let tileAsset: String?
            switch button.name {
            case Constants.BuildNodePalette.resourceAlpha:
                tileAsset = terrain.resourceTypeToTileAsset[.Alpha]
            case Constants.BuildNodePalette.resourceBeta:
                tileAsset = terrain.resourceTypeToTileAsset[.Beta]
            case Constants.BuildNodePalette.resourceZeta:
                tileAsset = terrain.resourceTypeToTileAsset[.Zeta]
            default:
                tileAsset = nil
            }
            guard let tileAssetName = tileAsset else {
                continue
            }
            let tileNode = SKSpriteNode(imageNamed: tileAssetName)

            let shapeNode = SKShapeNode(circleOfRadius: button.size.width / 2 + 10)
            shapeNode.strokeColor = .black
            shapeNode.fillColor = .white

            let cropNode = SKCropNode()
            cropNode.maskNode = shapeNode
            cropNode.addChild(tileNode)
            button.addChild(cropNode)
            cropNode.zPosition = -1
        }
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
