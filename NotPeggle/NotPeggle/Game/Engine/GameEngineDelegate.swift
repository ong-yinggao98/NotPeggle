//
//  GameEngineDelegate.swift
//  NotPeggle
//
//  Created by Ying Gao on 13/2/21.
//

protocol GameEngineDelegate: AnyObject {

    func updateCannonBallPosition()

    func highlightPegs()

    /// Adds view representations for level objects that do not already have one.
    func addMissingObjects(pegs: [GamePeg], blocks: [GameBlock])

    /// Hides the view representation of the given `GamePeg`.
    func removeView(of peg: GamePeg)

    func displayScore()

    /// Ends the game and displays a message based on the condition on which the game had ended.
    func endGame(condition: GameOverState)

    func setLaunchButtonState()

}
