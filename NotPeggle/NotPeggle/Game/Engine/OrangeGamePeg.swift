//
//  OrangeGamePeg.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/2/21.
//

import UIKit

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
