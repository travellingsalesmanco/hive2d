//
//  Attacker.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 26/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

protocol Attacker {
    var damagePerSecond: CGFloat { get }
    var range: CGFloat { get }
    var position: CGPoint { get }

    /// Attacks enemy nodes based on specified combat behavior and returns those nodes that were attacked
    func attack(enemyNodes: [Node], for duration: TimeInterval) -> [Node]
}

extension Attacker {
    func getEnemyNodesInRange(enemyNodes: [Node]) -> [Node] {
        func distanceToNode(node: Node) -> CGFloat {
            position.distanceTo(node.getPosition())
        }

        return enemyNodes
            .sorted(by: { distanceToNode(node: $0) < distanceToNode(node: $1) })
            .filter({ distanceToNode(node: $0) <= range })
    }

    func getTotalDamage(duration: TimeInterval) -> CGFloat {
        damagePerSecond * CGFloat(duration)
    }

    func applyDamage(to target: Node, duration: TimeInterval) {
        guard let targetDefence = target.component(ofType: DefenceComponent.self) else {
            return
        }
        targetDefence.health -= getTotalDamage(duration: duration) * targetDefence.getShieldMultiplier()
    }
}
