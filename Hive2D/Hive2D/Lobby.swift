//
//  Lobby.swift
//  Hive2D
//
//  Created by John Phua on 14/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

struct Lobby: Codable {
    var id: UUID?
    // Code to join game
    var code: String?
    // TODO: TBC on host structure
    var host: String?
    var players: [String]?
    // TODO: implement actual settings
    var settings: String?
    var started: Bool = false
}
