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

    var origin: Point
    var width: Double
    var height: Double
    var angle: Double

    var mid: Point {
        let midXFlat = origin.xCoord + width / 2
        let midYFlat = origin.yCoord + height / 2

        let midX = midXFlat * cos(angle) - midYFlat * sin(angle)
        let midY = midXFlat * sin(angle) + midYFlat * cos(angle)
        return Point(xCoord: midX, yCoord: midY)
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
        return false
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
