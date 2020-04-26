//
//  NodeType.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 1/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

enum NodeType: String, Codable, CaseIterable {
    case ResourceAlpha
    case ResourceBeta
    case ResourceGamma
    case ResourceDelta
    case ResourceEpsilon
    case ResourceZeta
    case CombatSingle
    case CombatMulti

    func isCombatNode() -> Bool {
        return self == .CombatSingle || self == .CombatMulti
    }

    func isResourceNode() -> Bool {
        return !isCombatNode()
    }
}
