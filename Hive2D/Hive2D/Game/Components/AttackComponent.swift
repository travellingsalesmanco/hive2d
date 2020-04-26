//
//  AttackComponent.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 1/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

class AttackComponent: GameComponent {
    var attacker: Attacker

    init(attacker: Attacker) {
        self.attacker = attacker
        super.init()
    }

    func handle(defenderNodes: [Node], duration: TimeInterval) -> [CombatProjectile] {
        let enemyNodes = filterEnemyNodes(nodes: defenderNodes)
        let targets = attacker.attack(enemyNodes: enemyNodes, for: duration)
        return createProjectiles(for: targets)
    }

    private func filterEnemyNodes(nodes: [Node]) -> [Node] {
        guard let combatNode = entity as? CombatNode else {
            return []
        }
        return nodes.filter({ combatNode.getPlayer() != $0.getPlayer() })
    }

    private func createProjectiles(for targets: [Node]) -> [CombatProjectile] {
        guard let combatNode = entity as? CombatNode else {
            return []
        }

        return targets.compactMap({ target in
            guard let defence = target.component(ofType: DefenceComponent.self) else {
                return nil
            }

            // Do not create projectile if target node already has health <= 0
            // This is needed because our logic currently deals damage before firing projectile.
            guard defence.health > 0 else {
                return nil
            }
            return createProjectile(from: combatNode, to: target)

        })
    }

    private func createProjectile(from source: CombatNode, to target: Node) -> CombatProjectile {
        let player = source.getPlayer()
        let projectileSprite = CombatProjectileSprite(playerColor: player.getColor())
        let spriteComponent = SpriteComponent(spriteNode: projectileSprite)
        let transformComponent = TransformComponent(position: source.getPosition(), scale: (1, 1), rotation: 0)
        let movementComponent = MovementComponent(start: source,
                                                  end: target,
                                                  progressPerTick: Constants.GamePlay.projectileSpeed)
        let playerComponent = PlayerComponent(player: player)
        return CombatProjectile(sprite: spriteComponent,
                                transform: transformComponent,
                                movement: movementComponent,
                                player: playerComponent)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
