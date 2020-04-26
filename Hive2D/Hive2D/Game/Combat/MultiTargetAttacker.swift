//
//  MultiTargetAttacker.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 26/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

struct MultiTargetAttacker: Attacker {
    let damagePerSecond: CGFloat
    let range: CGFloat
    let position: CGPoint

    func attack(enemyNodes: [Node], for duration: TimeInterval) -> [Node] {
        let enemyNodesInRange = getEnemyNodesInRange(enemyNodes: enemyNodes)

        for enemyNode in enemyNodesInRange {
            applyDamage(to: enemyNode, duration: duration)
        }

        return enemyNodesInRange
    }
}
