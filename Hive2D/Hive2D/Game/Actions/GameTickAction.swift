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
        var defenderNodes: [Node] = []
        defenders.forEach { defender in
            if let defenderNode = defender as? Node {
                defenderNodes.append(defenderNode)
            }
        }

        for attacker in attackers {
            guard let attackComponent = attacker.component(ofType: AttackComponent.self) else {
                continue
            }

            let combatProjectiles = attackComponent.handle(defenderNodes: defenderNodes, duration: duration)
            combatProjectiles.forEach { projectile in
                game.add(entity: projectile)
            }
        }

        destroyZeroHealthNodes(game: game)
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

    private func destroyZeroHealthNodes(game: Game) {
        let nodes = game.query(includes: DefenceComponent.self, NodeComponent.self)
        nodes.filter {
            $0.component(ofType: DefenceComponent.self)!.health <= 0
        }.forEach {
            destroyNode(game: game, node: $0)
        }
    }

    private func destroyNode(game: Game, node: GameEntity) {
        let edges = game.query(includes: PathComponent.self)
        let connectedEdges = edges.filter { edge in
            guard let path = edge.component(ofType: PathComponent.self) else {
                return false
            }
            return path.start == node || path.end == node
        }
        connectedEdges.forEach { game.remove(entity: $0) }
        game.remove(entity: node)
    }
}
