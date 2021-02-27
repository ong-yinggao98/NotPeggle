//
//  PowerUpManager.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/2/21.
//

import UIKit

class PowerUpManager {

    private(set) var powerUps: [PowerUp] = []
    private var index = -1

    private weak var engine: GameEngine?

    init() {
        powerUps.append(SpaceBlast())
        powerUps.append(SpookyBall())
        index = 0
    }

    func setEngine(_ engine: GameEngine) {
        self.engine = engine
    }

    func activateNextPowerUp(from peg: GamePeg) {
        guard !powerUps.isEmpty, let engine = engine else {
            return
        }
        powerUps[index].activate(peg: peg, on: engine)
        index = (index + 1) % powerUps.count
    }

}
