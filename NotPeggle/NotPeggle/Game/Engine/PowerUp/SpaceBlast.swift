//
//  SpaceBlast.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/2/21.
//

import UIKit

struct SpaceBlast: PowerUp {

    private static let searchRadius: CGFloat = 100

    func activate(peg: GamePeg, on engine: GameEngine) {
        let totalSearchRadius = SpaceBlast.searchRadius + peg.radius
        engine.gamePegs
            .filter { $0.distanceBetweenCenters(peg: peg) <= totalSearchRadius && !$0.hit }
            .forEach { $0.hit = true }
    }

}
