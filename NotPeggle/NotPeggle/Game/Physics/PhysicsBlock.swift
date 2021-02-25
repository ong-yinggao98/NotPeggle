//
//  PhysicsBlock.swift
//  NotPeggle
//
//  Created by Ying Gao on 24/2/21.
//

import UIKit

/**
 Represents an immovable rectangle in 2D space.
 */
class PhysicsBlock: NSObject, PhysicsBody {

    let shape = Shape.block

    // MARK: Physical attributes
    private(set) var boundingBox: CGRect
    private(set) var restitution: CGFloat

    // MARK: Dynamic attributes
    private(set) var velocity: CGVector
    private(set) var acceleration: CGVector

    init(boundingBox: CGRect, restitution: CGFloat, velocity: CGVector, acceleration: CGVector) {
        self.boundingBox = boundingBox
        self.restitution = restitution
        self.velocity = velocity
        self.acceleration = acceleration
    }

    func updateProperties(time: TimeInterval) {
        let elapsed = time.magnitude
        moveOrigin(time: elapsed)
        setNewVelocity(time: elapsed)
    }

    private func moveOrigin(time: Double) {
        let displacementCalculator = displacementComponent(after: time)
        let distX = displacementCalculator(velocity.dx, acceleration.dy)
        let distY = displacementCalculator(velocity.dy, acceleration.dy)
        boundingBox.origin.x += distX
        boundingBox.origin.y += distY
    }

    private func setNewVelocity(time: Double) {
        velocity.dx += CGFloat(acceleration.dx.native * time)
        velocity.dy += CGFloat(acceleration.dy.native * time)
    }

    func collides(with other: PhysicsBody) -> Bool {
        return false
    }

    func handleCollision(object: PhysicsBody) {
        // Does not need to handle collisions
    }

    // MARK: Collision with borders

    func handleCollisionWithBorders(frame: CGRect, borders: Set<Border>) {
        let sideCollisionFound = collidesWithSides(frame: frame, borders: borders)
        let topBottomCollisionFound = collidesWithTopBottom(frame: frame, borders: borders)
        if sideCollisionFound {
            velocity.dx *= -1
        }
        if topBottomCollisionFound {
            velocity.dy *= -1
        }

        if sideCollisionFound || topBottomCollisionFound {
            velocity.scale(factor: restitution)
        }
    }

    private func collidesWithSides(frame: CGRect, borders: Set<Border>) -> Bool {
        let crossesLeft = boundingBox.origin.x <= 0
        let headingLeft = velocity.dx < 0
        let leftWallExists = borders.contains(.left)
        let collidesWithLeftWall = crossesLeft && headingLeft && leftWallExists

        let crossesRight = boundingBox.origin.x + boundingBox.width >= frame.width
        let headingRight = velocity.dx > 0
        let rightWallExists = borders.contains(.right)
        let collidesWithRightWall = crossesRight && headingRight && rightWallExists

        return collidesWithLeftWall || collidesWithRightWall
    }

    private func collidesWithTopBottom(frame: CGRect, borders: Set<Border>) -> Bool {
        let crossesTop = boundingBox.origin.y <= 0
        let headingTop = velocity.dy < 0
        let topWallExists = borders.contains(.top)
        let collidesWithTopWall = crossesTop && headingTop && topWallExists

        let crossesBottom = boundingBox.origin.y + boundingBox.height >= frame.width
        let headingBottom = velocity.dy > 0
        let bottomWallExists = borders.contains(.bottom)
        let collidesWithRightWall = crossesBottom && headingBottom && bottomWallExists

        return collidesWithTopWall || collidesWithRightWall
    }

}
