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
    static let searchRadius: CGFloat = 100

    override var hit: Bool {
        didSet {
            guard hit else {
                return
            }
            delegate?.updateScore(GreenGamePeg.score)
            hitAllPegsInVicinity()
        }
    }

    init?(pos: CGPoint, radius: CGFloat) {
        super.init(pegColor: .green, pos: pos, radius: radius)
    }

    func hitAllPegsInVicinity() {
        let searchDistance = GreenGamePeg.searchRadius + radius
        delegate?.pegsInVicinity(searchRadius: searchDistance, around: center)
            .filter { !$0.hit }
            .forEach { $0.hit = true }
    }

}
