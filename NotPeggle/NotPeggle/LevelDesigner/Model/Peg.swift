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
struct Peg: LevelObject {

    var type: Type {
        .peg
    }

    let center: Point
    let color: Color
    let radius: Double

    /// Constructs a `Peg` with a given center and color.
    init(center: Point, color: Color) {
        self.center = center
        self.color = color
        self.radius = Constants.pegRadius
    }

    /// Constructs a `Peg` with a given center and color.
    init(center: Point, color: Color, radius: Double) {
        self.center = center
        self.color = color
        self.radius = radius
    }

    /// Constructs a `Peg` from raw coordinates.
    init(centerX: Double, centerY: Double, color: Color) {
        let center = Point(x: centerX, y: centerY)
        self.init(center: center, color: color)
    }

    /// Constructs a `Peg` from raw coordinates.
    init(centerX: Double, centerY: Double, color: Color, radius: Double) {
        let center = Point(x: centerX, y: centerY)
        self.center = center
        self.color = color
        self.radius = radius
    }

    func overlapsWith(other: LevelObject) -> Bool {
        switch other.type {
        case .peg:
            guard let peg = other as? Peg else {
                fatalError("Should only be used by Peg types")
            }
            return overlapsWith(peg: peg)
        case .block:
            guard let block = other as? Block else {
                fatalError("Should only be used by Block types")
            }
            return overlapsWith(block: block)
        }
    }

    /// Checks if the  `Peg` has intersection area with a given `Peg`.
    func overlapsWith(peg: Peg) -> Bool {
        let safeDist = radius + peg.radius
        let dist = distanceFrom(peg.center)

        return dist < safeDist
    }

    /// Checks if the  `Peg` has intersection area with a given `Peg`.
    func overlapsWith(block: Block) -> Bool {
        false
    }

    /// Checks if the `Peg`contains a point within its area.
    func contains(point: Point) -> Bool {
        let dist = distanceFrom(point)
        return dist < radius
    }

    /// Measures the distance from the center of a `Peg` to a given `Point`.
    private func distanceFrom(_ point: Point) -> Double {
        let xDist = point.x - center.x
        let yDist = point.y - center.y
        let distSquared = (xDist * xDist) + (yDist * yDist)
        return distSquared.squareRoot()
    }

    /// Checks if a peg's coordinates are too close to a given rectangular boundary of
    /// a given `width` and `height`.
    /// A `Peg` is considered too close if the borders are less than one radius from the center.
    func tooCloseToEdges(width: Double, height: Double) -> Bool {
        let tooCloseToLeft = (center.x - 0) < radius
        let tooCloseToTop = (center.y - 0) < radius
        let tooCloseToRight = (width - center.x) < radius
        let tooCloseToBottom = (height - center.y) < radius

        return tooCloseToTop || tooCloseToLeft || tooCloseToRight || tooCloseToBottom
    }

    /// Returns a new `Peg` with the same colour but centered around the given `Point`.
    func recenterTo(_ center: Point) -> Peg {
        Peg(center: center, color: color)
    }
}

extension Peg: Hashable, Codable {
}

/**
 Representation of a pair of coordinates in 2D space.
 */
struct Point: Hashable, Codable {
    var x: Double
    var y: Double
}
