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
    static func gameRepresentation(model: Model, delegate: GameEngineDelegate? = nil) -> GameEngine {
        let engine = initializeEngine(model: model, delegate: delegate)
        let gamePegs = getGamePegs(from: model)
        let gameBlocks = getGameBlocks(from: model)
        engine.loadIntoWorld(pegs: gamePegs, blocks: gameBlocks)
        return engine
    }

    private static func initializeEngine(model: Model, delegate: GameEngineDelegate?) -> GameEngine {
        let frame = CGRect(x: 0, y: 0, width: model.width, height: model.height)
        return GameEngine(frame: frame, delegate: delegate)
    }

    private static func getGamePegs(from model: Model) -> [GamePeg] {
        model.pegs.compactMap { gameRepresentation(peg: $0) }
    }

    private static func getGameBlocks(from model: Model) -> [GameBlock] {
        model.blocks.map { gameRepresentation(block: $0) }
    }

    /// Converts a given `Peg` into a `GamePeg` with the same colour and coordinates.
    static func gameRepresentation(peg: Peg) -> GamePeg? {
        let color = peg.color
        let pos = peg.center
        let gamePos = CGPoint(x: pos.x, y: pos.y)
        let radius = CGFloat(peg.radius)
        switch color {
        case .orange:
            return OrangeGamePeg(pos: gamePos, radius: radius)
        case .blue:
            return BlueGamePeg(pos: gamePos, radius: radius)
        case .green:
            return GreenGamePeg(pos: gamePos, radius: radius)
        }

    }

    static func gameRepresentation(block: Block) -> GameBlock {
        let cgCenter = CGPoint(x: block.center.x, y: block.center.y)
        let cgWidth = CGFloat(block.width)
        let cgHeight = CGFloat(block.height)
        let cgAngle = CGFloat(block.angle)
        return GameBlock(center: cgCenter, width: cgWidth, height: cgHeight, angle: cgAngle)
    }

}
