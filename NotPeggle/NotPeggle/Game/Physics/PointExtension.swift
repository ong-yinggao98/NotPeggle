//
//  CGPointExtensions.swift
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
        let magnitude = sqrt(distX * distX + distY * distY)
        guard magnitude > 0 else {
            return CGVector.zero
        }

        let unitX = distX / magnitude
        let unitY = distY / magnitude
        return CGVector(dx: unitX, dy: unitY)
    }

    func unitTangentTo(point: CGPoint) -> CGVector {
        let unitNormal = unitNormalTo(point: point)
        let newX = -unitNormal.dy
        let newY = unitNormal.dx
        return CGVector(dx: newX, dy: newY)
    }
}
