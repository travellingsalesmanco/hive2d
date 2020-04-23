//
//  DestroyNodeAction.swift
//  Hive2D
//
//  Created by John Phua on 15/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

struct DestroyNodeAction: GameAction {
    let node: Node

    init(node: Node) {
        self.node = node
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let node = try container.decode(using: EntityFactory(), forKey: .node) as? Node else {
            throw DecodingError.valueNotFound(
                Node.Type.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Entity cannot be casted as Node."))
        }
        self.node = node
    }

    func handle(game: Game) {
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
