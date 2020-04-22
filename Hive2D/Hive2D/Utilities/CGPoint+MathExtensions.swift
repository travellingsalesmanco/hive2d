//
//  CGPoint+MathExtensions.swift
//  Hive2D
//
//  Created by Foo Guo Wei on 17/4/20.
//  Copyright © 2020 TSCO. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {
    init(_ vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }

    init(angle: CGFloat) {
        self.init(x: cos(angle), y: sin(angle))
    }

    mutating func translate(dx: CGFloat, dy: CGFloat) -> CGPoint {
        x += dx
        y += dy
        return self
    }
    func translated(dx: CGFloat, dy: CGFloat) -> CGPoint {
        CGPoint(x: x + dx, y: y + dy)
    }

    /// Rotation by theta radians
    mutating func rotate(by theta: CGFloat) -> CGPoint {
        let cosTheta = cos(theta)
        let sinTheta = sin(theta)
        x = x * cosTheta - y * sinTheta
        y = x * sinTheta + y * cosTheta
        return self
    }
    func rotated(by theta: CGFloat) -> CGPoint {
        let cosTheta = cos(theta)
        let sinTheta = sin(theta)
        return CGPoint(x: x * cosTheta - y * sinTheta, y: x * sinTheta + y * cosTheta)
    }

    /// Use this for magnitude comparisons to save on a sqrt operation
    var magnitudeSquared: CGFloat {
        (x * x) + (y * y)
    }
    var magnitude: CGFloat {
        sqrt(magnitudeSquared)
    }
    /// Angle represented by the point w.r.t. origin in radians.
    /// Range: [-pi, pi]
    /// Angle of 0 points in direction of positive x-axis
    var angle: CGFloat {
        atan2(y, x)
    }

    /// Calculates distance between two CGPoints.
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return (self - point).magnitude
    }

    // MARK: Operators

    /// CGPoint and CGPoint vector addition
    static func += (left: inout CGPoint, right: CGPoint) {
        left = CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        var copy = left
        copy += right
        return copy
    }

    /// CGPoint and CGPoint vector subtraction
    static func -= (left: inout CGPoint, right: CGPoint) {
        left = CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        var copy = left
        copy -= right
        return copy
    }

    /// Scalar multiplication on CGPoint
    static func *= (left: inout CGPoint, right: CGFloat) {
        left = CGPoint(x: left.x * right, y: left.y * right)
    }
    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        var copy = left
        copy *= right
        return copy
    }
    static func * (left: CGFloat, right: CGPoint) -> CGPoint {
        right * left
    }
    /// Scalar division on CGPoint
    static func /= (left: inout CGPoint, right: CGFloat) {
        left = CGPoint(x: left.x / right, y: left.y / right)
    }
    static func / (left: CGPoint, right: CGFloat) -> CGPoint {
        var copy = left
        copy /= right
        return copy
    }

    /// Prefix negation of CGPoint
    static prefix func - (left: CGPoint) -> CGPoint {
        left * -1
    }

    /// CGPoint and CGVector vector addition
    static func += (left: inout CGPoint, right: CGVector) {
        left = CGPoint(x: left.x + right.dx, y: left.y + right.dy)
    }
    static func + (left: CGPoint, right: CGVector) -> CGPoint {
        var copy = left
        copy += right
        return copy
    }

    /// CGPoint and CGVector vector subtraction
    static func -= (left: inout CGPoint, right: CGVector) {
        left = CGPoint(x: left.x - right.dx, y: left.y - right.dy)
    }
    static func - (left: CGPoint, right: CGVector) -> CGPoint {
        var copy = left
        copy -= right
        return copy
    }
}
