//
//  Queue.swift
//  Hive2D
//
//  Created by John Phua on 17/03/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

/**
 A generic `Queue` class whose elements are first-in, first-out.
 - Authors: CS3217
 */
class Queue<T> {

    private class LinkedListNode<T> {
        var val: T
        var next: LinkedListNode<T>?

        init(value: T) {
            self.val = value
        }
    }

    private var firstItem: LinkedListNode<T>?
    private var lastItem: LinkedListNode<T>?
    private var numItems = 0

    /// Adds an element to the tail of the queue.
    /// - Parameter item: The element to be added to the queue
    func enqueue(_ item: T) {
        let newNode = LinkedListNode<T>(value: item)
        if isEmpty {
            firstItem = newNode
            lastItem = newNode
        } else {
            lastItem?.next = newNode
            lastItem = newNode
        }
        numItems += 1
    }

    /// Removes an element from the head of the queue and return it.
    /// - Returns: item at the head of the queue
    func dequeue() -> T? {
        if isEmpty {
            return nil
        }

        let targetNode = firstItem
        firstItem = firstItem?.next
        numItems -= 1
        if numItems == 0 {
            lastItem = nil
        }
        return targetNode?.val
    }

    /// Returns, but does not remove, the element at the head of the queue.
    /// - Returns: item at the head of the queue
    func peek() -> T? {
        if isEmpty {
            return nil
        }

        return firstItem?.val
    }

    /// The number of elements currently in the queue.
    var count: Int {
        numItems
    }

    /// Whether the queue is empty.
    var isEmpty: Bool {
        numItems == 0
    }

    /// Removes all elements in the queue.
    func removeAll() {
        firstItem = nil
        lastItem = nil
        numItems = 0
    }

    /// Returns an array of the elements in their respective dequeue order, i.e.
    /// first element in the array is the first element to be dequeued.
    /// - Returns: array of elements in their respective dequeue order
    func toArray() -> [T] {
        var items: [T] = []

        var currItemPtr = firstItem
        while let currItem = currItemPtr {
            items.append(currItem.val)
            currItemPtr = currItem.next
        }

        return items
    }
}
