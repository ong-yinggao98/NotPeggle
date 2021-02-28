//
//  OrientedBoundingBox.swift
//  NotPeggle
//
//  Created by Ying Gao on 27/2/21.
//

import Foundation
import UIKit

struct OrientedBoundingBox {

    var center: CGPoint
    var width: CGFloat
    var height: CGFloat
    var angle: CGFloat

    /// Read-only property containing all points on a rotated block in anticlockwise order.
    /// Adapted from https://stackoverflow.com/a/61664630
    var points: [CGPoint] {
        let bottomLeft = CGPoint(
            x: center.x - ((width / 2) * cos(angle) - (height / 2) * sin(angle)),
            y: center.y - ((width / 2) * sin(angle) + (height / 2) * cos(angle))
        )
        let topLeft = CGPoint(
            x: center.x - ((width / 2) * cos(angle) + (height / 2) * sin(angle)),
            y: center.y - ((width / 2) * sin(angle) - (height / 2) * cos(angle))
        )
        let bottomRight = CGPoint(
            x: center.x + ((width / 2) * cos(angle) + (height / 2) * sin(angle)),
            y: center.y + ((width / 2) * sin(angle) - (height / 2) * cos(angle))
        )
        let topRight = CGPoint(
            x: center.x + ((width / 2) * cos(angle) - (height / 2) * sin(angle)),
            y: center.y + ((width / 2) * sin(angle) + (height / 2) * cos(angle))
        )

        return [topLeft, bottomLeft, bottomRight, topRight]
    }

    /// Checks if a peg overlaps with the block.
    /// Algorithm adapted from https://gist.github.com/snorpey/8134c248296649433de2
    func collides(ball: PhysicsBall) -> Bool {
        let localCircleCenter = convertToLocalCoordinates(ball: ball)
        let nearestPoint = closestPoint(to: localCircleCenter)

        let dx = localCircleCenter.x - nearestPoint.x
        let dy = localCircleCenter.y - nearestPoint.y
        let distSquared = dx * dx + dy * dy
        let minSafeDist = ball.radius * ball.radius

        return distSquared < minSafeDist
    }

    func convertToLocalCoordinates(ball: PhysicsBall) -> CGPoint {
        let circleCenter = ball.center
        let newX = center.x + (circleCenter.x - center.x) * cos(-angle) - (circleCenter.y - center.y) * sin(-angle)
        let newY = center.y + (circleCenter.x - center.x) * sin(-angle) + (circleCenter.y - center.y) * cos(-angle)
        return CGPoint(x: newX, y: newY)
    }

    /// Returns the closest point along the block to the given `localPeg`.
    /// All coordinates are local to the block (i.e. treated as a AABB).
    private func closestPoint(to circleCenter: CGPoint) -> CGPoint {
        let origin = CGPoint(x: center.x - (width / 2), y: center.y - (height / 2))

        let closestX = max(origin.x, min(circleCenter.x, origin.x + width))
        let closestY = max(origin.y, min(circleCenter.y, origin.y + height))

        return CGPoint(x: closestX, y: closestY)
    }

    /// Applies the separating axis theorem (SAT) to find if two blocks intersect.
    /// Algorithm taken from https://stackoverflow.com/a/10965077
    func collides(block: OrientedBoundingBox) -> Bool {
        for test in [self, block] {
            let points = test.points
            for i in 0..<points.count {
                let j = (i + 1) % points.count
                let p1 = points[i]
                let p2 = points[j]

                let normal = CGVector(dx: p2.y - p1.y, dy: p1.x - p2.x)

                let range = rangeAlongProjection(normal: normal)
                let otherRange = block.rangeAlongProjection(normal: normal)

                if range.max < otherRange.min || otherRange.max < range.min {
                    return false
                }
            }
        }
        return true
    }

    private func rangeAlongProjection(normal: CGVector) -> (min: CGFloat, max: CGFloat) {
        var min: CGFloat?
        var max: CGFloat?
        for point in points {
            let projected = normal.dx * point.x + normal.dy * point.y
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

}

extension OrientedBoundingBox: Equatable {
}
