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
    }

    private func resolveCombat(duration: TimeInterval, game: Game) {
        let attackers = game.query(includes: AttackComponent.self)
        let defenders = game.query(includes: DefenceComponent.self)

        for attacker in attackers {
            guard let attacker = attacker as? CombatNode else {
                continue
            }

            let defendersInRange = defenders.filter { defender in
                guard let defender = defender as? Node else {
                    return true
                }

                let distance = attacker.getPosition().distanceTo(defender.getPosition())
                let range = attacker.getRange() + defender.getNode().radius
                return distance <= range
            }

            for defender in defendersInRange {
                guard let defender = defender as? Node,
                    let defenderDefence = defender.component(ofType: DefenceComponent.self) else {
                    continue
                }

                // Check that attacker is not defender
                guard attacker.getPlayer() != defender.getPlayer() else {
                    continue
                }

                let defenceMultiplier = defenderDefence.shield == 0 ? 1 : 1 / defenderDefence.shield
                defenderDefence.health -= attacker.getAttack() * defenceMultiplier * CGFloat(duration)
            }
        }

        if game.isHost {
            game.clearDestroyedNodes()
        }
    }
}
