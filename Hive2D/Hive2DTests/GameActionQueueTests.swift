//
//  GameActionQueueTests.swift
//  Hive2DTests
//
//  Created by John Phua on 22/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

import XCTest
@testable import Hive2D

class GameActionQueueTests: XCTestCase {

    func testEmpty() {
        let queue = GameActionQueue(gameId: "dummy")
        XCTAssertEqual(queue.count, 0, "Queue not empty at start")
        XCTAssertTrue(queue.dequeue() == nil, "Queue not empty at start")
    }

    func testInputSerial() {
        let queue = GameActionQueue(gameId: "dummy")
        queue.enqueue(action: GameTickAction(duration: 0))
        queue.enqueue(action: GameTickAction(duration: 10))
        XCTAssertEqual(queue.count, 2, "Items not added")
        guard let action = queue.dequeue() as? GameTickAction else {
            XCTFail("Did not get back action")
            return
        }
        XCTAssertEqual(action.duration, 0, "Actions not in FIFO Order")
    }

    func testInputParallel() {
        let queue = GameActionQueue(gameId: "dummy")
        let group = DispatchGroup()
        var durations: Set<TimeInterval> = Set()
        for i in 0..<100 {
            durations.insert(TimeInterval(i))
        }

        for duration in durations {
            group.enter()
            DispatchQueue.global().async {
                queue.enqueue(action: GameTickAction(duration: duration))
                group.leave()
            }
        }
        group.wait()
        XCTAssertEqual(queue.count, 100, "Some items were dropped not added")

        let actions = queue.dequeue(upTo: 100)

        var deqDurations: Set<TimeInterval> = Set()

        for gameAction in actions {
            guard let action = gameAction as? GameTickAction else {
                XCTFail("Did not get back action")
                return
            }
            deqDurations.insert(action.duration)
        }
        XCTAssertEqual(deqDurations, durations, "Items not equal")
    }
}
