//
//  LobbySettings.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

enum MapSize: String, Codable {
    case small
    case medium
    case large
}

enum ResourceRate: String, Codable {
    case normal
    case fast
}

struct LobbySettings: Codable {
    var mapSize: MapSize
    var resourceRate: ResourceRate

    init() {
        self.mapSize = .small
        self.resourceRate = .normal
    }
}
