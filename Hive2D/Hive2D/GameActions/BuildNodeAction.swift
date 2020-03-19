//
//  BuildNodeAction.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import CoreGraphics

struct BuildNodeAction: Codable {
    let playerId: String
    let playerName: String
    let position: CGPoint
}
