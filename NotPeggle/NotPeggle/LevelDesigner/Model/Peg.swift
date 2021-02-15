//
//  Peg.swift
//  NotPeggle
//
//  Created by Ying Gao on 25/1/21.
//

/**
 Model representation of a round peg. A `Peg` is defined by its center and color.
 The color is purely cosmetic, and the radius is defined as 32.0 pixels.
 `Peg` supports operations for:
    - Checking for overlaps with a given peg
    - Checking if a given point is contained
    - Moving a peg to another center
 The struct is guaranteed to be immutable.
 */
struct Peg: Hashable, Codable {
    let center: Point
    let color: Color

    /// Constructs a `Peg` with a given center and color.
    init(center: Point, color: Color) {
        self.center = center
        self.color = color
    }

    /// Constructs a `Peg` from raw coordinates.
    init(centerX: Double, centerY: Double, color: Color) {
        let center = Point(xCoord: centerX, yCoord: centerY)
        self.init(center: center, color: color)
    }

    /// Checks if the  `Peg` has intersection area with a given `Peg`.
    func overlapsWith(peg: Peg) -> Bool {
        let diameter = 2 * Constants.pegRadius
        let dist = distanceFrom(peg.center)

        return dist < diameter
    }

    /// Checks if the `Peg`contains a point within its area.
    func contains(point: Point) -> Bool {
        let dist = distanceFrom(point)
        return dist < Constants.pegRadius
    }

    /// Measures the distance from the center of a `Peg` to a given `Point`.
    private func distanceFrom(_ point: Point) -> Double {
        let xDist = point.xCoord - center.xCoord
        let yDist = point.yCoord - center.yCoord
        let distSquared = (xDist * xDist) + (yDist * yDist)
        return distSquared.squareRoot()
    }

    /// Checks if a peg's coordinates are too close to a given rectangular boundary of
    /// a given `width` and `height`.
    /// A `Peg` is considered too close if the borders are less than one radius from the center.
    func isTooCloseToEdges(width: Double, height: Double) -> Bool {
        let radius = Constants.pegRadius
        let tooCloseToLeft = (center.xCoord - 0) < radius
        let tooCloseToTop = (center.yCoord - 0) < radius
        let tooCloseToRight = (width - center.xCoord) < radius
        let tooCloseToBottom = (height - center.yCoord) < radius

        return tooCloseToTop || tooCloseToLeft || tooCloseToRight || tooCloseToBottom
    }

    /// Returns a new `Peg` with the same colour but centered around the given `Point`.
    func recenterTo(_ center: Point) -> Peg {
        return Peg(center: center, color: color)
    }
}

/**
 Representation of a pair of coordinates in 2D space.
 */
struct Point: Hashable, Codable {
    var xCoord: Double
    var yCoord: Double
}
