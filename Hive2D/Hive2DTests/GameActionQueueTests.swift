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
        let firstId = UUID()
        queue.enqueue(action: .DestroyNode(action: DestroyNodeAction(nodeNetId: firstId)))
        queue.enqueue(action: .DestroyNode(action: DestroyNodeAction(nodeNetId: UUID())))
        XCTAssertEqual(queue.count, 2, "Items not added")
        guard case let .DestroyNode(action) = queue.dequeue() else {
            XCTFail("Did not get back action")
            return
        }
        XCTAssertEqual(action.nodeNetId, firstId, "Queue not empty at start")
    }

    func testInputParallel() {
        let queue = GameActionQueue(gameId: "dummy")
        let group = DispatchGroup()
        var ids: Set<UUID> = Set()
        for _ in 0..<100 {
            ids.insert(UUID())
        }

        for id in ids {
            group.enter()
            DispatchQueue.global().async {
                queue.enqueue(action: .DestroyNode(action: DestroyNodeAction(nodeNetId: id)))
                group.leave()
            }
        }
        group.wait()
        XCTAssertEqual(queue.count, 100, "Some items were dropped not added")

        let actions = queue.dequeue(upTo: 100)

        var deqIds: Set<UUID> = Set()

        for gameAction in actions {
            guard case let .DestroyNode(action) = gameAction else {
                XCTFail("Did not get back action")
                return
            }
            deqIds.insert(action.nodeNetId)
        }
        XCTAssertEqual(deqIds, ids, "Items not equal")
    }
}
