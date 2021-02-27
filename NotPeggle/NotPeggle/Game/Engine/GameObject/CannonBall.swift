//
//  CannonBall.swift
//  NotPeggle
//
//  Created by Ying Gao on 12/2/21.
//

import UIKit

/**
 Representation of a cannon ball with hard-coded speed.
 */
class CannonBall: GravBouncingBall {

    static let speed: CGFloat = 1_000
    static let radius = CGFloat(Constants.pegRadius)

    private(set) var framesStuck = 0
    private let minimumDisplacement: CGFloat = 0.5 // Minimum displacement of 0.4 to account for micro-bounces
    private let limit = 600 // Roughly 10 seconds is allowed before a ball is considered effectively stuck

    // ========== //
    // MARK: Init
    // ========== //

    /// Constructs a cannon at the given `coord` ready to move at the given `angle`.
    init(angle: CGFloat, coord: CGPoint) {
        let velocity = CannonBall.calculateInitialVelocity(angle: angle)
        // Since the radius is definitely positive it should not fail
        super.init(center: coord, radius: CannonBall.radius, velocity: velocity)!
    }

    /// Computes the velocity from the magnitude and angle of launch
    private static func calculateInitialVelocity(angle: CGFloat) -> CGVector {
        let xComp = CannonBall.speed * cos(angle)
        let yComp = CannonBall.speed * sin(angle)
        return CGVector(dx: xComp, dy: yComp)
    }

    internal init?(coord: CGPoint, velocity: CGVector) {
        super.init(center: coord, radius: CannonBall.radius, velocity: velocity)
    }

    override func updateProperties(time: TimeInterval) {
        let initialPosition = center
        super.updateProperties(time: time)
        let displacement = CGVector(dx: center.x - initialPosition.x, dy: center.y - initialPosition.y)
        checkIfStuck(displacement: displacement)
    }

    // ================== //
    // MARK: Stuck checks
    // ================== //

    private func checkIfStuck(displacement: CGVector) {
        let minDistSquared = minimumDisplacement * minimumDisplacement
        if displacement.magnitudeSquared < minDistSquared {
            framesStuck += 1
            print(framesStuck)
        } else {
            framesStuck = 0
        }
    }

    var stuck: Bool {
        framesStuck > limit
    }

    // =================== //
    // MARK: Exit handling
    // =================== //

    private(set) var hasLivesLeft: Bool = false

    func guaranteeRespawn() {
        // heheh
        hasLivesLeft = true
    }

    /// Checks if the cannon has left the given `frame`.
    func outOfBounds(frame: CGRect) -> Bool {
        let outOfLeftBound = center.x + radius <= 0
        let outOfRightBound = center.x - radius >= frame.width
        let outOfTopBound = center.y + radius <= 0
        let outOfBottomBound = center.y - radius >= frame.height
        return outOfLeftBound || outOfRightBound || outOfTopBound || outOfBottomBound
    }

    func respawnAtTopIfPossible() {
        guard hasLivesLeft else {
            return
        }
        let distToMove = center.y - radius
        recenterBy(xDist: 0, yDist: distToMove)
        hasLivesLeft = false
    }

}
