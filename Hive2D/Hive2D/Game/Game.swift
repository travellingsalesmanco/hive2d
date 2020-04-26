//
//  Game.swift
//  Hive2D
//
//  Created by Adam Chew Yong Soon on 16/3/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import GameplayKit
import SpriteKit
import NotificationCenter

class Game {
    var entities = Set<GameEntity>()
    var player: Player?
    unowned let scene: GameDelegate
    let config: GameConfig
    let gameNetworking: GameNetworking
    var connectedPlayersCount: Int = 0
    var isHost: Bool
    var gameStarted: Bool = false
    // Time at which last game tick action was called
    var lastGameTick: TimeInterval = 0
    // Time elapsed since game started
    var timeElapsed: TimeInterval = 0
    var terrain: Terrain? {
        didSet {
            scene.setTerrain(terrain: terrain!)
        }
    }

    init(scene: GameDelegate, config: GameConfig, gameNetworking: GameNetworking) {
        self.scene = scene
        self.config = config
        self.gameNetworking = gameNetworking
        self.isHost = config.host.id == config.me.id
        if self.isHost {
            setupTerrain()
        }
    }

    func update(_ dt: TimeInterval) {
        if gameStarted {
            timeElapsed += dt
        }

        handleGameActionsInQueue()

        if isHost {
            sendGameTick()
        }
    }

    func setupTerrain() {
        let cols = Constants.Terrain.numCols
        let rows = Constants.Terrain.numRows
        let tileSize = CGSize(width: config.mapSize / CGFloat(rows),
                                     height: config.mapSize / CGFloat(cols))
        let seed = Int32.random(in: Constants.Terrain.seedRange)
        gameNetworking.sendGameAction(SetupTerrainAction(cols: cols, rows: rows,
                                                         tileSize: tileSize, seed: seed,
                                                         type: config.terrainType))
    }

    func setupGame() {
        let playerNetworkingIds = config.players.map { _ in
            NetworkComponent.generateIdentifier()
        }
        let hiveStartingLocations = config.players.map { _ -> CGPoint in
            var position: CGPoint
            repeat {
                position = CGPoint(x: CGFloat.random(in: config.mapSize / 4 ... config.mapSize * 3 / 4),
                                   y: CGFloat.random(in: config.mapSize / 4 ... config.mapSize * 3 / 4))
            } while(terrain != nil && !terrain!.getTile(at: position)!.isBuildable)
            return position
        }
        let hiveNetworkingIds = hiveStartingLocations.map { _ in
            NetworkComponent.generateIdentifier()
        }
        let playerColors = PlayerColor.pickColors(count: config.players.count)
        gameNetworking.sendGameAction(
            SetupGameAction(playerNetworkingIds: playerNetworkingIds,
                            playerColors: playerColors,
                            hiveStartingLocations: hiveStartingLocations,
                            hiveNetworkingIds: hiveNetworkingIds)
        )
    }

    func buildNode(at point: CGPoint, nodeType: NodeType) {
        guard gameStarted else {
            return
        }

        guard let player = player else {
            return
        }

        if nodeType.isCombatNode() {
            gameNetworking.sendGameAction(
                BuildCombatNodeAction(player: player,
                                      position: point,
                                      netId: NetworkComponent.generateIdentifier(),
                                      nodeType: nodeType)
            )
        } else {
            gameNetworking.sendGameAction(
                BuildResourceNodeAction(player: player,
                                        position: point,
                                        netId: NetworkComponent.generateIdentifier(),
                                        nodeType: nodeType)
            )
        }
    }

    func sendGameTick() {
        let duration = timeElapsed - lastGameTick
        // Send one game tick per second
        guard duration >= 1 else {
            return
        }
        gameNetworking.sendGameAction(GameTickAction(duration: duration))
        lastGameTick += duration
    }

    func add(entity: GameEntity) {
        entities.insert(entity)
        entity.game = self
        entity.didAddToGame()
    }

    func remove(entity: GameEntity) {
        entity.willRemoveFromGame()
        entities.remove(entity)
    }

    func query(includes types: GameComponent.Type...) -> [GameEntity] {
        entities.filter { entity in
            for type in types {
                if entity.component(ofType: type) == nil {
                    return false
                }
            }
            return true
        }
    }

    private func handleGameActionsInQueue() {
        let actions = gameNetworking.gameActionQueue.dequeueAll()
        for action in actions {
            action.handle(game: self)
        }
    }

    func upgradeNode(node: GameEntity) {
        guard let node = node as? Node else {
            return
        }
        gameNetworking.sendGameAction(UpgradeNodeAction(node: node))
    }

    func quit() {
        guard let player = player else {
            return
        }
        gameNetworking.sendGameAction(QuitGameAction(player: player))
    }
}

protocol GameDelegate: SKScene {
    func setTerrain(terrain: Terrain)
}
