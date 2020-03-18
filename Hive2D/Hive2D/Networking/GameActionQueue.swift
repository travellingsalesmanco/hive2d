//
//  GameActionQueue.swift
//  Hive2D
//
//  Created by John Phua on 17/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation
import Firebase

class GameActionQueue {
    private let queue = DispatchQueue(label: "tsco.Hive2D.gameActionQueue", attributes: .concurrent)
    var gameId: String
    var actions: Queue<GameAction>

    init(gameId: String) {
        self.gameId = gameId
        actions = Queue<GameAction>()
    }

    func enqueue(action: GameAction) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            self.actions.enqueue(action)
        }
    }

    func dequeue() -> GameAction? {
        queue.sync {
            self.actions.dequeue()
        }
    }

    func dequeue(upTo num: Int) -> [GameAction] {
        queue.sync {
            self.actions.dequeue(upTo: num)
        }
    }

    var count: Int {
        queue.sync {
            self.actions.count
        }
    }

}
