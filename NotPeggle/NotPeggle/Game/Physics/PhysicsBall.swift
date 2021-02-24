//
//  PhysBody.swift
//  NotPeggle
//
//  Created by Ying Gao on 8/2/21.
//

import UIKit

/**
 Representation of an object capable of interacting physically with other objects.
 As of now it can only represent circular 2D objects, defined with a `center` and `radius`.
 Each object also has a `restitution` value that defines the amount of velocity retained  after a collision,
 as well as its `velocity` and `acceleration`.
 */
class PhysicsBall: NSObject {

    // MARK: Physical attributes
    private(set) var center: CGPoint
    private(set) var radius: CGFloat
    private(set) var restitution: CGFloat

    // MARK: Dynamic attributes
    var velocity: CGVector
    var acceleration: CGVector

    init?(pos: CGPoint, radius: CGFloat, restitution: CGFloat, velo: CGVector, accel: CGVector) {
        center = pos
        guard radius > 0 else {
            return nil
        }

        self.radius = radius
        self.restitution = restitution
        velocity = velo
        acceleration = accel
    }

    /// Checks if the given PhysBody collides with another (i.e. areas intersect).
    func collides(with other: PhysicsBall) -> Bool {
        guard other !== self else {
            return false
        }
        let otherCenter = other.center
        let distX = center.x - otherCenter.x
        let distY = center.y - otherCenter.y
        let dist = sqrt((distX * distX) + (distY * distY))
        let minSafeDist = radius + other.radius
        return dist <= minSafeDist
    }

    /// Computes the new location of the object after the elapsed `time` and moves it to that location.
    func updateProperties(time: TimeInterval) {
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

    private func displacementComponent(after time: Double) -> ((CGFloat, CGFloat) -> CGFloat) {
        return { (velocityComp: CGFloat, accelerationComp: CGFloat) in
            let distCompFromVelocity = velocityComp.native * time
            let distCompFromAccel = 1/2 * accelerationComp.native * time * time
            let displacement = distCompFromVelocity + distCompFromAccel
            return CGFloat(displacement)
        }
    }

    private func setNewVelocity(time: Double) {
        velocity.dx += CGFloat(acceleration.dx.native * time)
        velocity.dy += CGFloat(acceleration.dy.native * time)
    }

    /// Recomputes the velocity after a collision with the given `object`.
    /// If the two objects do not collide, this does not change anything.
    /// If the object has already collided and has not fully left the intersecting area,
    /// this method also does not change anything.
    func handleCollision(object: PhysicsBall) {
        guard collides(with: object) else {
            return
        }

        let tangent = center.unitTangentTo(point: object.center)
        let angleOffSet = tangent.angleInRads
        reflect(at: angleOffSet)
    }

    private func reflect(at angleOffSet: CGFloat) {
        velocity.rotate(by: -angleOffSet)
        velocity.dy *= -1
        velocity.rotate(by: angleOffSet)
        velocity.scale(factor: restitution)
    }

    // MARK: Wall Handling

    /// Recomputes velocity after impacting a wall.
    /// - Parameters:
    ///   - frame: The dimensions of the boundaries that the object is housed within.
    ///   - borders: The set of walls that the object can bounce off.
    func handleCollisionWithBorders(frame: CGRect, borders: Set<Border>) {
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
