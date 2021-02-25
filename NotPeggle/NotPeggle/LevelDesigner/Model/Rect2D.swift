//
//  Rect2D.swift
//  NotPeggle
//
//  Created by Ying Gao on 25/2/21.
//

import Foundation

struct Rect2D {

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
}
