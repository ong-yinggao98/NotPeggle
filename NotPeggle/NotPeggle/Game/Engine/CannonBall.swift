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

    /// Constructs a cannon at the given `coord` ready to move at the given `angle`.
    init(angle: CGFloat, coord: CGPoint) {
        let velocity = CannonBall.calculateInitialVelocity(angle: angle)
        // Since the radius is definitely positive it should not fail
        super.init(center: coord, radius: CannonBall.radius, velocity: velocity)!
    }

    internal init?(coord: CGPoint, velocity: CGVector) {
        super.init(center: coord, radius: CannonBall.radius, velocity: velocity)
    }

    /// Computes the velocity from the magnitude and angle of launch
    private static func calculateInitialVelocity(angle: CGFloat) -> CGVector {
        let xComp = CannonBall.speed * cos(angle)
        let yComp = CannonBall.speed * sin(angle)
        return CGVector(dx: xComp, dy: yComp)
    }

    /// Checks if the cannon has left the given `frame`.
    func outOfBounds(frame: CGRect) -> Bool {
        let outOfLeftBound = center.x + radius <= 0
        let outOfRightBound = center.x - radius >= frame.width
        let outOfTopBound = center.y + radius <= 0
        let outOfBottomBound = center.y - radius >= frame.height
        return outOfLeftBound || outOfRightBound || outOfTopBound || outOfBottomBound
    }

}
