//
//  BoostResourceBehavior.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 26/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

/// Boost the resource collection rate of a node if its resource type matches the tile's resource type
struct BoostResourceBehavior: TileBehavior {
    let boost: CGFloat

    init(boost: CGFloat) {
        self.boost = boost
    }

    func run(node: Node, tile: Tile) {
        guard let resourceType = node.component(ofType: ResourceCollectorComponent.self)?.resourceType else {
            return
        }
        if tile.resourceType == resourceType {
            node.component(ofType: ResourceCollectorComponent.self)?.resourceCollectionRate *= boost
        }
    }
}
