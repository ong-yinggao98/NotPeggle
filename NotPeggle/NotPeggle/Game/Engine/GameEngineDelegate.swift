//
//  GameEngineDelegate.swift
//  NotPeggle
//
//  Created by Ying Gao on 13/2/21.
//

protocol GameEngineDelegate: AnyObject {

    func updateCannonBallPosition()

    func highlightPegs()

    func addMissingObjects(pegs: [GamePeg], blocks: [GameBlock])

    func removeView(of peg: GamePeg)

}
