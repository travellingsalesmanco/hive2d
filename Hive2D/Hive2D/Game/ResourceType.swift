//
//  ResourceType.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 1/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import CoreGraphics

enum ResourceType: String, Codable {
    case Alpha
    case Beta
    case Gamma
    case Delta
    case Epsilon
    case Zeta

    func getCost() -> CGFloat {
        switch self {
        case .Alpha:
            return 50
        case .Beta:
            return 100
        case .Delta:
            return 150
        case .Epsilon:
            return 200
        case .Gamma:
            return 250
        case .Zeta:
            return CGFloat.infinity
        }
    }

    func getNextTier() -> ResourceType? {
        switch self {
        case .Alpha:
            return .Beta
        case .Beta:
            return .Delta
        case .Delta:
            return .Epsilon
        case .Epsilon:
            return .Gamma
        case .Gamma:
            return .Zeta
        case .Zeta:
            return nil
        }
    }
}
