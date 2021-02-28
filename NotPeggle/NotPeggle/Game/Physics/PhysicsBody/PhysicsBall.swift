//
//  PhysBody.swift
//  NotPeggle
//
//  Created by Ying Gao on 8/2/21.
//

import Foundation
import UIKit

/**
 Representation of an object capable of interacting physically with other objects.
 As of now it can only represent circular 2D objects, defined with a `center` and `radius`.
 Each object also has a `restitution` value that defines the amount of velocity retained  after a collision,
 as well as its `velocity` and `acceleration`.
 */
class PhysicsBall: PhysicsBody {

    // MARK: Physical attributes
    private(set) var center: CGPoint
    private(set) var radius: CGFloat

    init?(pos: CGPoint, radius: CGFloat, restitution: CGFloat, velo: CGVector, accel: CGVector) {
        center = pos
        guard radius > 0 else {
            return nil
        }

        self.radius = radius
        super.init(shape: .ball, restitution: restitution, velocity: velo, acceleration: accel)
    }

    /// Checks if the given PhysBody collides with another (i.e. areas intersect).
    override func collides(with other: PhysicsBody) -> Bool {
        switch other.shape {
        case .ball:
            guard let ball = other as? PhysicsBall else {
                fatalError("Ball shape should only be used by PhysicsBalls")
            }
            return collides(ball: ball)
        case .block:
            guard let block = other as? PhysicsBlock else {
                fatalError("Block shape should only be used by PhysicsBlocks")
            }
            return block.collides(with: self)
        }
    }

    private func collides(ball: PhysicsBall) -> Bool {
        guard ball !== self else {
            return false
        }
        let otherCenter = ball.center
        let distX = center.x - otherCenter.x
        let distY = center.y - otherCenter.y
        let distSquared = (distX * distX) + (distY * distY)

        let minSafeDist = radius + ball.radius
        let minSafeDistSquared = minSafeDist * minSafeDist
        return distSquared <= minSafeDistSquared
    }

    private func collides(block: PhysicsBlock) -> Bool {
        false
    }

    /// Computes the new location of the object after the elapsed `time` and moves it to that location.
    override func updateProperties(time: TimeInterval) {
        let elapsed = time.magnitude
        setNewCenter(time: elapsed)
        setNewVelocity(time: time)
    }

    private func setNewCenter(time: Double) {
        let distCalculator = displacementComponent(after: time)
        let distX = distCalculator(velocity.dx, acceleration.dx)
        let distY = distCalculator(velocity.dy, acceleration.dy)
        center.x += distX
        center.y += distY
    }

    private func setNewVelocity(time: Double) {
        velocity.dx += CGFloat(acceleration.dx.native * time)
        velocity.dy += CGFloat(acceleration.dy.native * time)
    }

    /// Recomputes the velocity after a collision with the given `object`.
    /// If the two objects do not collide, this does not change anything.
    /// If the object has already collided and has not fully left the intersecting area,
    /// this method also does not change anything.
    override func handleCollision(object: PhysicsBody) {
        guard collides(with: object) else {
            return
        }

        switch object.shape {
        case .ball:
            guard let ball = object as? PhysicsBall else {
                fatalError("Only PhysicsBall and subclasses should have the ball shape")
            }
            handleCollision(ball: ball)
        case .block:
            guard let block = object as? PhysicsBlock else {
                fatalError("Only PhysicsBlock and subclasses should have the block shape")
            }
            handleCollision(block: block)
        }
    }

    private func handleCollision(ball: PhysicsBall) {
        let normal = center.unitNormalTo(point: ball.center)
        reflectOff(normal: normal)
        moveTillNotColliding(with: ball)
    }

    private func moveTillNotColliding(with object: PhysicsBall) {
        var normal = center.unitNormalTo(point: object.center)
        let idealDist = radius + object.radius
        let distNeeded = idealDist - center.distanceTo(point: object.center)

        // Due to floating point precision
        normal.scale(factor: distNeeded * 0.95)
        recenterBy(xDist: normal.dx, yDist: normal.dy)
    }

