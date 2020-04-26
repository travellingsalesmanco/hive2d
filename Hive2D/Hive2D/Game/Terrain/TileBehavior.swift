//
//  TileBehavior.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 26/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

protocol TileBehavior {
    func run(node: Node, tile: Tile)
}
