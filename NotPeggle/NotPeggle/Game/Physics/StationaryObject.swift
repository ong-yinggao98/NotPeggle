//
//  StationaryObject.swift
//  NotPeggle
//
//  Created by Ying Gao on 11/2/21.
//

import UIKit

/**
 General `PhysicsObject` that is stationary and fixed to its position.
 */
class StationaryObject: PhysicsBody {

    init?(center: CGPoint, radius: CGFloat) {
        super.init(pos: center, radius: radius, restitution: 0, velo: CGVector.zero, accel: CGVector.zero)
    }

    override func isEqual(_ other: Any?) -> Bool {
        guard let other = other as? StationaryObject else {
            return false
        }
        return super.isEqual(other)
    }

}
