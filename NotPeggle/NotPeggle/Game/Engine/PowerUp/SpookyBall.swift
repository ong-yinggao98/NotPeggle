//
//  SpookyBall.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/2/21.
//

import UIKit

struct SpookyBall: PowerUp {

    func activate(peg: GamePeg, on engine: GameEngine) {
        guard let ball = engine.cannon else {
            fatalError("Ball should have been fired for this to be activated")
        }
        ball.guaranteeRespawn()
    }

}
