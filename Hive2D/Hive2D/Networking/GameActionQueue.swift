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
    private var bufferQueue: Heap<GameAction>

    init(gameId: String) {
        self.gameId = gameId
        bufferQueue = Heap<GameAction>()
    }

    func enqueue(action: GameAction, priority: String) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            self.bufferQueue.insert(action, priority: priority)
        }
    }

    func dequeue() -> GameAction? {
        queue.sync {
            self.bufferQueue.remove()
        }
    }

    func dequeue(upTo num: Int) -> [GameAction] {
        queue.sync {
            self.bufferQueue.remove(upTo: num)
        }
    }

    func dequeueAll() -> [GameAction] {
        queue.sync {
            bufferQueue.remove(upTo: bufferQueue.count)
        }
    }

    var count: Int {
        queue.sync {
            self.bufferQueue.count
        }
    }

}
