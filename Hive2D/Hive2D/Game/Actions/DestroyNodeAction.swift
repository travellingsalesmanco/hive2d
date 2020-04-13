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
        guard let position = node.component(ofType: NodeComponent.self)?.position else {
            return
        }
        let edges = game.query(includes: PathComponent.self)
        let connectedEdges = edges.filter { edge in
            guard let path = edge.component(ofType: PathComponent.self) else {
                return false
            }
            if path.start == position || path.end == position {
                return true
            }
            return false
        }
        connectedEdges.forEach { game.remove(entity: $0) }
        game.remove(entity: node)
    }
}
