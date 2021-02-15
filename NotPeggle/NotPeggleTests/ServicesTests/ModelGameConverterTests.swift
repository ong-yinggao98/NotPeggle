//
//  ModelGameConverterTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 12/2/21.
//

import XCTest
@testable import NotPeggle

class ModelGameConverterTests: XCTestCase {

    typealias MGC = ModelGameConverter

    var pegA: Peg {
        return Peg(centerX: 32, centerY: 32, color: .blue)
    }
    var pegAGame: GamePeg? {
        return GamePeg(pegColor: .blue, pos: CGPoint(x: 32, y: 32))
    }

    var pegB: Peg {
        return Peg(centerX: 90, centerY: 80, color: .orange)
    }
    var pegBGame: GamePeg? {
        return GamePeg(pegColor: .orange, pos: CGPoint(x: 90, y: 80))
    }

    func testPegGameRepresentation() {
        XCTAssertEqual(pegAGame, MGC.gameRepresentation(peg: pegA))
        XCTAssertEqual(pegBGame, MGC.gameRepresentation(peg: pegB))
    }

    var emptyModel: Model {
        return Model(width: 300, height: 300)!
    }

    func testModelGameRepresentation_emptyModel_emptyArray() {
        let engine = MGC.gameRepresentation(model: emptyModel)
        let expectedFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        XCTAssertEqual(expectedFrame, engine.world.dimensions)
        XCTAssertTrue(engine.gamePegs.isEmpty)
    }

    func testModelGameRepresentation_populatedModel() {
        let model = Model(name: "", pegs: [pegA, pegB], width: 300, height: 300)
        guard
            let test = model,
            let pegAGame = pegAGame,
            let pegBGame = pegBGame
        else {
            XCTFail("Init should not fail")
            return
        }
        let expectedFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        let expectedPegs: Set<GamePeg> = [pegAGame, pegBGame]
        let actual = MGC.gameRepresentation(model: test)
        let actualPegs = Set(actual.gamePegs)
        XCTAssertEqual(expectedFrame, actual.world.dimensions)
        TestUtils.comparePhysicsBodySets(expected: expectedPegs, actual: actualPegs)
    }

}
