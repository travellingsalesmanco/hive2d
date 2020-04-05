//
//  GameConfig.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import CoreGraphics

struct NodeCostMap {
    var mapping = [NodeType: [ResourceType: CGFloat]]()

    init() {
        for nodeType in NodeType.allCases {
            switch nodeType {
            case .ResourceAlpha:
                mapping[nodeType] = [.Alpha: 30]
            case .ResourceBeta:
                mapping[nodeType] = [.Alpha: 50]
            case .ResourceZeta:
                mapping[nodeType] = [.Alpha: 30, .Beta: 30]
            case .Combat:
                mapping[nodeType] = [.Zeta: 50]
            default:
                continue
            }
        }
    }

    func getResourceCosts(for nodeType: NodeType) -> [ResourceType: CGFloat]? {
        return mapping[nodeType]
    }
}

struct GameConfig {
    let id: String
    let host: GamePlayer
    let me: GamePlayer
    let players: [GamePlayer]
    let mapSize: CGSize
    let resourceCollectionRate: CGFloat
    let resourceConsumptionRate: CGFloat
    let nodeCostMap = NodeCostMap()
    let tierUpgradeCost: CGFloat
    let maxTier: CGFloat

    init(lobby: Lobby, me: GamePlayer) {
        self.id = lobby.id
        self.me = me
        self.host = lobby.host
        self.players = lobby.players

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
        self.tierUpgradeCost = Constants.GamePlay.tierUpgradeCost
        self.maxTier = Constants.GamePlay.maxTier
    }
}
