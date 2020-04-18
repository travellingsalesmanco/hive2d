//
//  DestroyNodeAction.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

struct DestroyNodeAction: GameAction {
    // TODO: Change to node entity
    let nodeNetId: NetworkComponent.Identifier

    func handle(game: Game) {
        guard let node = NetworkComponent.getEntity(for: nodeNetId) else {
            return
        }
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
