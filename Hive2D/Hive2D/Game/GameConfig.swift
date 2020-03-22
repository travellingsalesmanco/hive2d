//
//  GameConfig.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import CoreGraphics

struct GameConfig {
    let id: String
    let host: GamePlayer
    let me: GamePlayer
    let players: [GamePlayer]
    let mapSize: CGSize
    let resourceCollectionRate: CGFloat
    let resourceConsumptionRate: CGFloat

    init(lobby: Lobby, me: GamePlayer) {
        self.id = lobby.id
        self.me = me
        self.host = lobby.host
        self.players = Array(lobby.players.values)

        switch lobby.settings.mapSize {
        case .small:
            self.mapSize = Constants.GameConfig.smallMapSize
        case .medium:
            self.mapSize = Constants.GameConfig.mediumMapSize
        case .large:
            self.mapSize = Constants.GameConfig.largeMapSize
        }

        switch lobby.settings.resourceRate {
        case .normal:
            self.resourceCollectionRate = Constants.GameConfig.normalResourceCollectionRate
            self.resourceConsumptionRate = Constants.GameConfig.normalResourceConsumptionRate
        case .fast:
            self.resourceCollectionRate = Constants.GameConfig.fastResourceCollectionRate
            self.resourceConsumptionRate = Constants.GameConfig.fastResourceConsumptionRate
        }
    }
}