    /// Recomputes velocity after colliding with the given `PhysicsBlock`.
    /// Algorithm adapted from https://stackoverflow.com/a/45373126
    private func handleCollision(block: PhysicsBlock) {
        let localCenter = block.convertToLocalCoordinates(ball: self)
        let blockOrigin = CGPoint(x: block.center.x - block.width / 2, y: block.center.y - block.height / 2)

        let nearestX = max(blockOrigin.x, min(localCenter.x, blockOrigin.x + block.width))
        let nearestY = max(blockOrigin.y, min(localCenter.y, blockOrigin.y + block.height))
        let nearestPoint = CGPoint(x: nearestX, y: nearestY)

        var normal = localCenter.unitNormalTo(point: nearestPoint)
        normal.rotate(by: block.angle)

        reflectOff(normal: normal)

        let dx = localCenter.x - nearestX
        let dy = localCenter.y - nearestY
        let minSafeDist = radius - sqrt(dx * dx + dy * dy)

        // Due to floating point precision
        normal.scale(factor: minSafeDist * 0.95)
        recenterBy(xDist: normal.dx, yDist: normal.dy)
    }

    private func reflectOff(normal: CGVector) {
        var reflection = normal
        let velocityComp = velocity.dot(other: reflection)
        reflection.scale(factor: 2 * velocityComp)
        velocity.dy -= reflection.dy
        velocity.dx -= reflection.dx
        velocity.scale(factor: restitution)
    }

    // MARK: Wall Handling

    /// Recomputes velocity after impacting a wall.
    /// - Parameters:
    ///   - frame: The dimensions of the boundaries that the object is housed within.
    ///   - borders: The set of walls that the object can bounce off.
    override func handleCollisionWithBorders(frame: CGRect, borders: Set<Border>) {
        let bouncedVerti = bounceOffVerticalWall(frame: frame, borders: borders)
        let bouncedHori = bounceOffHorizontalWall(frame: frame, borders: borders)
        if bouncedVerti || bouncedHori {
            velocity.scale(factor: restitution)
        }
    }

    private func bounceOffVerticalWall(frame: CGRect, borders: Set<Border>) -> Bool {
        let toBounceOffLeft = collidingWithLeftWall(frame: frame, borders: borders)
        let toBounceOffRight = collidingWithRightWall(frame: frame, borders: borders)
        if toBounceOffLeft || toBounceOffRight {
            velocity.dx *= -1
            return true
        }
        return false
    }

    private func collidingWithLeftWall(frame: CGRect, borders: Set<Border>) -> Bool {
        let touchingLeft = center.x - radius <= 0
        let headingLeft = velocity.dx < 0
        let leftBorderExists = borders.contains(.left)
        return touchingLeft && headingLeft && leftBorderExists
    }

    private func collidingWithRightWall(frame: CGRect, borders: Set<Border>) -> Bool {
        let touchingRight = center.x + radius >= frame.width
        let headingRight = velocity.dx > 0
        let rightBorderExists = borders.contains(.right)
        return touchingRight && headingRight && rightBorderExists
    }

    private func bounceOffHorizontalWall(frame: CGRect, borders: Set<Border>) -> Bool {
        let toBounceOffTop = collidingWithTopWall(frame: frame, borders: borders)
        let toBounceOffBottom = collidingWithBottomWall(frame: frame, borders: borders)
        if toBounceOffTop || toBounceOffBottom {
            velocity.dy *= -1
            return true
        }
        return false
    }

    private func collidingWithTopWall(frame: CGRect, borders: Set<Border>) -> Bool {
        let touchingTop = center.y - radius <= 0
        let headingTop = velocity.dy < 0
        let topBorderExists = borders.contains(.top)
        return touchingTop && headingTop && topBorderExists
    }

    private func collidingWithBottomWall(frame: CGRect, borders: Set<Border>) -> Bool {
        let touchingBottom = center.y + radius >= frame.height
        let headingBottom = velocity.dy > 0
        let bottomBorderExists = borders.contains(.bottom)
        return touchingBottom && headingBottom && bottomBorderExists
    }

    // MARK: For Testing

    override func isEqual(_ other: Any?) -> Bool {
        guard let other = other as? PhysicsBall else {
            return false
        }

        return center == other.center
            && radius == other.radius
            && restitution == other.restitution
            && velocity == other.velocity
            && acceleration == other.acceleration
    }

    func recenterBy(xDist: CGFloat, yDist: CGFloat) {
        center.x -= xDist
        center.y -= yDist
    }

}
