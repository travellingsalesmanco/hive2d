//
//  NodeCostMap.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 23/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

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
        mapping[nodeType]
    }
}
