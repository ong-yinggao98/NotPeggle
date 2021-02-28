//
//  Rect2D.swift
//  NotPeggle
//
//  Created by Ying Gao on 25/2/21.
//

import Foundation

/**
 Representation of a rectangular solid block.
 A `Block` is definted by its center coordinates, size and angle of rotation.
 Each block has a fixed 2:1 width : height ratio.
 */
struct Block: LevelObject {

    var type: Type {
        .block
    }

    let center: Point
    let height: Double
    let width: Double
    let angle: Double

    init(center: Point) {
        self.center = center
        self.height = Constants.blockHeight
        self.width = 2 * height
        self.angle = 0
    }

    init(center: Point, height: Double) {
        self.center = center
        self.height = height
        self.width = 2 * height
        self.angle = 0
    }

    init(center: Point, height: Double, angle: Double) {
        self.center = center
        self.height = height
        self.width = 2 * height
        self.angle = angle
    }

    init(center: Point, height: Double, width: Double, angle: Double) {
        self.center = center
        self.height = height
        self.width = width
        self.angle = angle
    }

    /// Read-only property containing all points on a rotated block in anticlockwise order.
    /// Adapted from https://stackoverflow.com/a/61664630
    var points: [Point] {
        let bottomLeft = Point(
            x: center.x - ((width / 2) * cos(angle) - (height / 2) * sin(angle)),
            y: center.y - ((width / 2) * sin(angle) + (height / 2) * cos(angle))
        )
        let topLeft = Point(
            x: center.x - ((width / 2) * cos(angle) + (height / 2) * sin(angle)),
            y: center.y - ((width / 2) * sin(angle) - (height / 2) * cos(angle))
        )
        let bottomRight = Point(
            x: center.x + ((width / 2) * cos(angle) + (height / 2) * sin(angle)),
            y: center.y + ((width / 2) * sin(angle) - (height / 2) * cos(angle))
        )
        let topRight = Point(
            x: center.x + ((width / 2) * cos(angle) - (height / 2) * sin(angle)),
            y: center.y + ((width / 2) * sin(angle) + (height / 2) * cos(angle))
        )

        return [topLeft, bottomLeft, bottomRight, topRight]
    }

    func overlapsWith(other: LevelObject) -> Bool {
        switch other.type {
        case .block:
            guard let block = other as? Block else {
                fatalError(".block type should only be present on Block")
            }
            return overlapsWith(block: block)
        case .peg:
            guard let peg = other as? Peg else {
                fatalError(".peg type should only be present on Pegs")
            }
            return overlapsWith(peg: peg)
        }
    }

    /// Applies the separating axis theorem (SAT) to find if two blocks intersect.
    /// Algorithm taken from https://stackoverflow.com/a/10965077
    private func overlapsWith(block: Block) -> Bool {
        for test in [self, block] {
            let points = test.points
            for i in 0..<points.count {
                let j = (i + 1) % points.count
                let p1 = points[i]
                let p2 = points[j]

                let normal = SIMD2(p2.y - p1.y, p1.x - p2.x)

                let range = rangeAlongProjection(normal: normal)
                let otherRange = block.rangeAlongProjection(normal: normal)

                if range.max < otherRange.min || otherRange.max < range.min {
                    return false
                }
            }
        }
        return true
    }

    private func rangeAlongProjection(normal: SIMD2<Double>) -> (min: Double, max: Double) {
        var min: Double?
        var max: Double?
        for point in points {
            let projected = normal.x * point.x + normal.y * point.y
            if min == nil {
                min = projected
            }
            if let minUnwrapped = min, projected < minUnwrapped {
                min = projected
            }
            if max == nil {
                max = projected
            }
            if let maxUnwrapped = max, projected > maxUnwrapped {
                max = projected
            }
        }
        guard let minUnwrapped = min, let maxUnwrapped = max else {
            fatalError("Min and max should have been initialised by now")
        }
        return (minUnwrapped, maxUnwrapped)
    }

