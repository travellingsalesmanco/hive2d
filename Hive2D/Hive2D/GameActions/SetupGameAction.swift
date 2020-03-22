//
//  SetupGameAction.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 22/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation
import CoreGraphics

struct SetupGameAction: Codable {
    let playerNetworkingIds: [UUID]
    let hiveStartingLocations: [CGPoint]
    let hiveNetworkingIds: [UUID]
}
