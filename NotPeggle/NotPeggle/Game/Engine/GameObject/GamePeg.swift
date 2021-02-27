//
//  GamePeg.swift
//  NotPeggle
//
//  Created by Ying Gao on 12/2/21.
//

import UIKit

/**
 Abstract representation of an immovable `GamePeg` that lights up when hit by a cannon ball.
 This class should not be directly constructed.
 */
class GamePeg: StationaryBall {

    var hit = false
    let color: Color

    weak var delegate: GamePegDelegate?

    init?(pegColor: Color, pos: CGPoint, radius: CGFloat) {
        color = pegColor
        super.init(center: pos, radius: radius)
    }

    override func handleCollision(object: PhysicsBody) {
        guard collides(with: object), object is CannonBall, !hit else {
            return
        }
        hit = true
    }

    func distanceBetweenCenters(peg: GamePeg) -> CGFloat {
        center.distanceTo(point: peg.center)
    }
}

protocol GamePegDelegate: AnyObject {

    func updateScore(_ score: Int)

    func activatePowerUp(_ peg: GamePeg)

}
