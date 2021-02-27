//
//  BlueGamePeg.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/2/21.
//

import UIKit

class BlueGamePeg: GamePeg {

    static let score = 100

    override var hit: Bool {
        didSet {
            guard hit else {
                return
            }
            delegate?.updateScore(BlueGamePeg.score)
        }
    }

    init?(pos: CGPoint, radius: CGFloat) {
        super.init(pegColor: .blue, pos: pos, radius: radius)
    }

}
