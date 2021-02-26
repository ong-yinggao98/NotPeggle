//
//  ModelGameConverter.swift
//  NotPeggle
//
//  Created by Ying Gao on 12/2/21.
//

import UIKit

/**
 Utility struct that provides static methods for building `GameEngine` objects from `Model` instances and converting
 `Peg` instances into the physics-enabled `GamePeg` for use in the engine.
 */
struct ModelGameConverter {

    /// Converts a given `Model` into a `GameEngine`.
    /// The engine has the same boundaries as the `model` as well as its converted pegs.
    static func gameRepresentation(model: Model) -> GameEngine {
        let engine = initializeEngine(model: model)
        let output = getGamePegs(from: model)
        engine.loadPegsIntoWorld(pegs: output)
        return engine
    }

    private static func initializeEngine(model: Model) -> GameEngine {
        let frame = CGRect(x: 0, y: 0, width: model.width, height: model.height)
        return GameEngine(frame: frame)
    }

    private static func getGamePegs(from model: Model) -> [GamePeg] {
        let pegs = model.pegs
        var output: [GamePeg] = []
        for peg in pegs {
            guard let gamePeg = gameRepresentation(peg: peg) else {
                continue
            }
            output.append(gamePeg)
        }
        return output
    }

    /// Converts a given `Peg` into a `GamePeg` with the same colour and coordinates.
    static func gameRepresentation(peg: Peg) -> GamePeg? {
        let color = peg.color
        let pos = peg.center
        let gamePos = CGPoint(x: pos.x, y: pos.y)
        let radius = CGFloat(peg.radius)
        return GamePeg(pegColor: color, pos: gamePos, radius: radius)
    }

}
