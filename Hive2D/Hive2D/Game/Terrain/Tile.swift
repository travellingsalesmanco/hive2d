//
//  Tile.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import SpriteKit

/// Contract for terrain tiles with added properties
class Tile: SKTileGroup {
    let isBuildable: Bool
    let resourceType: ResourceType?

    init(imageName: String,
         size: CGSize,
         isBuildable: Bool,
         resourceType: ResourceType?) {
        self.isBuildable = isBuildable
        self.resourceType = resourceType
        let texture = SKTexture(imageNamed: imageName)
        let definition = SKTileDefinition(texture: texture, size: size)
        super.init(tileDefinition: definition)
    }

    func boostResourceCollectionRate(resourceType: ResourceType,
                                     resourceCollectionRate: CGFloat) -> CGFloat {
        if resourceType == self.resourceType {
            return resourceCollectionRate * 2
        }
        return resourceCollectionRate
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
