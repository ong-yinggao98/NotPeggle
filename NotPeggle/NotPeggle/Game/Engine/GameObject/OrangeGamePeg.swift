//
//  OrangeGamePeg.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/2/21.
//

import UIKit

/**
 Representation of an orange peg that merits a higher score than others, allowing the player
 to more easily meet the mimum score required to win the game.
 */
class OrangeGamePeg: GamePeg {

    static let score = 200

    override var hit: Bool {
        didSet {
            guard hit else {
                return
            }
            delegate?.updateScore(OrangeGamePeg.score)
        }
    }

    init?(pos: CGPoint, radius: CGFloat) {
        super.init(pegColor: .orange, pos: pos, radius: radius)
    }

}
