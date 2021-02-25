//
//  PhysicsBody.swift
//  NotPeggle
//
//  Created by Ying Gao on 24/2/21.
//

import UIKit

protocol PhysicsBody {

    var shape: Shape { get }
    var restitution: CGFloat { get }
    var velocity: CGVector { get }
    var acceleration: CGVector { get }

    func updateProperties(time: TimeInterval)

    func collides(with other: PhysicsBody) -> Bool

    func handleCollision(object: PhysicsBody)

    func handleCollisionWithBorders(frame: CGRect, borders: Set<Border>)

}

extension PhysicsBody {

    func displacementComponent(after time: Double) -> ((CGFloat, CGFloat) -> CGFloat) {
        return { (velocityComp: CGFloat, accelerationComp: CGFloat) in
            let distCompFromVelocity = velocityComp.native * time
            let distCompFromAccel = (1 / 2) * accelerationComp.native * time * time
            let displacement = distCompFromVelocity + distCompFromAccel
            return CGFloat(displacement)
        }
    }

}

enum Shape: Int {
    case ball, block
}
