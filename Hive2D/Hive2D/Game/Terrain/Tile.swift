//
//  Tile.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

/// Terrain tile with properties and an optional behavior
class Tile: SKTileGroup {
    let isBuildable: Bool
    let resourceType: ResourceType?
    let behavior: TileBehavior?

    init(imageName: String,
         size: CGSize,
         isBuildable: Bool,
         behavior: TileBehavior?,
         resourceType: ResourceType?) {
        self.isBuildable = isBuildable
        self.resourceType = resourceType
        self.behavior = behavior
        let texture = SKTexture(imageNamed: imageName)
        let definition = SKTileDefinition(texture: texture, size: size)
        super.init(tileDefinition: definition)
    }

    convenience init(imageName: String, size: CGSize, isBuildable: Bool) {
        self.init(imageName: imageName, size: size, isBuildable: isBuildable, behavior: nil, resourceType: nil)
    }

    /// Tile Effect
    func handle(node: Node) {
        guard let behavior = self.behavior else {
            return
        }
        behavior.run(node: node, tile: self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
