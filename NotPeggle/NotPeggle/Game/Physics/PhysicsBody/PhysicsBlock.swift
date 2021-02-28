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
class PhysicsBlock: PhysicsBody {

    // MARK: Physical attributes
    private(set) var boundingBox: OrientedBoundingBox

    // MARK: Bounding box attributes
    var points: [CGPoint] {
        boundingBox.points
    }

    var center: CGPoint {
        boundingBox.center
    }

    var angle: CGFloat {
        boundingBox.angle
    }

    var width: CGFloat {
        boundingBox.width
    }

    var height: CGFloat {
        boundingBox.height
    }

    // MARK: Methods

    init(boundingBox: OrientedBoundingBox, restitution: CGFloat, velocity: CGVector, acceleration: CGVector) {
        self.boundingBox = boundingBox
        super.init(shape: .block, restitution: restitution, velocity: velocity, acceleration: acceleration)
    }

    override func updateProperties(time: TimeInterval) {
        let elapsed = time.magnitude
        moveOrigin(time: elapsed)
        setNewVelocity(time: elapsed)
    }

    private func moveOrigin(time: Double) {
        let displacementCalculator = displacementComponent(after: time)
        let distX = displacementCalculator(velocity.dx, acceleration.dy)
        let distY = displacementCalculator(velocity.dy, acceleration.dy)
        boundingBox.center.x += distX
        boundingBox.center.y += distY
    }

    private func setNewVelocity(time: Double) {
        velocity.dx += CGFloat(acceleration.dx.native * time)
        velocity.dy += CGFloat(acceleration.dy.native * time)
    }

    // MARK: Collision with objects

    override func collides(with other: PhysicsBody) -> Bool {
        switch other.shape {
        case .ball:
            guard let ball = other as? PhysicsBall else {
                fatalError(".ball should be owned by PhysicsBalls only.")
            }
            return boundingBox.collides(ball: ball)
        case .block:
            guard let block = other as? PhysicsBlock else {
                fatalError(".block should be owned by PhysicsBlocks only.")
            }
            return boundingBox.collides(block: block.boundingBox)
        }
    }

    override func handleCollision(object: PhysicsBody) {
        // Does not need to handle collisions
    }

    // MARK: Collision with borders

    override func handleCollisionWithBorders(frame: CGRect, borders: Set<Border>) {
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
        for point in points {
            if point.x < 0 && velocity.dx < 0 && borders.contains(.left) {
                return true
            }
            if point.x > frame.width && velocity.dx > 0 && borders.contains(.right) {
                return true
            }
        }
        return false
    }

    private func collidesWithTopBottom(frame: CGRect, borders: Set<Border>) -> Bool {
        for point in points {
            if point.y < 0 && velocity.dy < 0 && borders.contains(.top) {
                return true
            }
            if point.y > frame.height && velocity.dy > 0 && borders.contains(.bottom) {
                return true
            }
        }
        return false
    }

    // MARK: Utility methods

    func convertToLocalCoordinates(ball: PhysicsBall) -> CGPoint {
        boundingBox.convertToLocalCoordinates(ball: ball)
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? PhysicsBlock else {
            return false
        }
        return boundingBox == other.boundingBox
            && restitution == other.restitution
            && velocity == other.velocity
            && acceleration == other.acceleration
    }

}
