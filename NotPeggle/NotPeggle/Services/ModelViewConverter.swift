//
//  PegView.swift
//  NotPeggle
//
//  Created by Ying Gao on 26/1/21.
//

import UIKit

/**
 Utility struct that provides static methods for
 converting `Peg` objects to `PegView`, `Point` objects to `CGPoint` and vice versa.
 Implements an adapter pattern.
 */
struct ModelViewConverter {

    /// Creates a `Peg` of a given `Color` centered on the given `location`.
    static func pegFromCGPoint(color: Color, at location: CGPoint) -> Peg {
        let center = pointFromCGPoint(point: location)
        return Peg(center: center, color: color)
    }

    /// Creates a `PegView` that represents the information of a given `Peg`.
    static func viewFromPeg(_ peg: Peg) -> PegView {
        let pegCenter = peg.center
        let viewCenter = CGPoint(x: pegCenter.xCoord, y: pegCenter.yCoord)
        return PegView(center: viewCenter, color: peg.color)
    }

    /// Creates a model representation `Peg` from its corresponding `PegView`.
    static func pegFromView(_ view: PegView) -> Peg {
        let center = pointFromCGPoint(point: view.center)
        return Peg(center: center, color: view.color)
    }

    /// Converts a `CGPoint` to `Point`.
    static func pointFromCGPoint(point: CGPoint) -> Point {
        return Point(xCoord: point.x.native, yCoord: point.y.native)
    }
}
