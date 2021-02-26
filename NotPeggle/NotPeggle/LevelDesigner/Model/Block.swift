//
//  Rect2D.swift
//  NotPeggle
//
//  Created by Ying Gao on 25/2/21.
//

import Foundation

struct Block: LevelObject {

    var type: Type {
        .block
    }

    var center: Point
    var width: Double
    var height: Double
    var angle: Double

    var points: [Point] {
        let topLeft = Point(
            x: center.x - ((width / 2) * cos(angle) - (height / 2) * sin(angle)),
            y: center.y - ((width / 2) * sin(angle) + (height / 2) * cos(angle))
        )
        let bottomLeft = Point(
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
                fatalError(".peg type should only be present on Pegs")
            }
            return overlapsWith(block: block)
        case .peg:
            guard let peg = other as? Peg else {
                fatalError(".peg type should only be present on Pegs")
            }
            return overlapsWith(peg: peg)
        }
    }

    private func overlapsWith(block: Block) -> Bool {
        for block in [self, block] {
            let points = block.points
            for i in 1..<points.count {
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
        return false
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

    private func overlapsWith(peg: Peg) -> Bool {
        false
    }

    func contains(point: Point) -> Bool {
        false
    }

    func tooCloseToEdges(width: Double, height: Double) -> Bool {
        false
    }

}

extension Block: Hashable, Codable {
}
