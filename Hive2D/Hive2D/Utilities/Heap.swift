//
//  Heap.swift
//  Hive2D
//
//  Created by John Phua on 05/04/2020.
//  Copyright © 2020 TSCO. All rights reserved.
//

private struct HeapNode<T> {
    var item: T
    var priority: String
}

public struct Heap<T> {

    /** The array that stores the heap's nodes. */
    private var nodes = [HeapNode<T>]()

    public var isEmpty: Bool {
        nodes.isEmpty
    }

    public var count: Int {
        nodes.count
    }

    /**
    * Returns the index of the parent of the element at index i.
    * The element at index 0 is the root of the tree and has no parent.
    */
    private func parentIndex(ofIndex i: Int) -> Int {
        (i - 1) / 2
    }

    /**
    * Returns the index of the left child of the element at index i.
    * Note that this index can be greater than the heap size, in which case
    * there is no left child.
    */
    private func leftChildIndex(ofIndex i: Int) -> Int {
        2 * i + 1
    }

  /**
   * Returns the index of the right child of the element at index i.
   * Note that this index can be greater than the heap size, in which case
   * there is no right child.
   */
    private func rightChildIndex(ofIndex i: Int) -> Int {
        2 * i + 2
    }

    /**
    * Returns the maximum value in the heap (for a max-heap) or the minimum
    * value (for a min-heap).
    */
    public func peek() -> T? {
        nodes.first?.item
    }

    /**
    * Adds a new value to the heap. This reorders the heap so that the max-heap
    * or min-heap property still holds. Performance: O(log n).
    */
    public mutating func insert(_ item: T, priority: String) {
        nodes.append(HeapNode(item: item, priority: priority))
        shiftUp(nodes.count - 1)
    }

    /**
    * Removes the root node from the heap. For a max-heap, this is the maximum
    * value; for a min-heap it is the minimum value. Performance: O(log n).
    */
    public mutating func remove() -> T? {
        guard !nodes.isEmpty else {
            return nil
        }

        if nodes.count == 1 {
            return nodes.removeLast().item
        } else {
            // Use the last node to replace the first one, then fix the heap by
            // shifting this new first node into its proper position.
            let value = nodes[0]
            nodes[0] = nodes.removeLast()
            shiftDown(0)
            return value.item
        }
    }

    /// Removes up to n elements from the head of the queue and return them.
    /// - Returns: item at the head of the queue
    public mutating func remove(upTo num: Int) -> [T] {

        var items: [T] = []

        for _ in 0..<num {
            guard let nextItem = remove() else {
                break
            }
            items.append(nextItem)
        }
        return items
    }

    /**
    * Takes a child node and looks at its parents; if a parent is not larger
    * (max-heap) or not smaller (min-heap) than the child, we exchange them.
    */
    private mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = nodes[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)

        while childIndex > 0 && child.priority < nodes[parentIndex].priority {
          nodes[childIndex] = nodes[parentIndex]
          childIndex = parentIndex
          parentIndex = self.parentIndex(ofIndex: childIndex)
        }

        nodes[childIndex] = child
    }

    /**
     * Looks at a parent node and makes sure it is still larger (max-heap) or
     * smaller (min-heap) than its childeren.
     */
    private mutating func shiftDown(from index: Int, until endIndex: Int) {
        let leftChildIndex = self.leftChildIndex(ofIndex: index)
        let rightChildIndex = leftChildIndex + 1

        // Figure out which comes first if we order them by the sort function:
        // the parent, the left child, or the right child. If the parent comes
        // first, we're done. If not, that element is out-of-place and we make
        // it "float down" the tree until the heap property is restored.
        var first = index
        if leftChildIndex < endIndex && nodes[leftChildIndex].priority < nodes[first].priority {
            first = leftChildIndex
        }
        if rightChildIndex < endIndex && nodes[rightChildIndex].priority < nodes[first].priority {
            first = rightChildIndex
        }
        if first == index {
            return
        }

        nodes.swapAt(index, first)
        shiftDown(from: first, until: endIndex)
    }

    private mutating func shiftDown(_ index: Int) {
      shiftDown(from: index, until: nodes.count)
    }
}
