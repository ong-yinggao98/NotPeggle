//
//  BlueGamePeg.swift
//  NotPeggle
//
//  Created by Ying Gao on 12/2/21.
//

import UIKit

/**
 Representation of an immovable `GamePeg`. It lights up when hit by a cannon ball.
 */
class GamePeg: StationaryObject {
    var hit = false
    let color: Color

    init?(pegColor: Color, pos: CGPoint, radius: CGFloat) {
        color = pegColor
        super.init(center: pos, radius: radius)
    }

    override func handleCollision(object: PhysicsBody) {
        super.handleCollision(object: object)
        guard object is CannonBall, collides(with: object) else {
            return
        }
        hit = true
    }
}
