//
//  GravBouncingBall.swift
//  NotPeggle
//
//  Created by Ying Gao on 11/2/21.
//

import UIKit

/**
 General `PhysicsObject` that is affected by a constant downward acceleration representing gravity.
 Upon collisions it will lose a small fraction of energy to prevent it from bouncing indefinitely.
 */
class GravBouncingBall: PhysicsBody {

    static let restitution: CGFloat = 0.9
    static let gravity = CGVector(dx: 0, dy: 300)

    init?(center: CGPoint, radius: CGFloat, velocity: CGVector) {
        super.init(
            pos: center,
            radius: radius,
            restitution: GravBouncingBall.restitution,
            velo: velocity,
            accel: GravBouncingBall.gravity
        )
    }

    override func isEqual(_ other: Any?) -> Bool {
        guard let other = other as? GravBouncingBall else {
            return false
        }
        return super.isEqual(other)
    }

}
