//
//  ResourceComponent.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 17/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class ResourceComponent: GameComponent {
    private static var nodeCostMap = NodeCostMap()
    var resources = [ResourceType: CGFloat]()

    init(alpha: CGFloat = 0,
         beta: CGFloat = 0,
         gamma: CGFloat = 0,
         delta: CGFloat = 0,
         epsilon: CGFloat = 0,
         zeta: CGFloat = 0) {

        self.resources[.Alpha] = alpha
        self.resources[.Beta] = beta
        self.resources[.Gamma] = gamma
        self.resources[.Delta] = delta
        self.resources[.Epsilon] = epsilon
        self.resources[.Zeta] = zeta
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func hasSufficientResources(nodeType: NodeType) -> Bool {
        guard let nodeCosts = ResourceComponent.nodeCostMap.getResourceCosts(for: nodeType) else {
            return false
        }

        // Check that all resources required to build node are available in player's resources
        for (resourceType, amountRequired) in nodeCosts {
            guard let amountAvailable = resources[resourceType] else {
                return false
            }
            if amountAvailable < amountRequired {
                return false
            }
        }
        return true
    }

    func consumeResourcesToBuild(nodeType: NodeType) {
        guard let nodeCosts = ResourceComponent.nodeCostMap.getResourceCosts(for: nodeType) else {
            return
        }

        guard hasSufficientResources(nodeType: nodeType) else {
            return
        }

        for (resourceType, amountRequired) in nodeCosts {
            guard let amountAvailable = resources[resourceType] else {
                return
            }
            resources[resourceType] = amountAvailable - amountRequired
        }
    }
}
