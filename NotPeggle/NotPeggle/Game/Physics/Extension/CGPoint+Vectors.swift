//
//  CGPoint+Vectors.swift
//  NotPeggle
//
//  Created by Ying Gao on 9/2/21.
//

import UIKit

/**
 Adds functionality for computing tangents and normals between two points.
 */
extension CGPoint {

    func unitNormalTo(point: CGPoint) -> CGVector {
        let distX = point.x - x
        let distY = point.y - y
        var vector = CGVector(dx: distX, dy: distY)
        let magnitude = vector.magnitude
        guard magnitude > 0 else {
            return CGVector.zero
        }

        vector.scale(factor: 1 / magnitude)
        return vector
    }

    func unitTangentTo(point: CGPoint) -> CGVector {
        let unitNormal = unitNormalTo(point: point)
        let newX = -unitNormal.dy
        let newY = unitNormal.dx
        return CGVector(dx: newX, dy: newY)
    }

    func distanceTo(point: CGPoint) -> CGFloat {
        let distX = point.x - x
        let distY = point.y - y
        return sqrt(distX * distX + distY * distY)
    }

}
