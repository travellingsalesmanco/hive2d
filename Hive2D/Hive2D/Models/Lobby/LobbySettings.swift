//
//  LobbySettings.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

enum MapSize: Int, Codable {
    case small = 0
    case medium = 1
    case large = 2
}

enum ResourceRate: Int, Codable {
    case normal = 0
    case fast = 1
}

struct LobbySettings: Codable {
    var mapSize: MapSize
    var resourceRate: ResourceRate

    init() {
        self.mapSize = .small
        self.resourceRate = .normal
    }
}
