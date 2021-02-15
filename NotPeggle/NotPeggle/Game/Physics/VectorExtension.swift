//
//  VectorExtensions.swift
//  NotPeggle
//
//  Created by Ying Gao on 10/2/21.
//

import UIKit

/**
 Additional functionality for vector mathematics.
 */
extension CGVector {

    /// Angle of the given vector.
    /// Note that the angle is calculated by arctan() and has limited range [pi/2, -pi/2].
    /// In other words, two parallel vectors in opposite directions will share the same angle.
    var angleInRads: CGFloat {
        get {
            guard magnitude != 0 else {
                return 0
            }
            return atan(dy/dx)
        }
        set {
            let magnitude = self.magnitude // it seems that not having this line really kills the precision
            dx = magnitude * cos(newValue)
            dy = magnitude * sin(newValue)
        }
    }

    var magnitude: CGFloat {
        return sqrt(dx * dx + dy * dy)
    }

    /// Rotates the vector **anticlockwise** by the given `angle`.
    mutating func rotate(by angle: CGFloat) {
        var angleToRotateBy = angle
        if dx < 0 {
            angleToRotateBy += CGFloat.pi
        }
        angleInRads += angleToRotateBy
    }

    /// Returns the dot product between the two vectors
    func dot(other: CGVector) -> CGFloat {
        return dx * other.dx + dy * other.dy
    }

    func isPerpendicularTo(other: CGVector) -> Bool {
        return dot(other: other) == 0
    }

    /// Multiplies the magnitude of the vector by the given `factor`.
    mutating func scale(factor: CGFloat) {
        dx *= factor
        dy *= factor
    }

}
