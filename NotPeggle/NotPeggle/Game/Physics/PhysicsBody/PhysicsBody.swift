//
//  PhysicsBody.swift
//  NotPeggle
//
//  Created by Ying Gao on 24/2/21.
//

import UIKit

class PhysicsBody: NSObject {

    let shape: Shape
    var restitution: CGFloat
    var velocity: CGVector
    var acceleration: CGVector

    init(shape: Shape, restitution: CGFloat, velocity: CGVector, acceleration: CGVector) {
        self.shape = shape
        self.restitution = restitution
        self.velocity = velocity
        self.acceleration = acceleration
    }

    func updateProperties(time: TimeInterval) {}

    func collides(with other: PhysicsBody) -> Bool {
        false
    }

    func handleCollision(object: PhysicsBody) {
    }

    func handleCollisionWithBorders(frame: CGRect, borders: Set<Border>) {
    }

}

extension PhysicsBody {

    func displacementComponent(after time: Double) -> ((CGFloat, CGFloat) -> CGFloat) {
        { (velocityComp: CGFloat, accelerationComp: CGFloat) in
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
