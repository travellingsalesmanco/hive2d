//
//  GameActionQueue.swift
//  Hive2D
//
//  Created by John Phua on 17/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation

class GameActionQueue {
    private let queue = DispatchQueue(label: "tsco.Hive2D.gameActionQueue", attributes: .concurrent)
    private(set) var gameId: String
    private var actions: Queue<GameAction>

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
            actions.dequeue()
        }
    }

    func dequeue(upTo num: Int) -> [GameAction] {
        queue.sync {
            actions.dequeue(upTo: num)
        }
    }

    func dequeueAll() -> [GameAction] {
        queue.sync {
            actions.dequeue(upTo: actions.count)
        }
    }

    var count: Int {
        queue.sync {
            actions.count
        }
    }

}
