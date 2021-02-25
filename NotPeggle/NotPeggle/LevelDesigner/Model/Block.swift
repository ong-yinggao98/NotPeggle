//
//  Rect2D.swift
//  NotPeggle
//
//  Created by Ying Gao on 25/2/21.
//

import Foundation

struct Block: LevelObject {

    var type: Type {
        return .block
    }

    var center: Point
    var width: Double
    var height: Double
    var angle: Double

    var points: [Point] {
        let topLeft = Point(
            xCoord: center.xCoord - ((width / 2) * cos(angle) - (height / 2) * sin(angle)),
            yCoord: center.yCoord - ((width / 2) * sin(angle) + (height / 2) * cos(angle))
        )
        let bottomLeft = Point(
            xCoord: center.xCoord - ((width / 2) * cos(angle) + (height / 2) * sin(angle)),
            yCoord: center.yCoord - ((width / 2) * sin(angle) - (height / 2) * cos(angle))
        )
        let bottomRight = Point(
            xCoord: center.xCoord + ((width / 2) * cos(angle) + (height / 2) * sin(angle)),
            yCoord: center.yCoord + ((width / 2) * sin(angle) - (height / 2) * cos(angle))
        )
        let topRight = Point(
            xCoord: center.xCoord + ((width / 2) * cos(angle) - (height / 2) * sin(angle)),
            yCoord: center.yCoord + ((width / 2) * sin(angle) + (height / 2) * cos(angle))
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

                let normal = SIMD2(p2.yCoord - p1.yCoord, p1.xCoord - p2.xCoord)

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
            let projected = normal.x * point.xCoord + normal.y * point.yCoord
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
        return false
    }

    func contains(point: Point) -> Bool {
        return false
    }

    func tooCloseToEdges(width: Double, height: Double) -> Bool {
        return false
    }

}

extension Block: Hashable, Codable {
}
