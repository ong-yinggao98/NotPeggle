//
//  GreenGamePeg.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/2/21.
//

import UIKit

/**
 Representation of a green peg that activates the Space Blast powerup when hit, lighting up all nearby pegs.
 */
class GreenGamePeg: GamePeg {

    static let score = 100

    override var hit: Bool {
        didSet {
            guard hit else {
                return
            }
            delegate?.updateScore(GreenGamePeg.score)
            delegate?.activatePowerUp(self)
        }
    }

    init?(pos: CGPoint, radius: CGFloat) {
        super.init(pegColor: .green, pos: pos, radius: radius)
    }

}
