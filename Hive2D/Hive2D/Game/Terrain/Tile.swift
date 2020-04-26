//
//  Tile.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

/// Terrain tile with properties and an optional effect
class Tile: SKTileGroup {
    let isBuildable: Bool
    let resourceType: ResourceType?
    var effects: [TileEffect]

    init(imageName: String,
         size: CGSize,
         isBuildable: Bool,
         effects: TileEffect...,
         resourceType: ResourceType? = nil) {
        self.isBuildable = isBuildable
        self.resourceType = resourceType
        self.effects = effects
        let texture = SKTexture(imageNamed: imageName)
        let definition = SKTileDefinition(texture: texture, size: size)
        super.init(tileDefinition: definition)
    }

    /// Run the tile effects on the node
    func handle(node: Node) {
        effects.forEach { $0.run(node: node, tile: self) }
    }

    /// Add tile effect
    func addEffect(_ toAdd: TileEffect...) {
        effects.append(contentsOf: toAdd)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
