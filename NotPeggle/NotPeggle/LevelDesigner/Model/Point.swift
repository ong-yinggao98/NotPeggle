//
//  Point.swift
//  NotPeggle
//
//  Created by Ying Gao on 26/2/21.
//

/**
 Representation of a pair of coordinates in 2D space.
 */
struct Point {
    var x: Double
    var y: Double
}

extension Point: Hashable, Codable {
}