    /// Checks if a peg overlaps with the block.
    /// Algorithm adapted from https://gist.github.com/snorpey/8134c248296649433de2
    private func overlapsWith(peg: Peg) -> Bool {
        let recenteredPeg = convertToLocalCoordinates(peg: peg)
        let nearestPoint = closestPoint(to: recenteredPeg)

        let localPegCenter = recenteredPeg.center
        let dx = localPegCenter.x - nearestPoint.x
        let dy = localPegCenter.y - nearestPoint.y
        let distSquared = dx * dx + dy * dy
        let minSafeDist = recenteredPeg.radius * recenteredPeg.radius

        return distSquared < minSafeDist
    }

    private func convertToLocalCoordinates(peg: Peg) -> Peg {
        let circleCenter = peg.center
        let newX = center.x + (circleCenter.x - center.x) * cos(-angle) - (circleCenter.y - center.y) * sin(-angle)
        let newY = center.y + (circleCenter.x - center.x) * sin(-angle) + (circleCenter.y - center.y) * cos(-angle)
        return peg.recenterTo(Point(x: newX, y: newY))
    }

    /// Returns the closest point along the block to the given `localPeg`.
    /// All coordinates are local to the block (i.e. treated as a AABB).
    private func closestPoint(to localPeg: Peg) -> Point {
        let origin = Point(x: center.x - (width / 2), y: center.y - (height / 2))

        let closestX = max(origin.x, min(localPeg.center.x, origin.x + width))
        let closestY = max(origin.y, min(localPeg.center.y, origin.y + height))

        return Point(x: closestX, y: closestY)
    }

    /// Checks if a rectangle contains a given `Point`.
    /// Solution adapted from http://disq.us/p/2dpht33
    func contains(point: Point) -> Bool {
        let area = width * height
        let a = points[0], b = points[1], c = points[2], d = points[3]

        let pointABArea = 0.5 * abs(a.x * (b.y - point.y) + b.x * (point.y - a.y) + point.x * (a.y - b.y))
        let pointBCArea = 0.5 * abs(b.x * (c.y - point.y) + c.x * (point.y - b.y) + point.x * (b.y - c.y))
        let pointCDArea = 0.5 * abs(c.x * (d.y - point.y) + d.x * (point.y - c.y) + point.x * (c.y - d.y))
        let pointADArea = 0.5 * abs(d.x * (a.y - point.y) + a.x * (point.y - d.y) + point.x * (d.y - a.y))
        let sumOfTriangleAreas = pointABArea + pointBCArea + pointCDArea + pointADArea
        return area >= sumOfTriangleAreas
    }

    func tooCloseToEdges(width: Double, height: Double) -> Bool {
        !points.allSatisfy { $0.x >= 0 && $0.x <= width && $0.y >= 0 && $0.y <= height }
    }

    func recenterTo(_ center: Point) -> Block {
        Block(center: center, height: height, width: width, angle: angle)
    }

    func resizeTo(width: Double) -> Block {
        let minWidth = Constants.blockHeight
        let maxWidth = 4 * minWidth
        let newWidth = min(maxWidth, max(minWidth, width))
        return Block(center: center, height: height, width: newWidth, angle: angle)
    }

    func resizeTo(height: Double) -> Block {
        let minHeight = Constants.blockHeight
        let maxHeight = 2 * minHeight
        let newHeight = min(maxHeight, max(minHeight, height))
        return Block(center: center, height: newHeight, width: width, angle: angle)
    }

    func rotateTo(_ angle: Double) -> Block {
        let minAngle = 0.0
        let maxAngle = 2 * Double.pi
        let newAngle = min(maxAngle, max(minAngle, angle))
        return Block(center: center, height: height, width: width, angle: newAngle)
    }

}

extension Block: Hashable, Codable {
}
