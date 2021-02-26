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
        let viewCenter = CGPoint(x: pegCenter.x, y: pegCenter.y)
        let radius = CGFloat(peg.radius)
        return PegView(center: viewCenter, color: peg.color, radius: radius)
    }

    /// Creates a model representation `Peg` from its corresponding `PegView`.
    static func pegFromView(_ view: PegView) -> Peg {
        let center = pointFromCGPoint(point: view.center)
        let radius = view.radius.native
        return Peg(center: center, color: view.color, radius: radius)
    }

    /// Converts a `CGPoint` to `Point`.
    static func pointFromCGPoint(point: CGPoint) -> Point {
        Point(x: point.x.native, y: point.y.native)
    }
}
