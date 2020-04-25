//
//  GameTickAction.swift
//  Hive2D
//
//  Created by Yu Jia Tay on 2/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit

struct GameTickAction: GameAction {
    let duration: TimeInterval

    func handle(game: Game) {
        guard duration > 0 else {
            return
        }
        game.entities.forEach {
            $0.update(deltaTime: duration)
        }
        resolveCombat(duration: duration, game: game)
        clearHitProjectiles(game: game)
    }

    private func resolveCombat(duration: TimeInterval, game: Game) {
        let attackers = game.query(includes: AttackComponent.self)
        let defenders = game.query(includes: DefenceComponent.self)

        for attacker in attackers {
            guard let attacker = attacker as? CombatNode else {
                continue
            }

            var nearestTarget: Node?
            var minDistance = CGFloat.greatestFiniteMagnitude
            defenders.forEach { defender in
                guard let defender = defender as? Node else {
                    return
                }

                // Check that attacker is not defender
                guard attacker.getPlayer() != defender.getPlayer() else {
                    return
                }

                let distance = attacker.getPosition().distanceTo(defender.getPosition())
                let range = attacker.getRange() + defender.getNode().radius

                guard distance <= range else {
                    return
                }

                if distance < minDistance {
                    minDistance = distance
                    nearestTarget = defender
                }
            }

            guard let defender = nearestTarget,
                let defenderDefence = defender.component(ofType: DefenceComponent.self) else {
                continue
            }

            let defenceMultiplier = defenderDefence.shield == 0 ? 1 : 1 / defenderDefence.shield
            defenderDefence.health -= attacker.getAttack() * defenceMultiplier * CGFloat(duration)

            // Add projectile
            game.add(entity: createProjectile(from: attacker, to: defender))
        }

        if game.isHost {
            game.clearDestroyedNodes()
        }
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

    private func clearHitProjectiles(game: Game) {
        let movingObjects = game.query(includes: MovementComponent.self)
        for object in movingObjects {
            guard let projectile = object as? CombatProjectile else {
                continue
            }
            guard let movement = projectile.component(ofType: MovementComponent.self) else {
                continue
            }
            if movement.completed {
                game.remove(entity: projectile)
            }
        }
    }
}
