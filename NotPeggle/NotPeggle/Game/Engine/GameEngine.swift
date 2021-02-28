//
//  GameEngine.swift
//  NotPeggle
//
//  Created by Ying Gao on 10/2/21.
//

import UIKit

/**
 Game-specific engine.
 */
class GameEngine: PhysicsWorldDelegate, GamePegDelegate {

    // ================ //
    // MARK: Properties
    // ================ //

    private(set) var ballLaunched = false
    private(set) var world: PhysicsWorld
    private var powerUpsManager: PowerUpManager

    private(set) var launchPoint: CGPoint
    private(set) var launchAngle: CGFloat

    private(set) var cannonBall: CannonBall?
    private(set) var gamePegs: [GamePeg] = []
    private(set) var gameBlocks: [GameBlock] = []

    private(set) var shotsLeft = 0
    private(set) var score = 0
    private(set) var requiredScore = 0

    weak var delegate: GameEngineDelegate?

    init(frame: CGRect, delegate: GameEngineDelegate?) {
        world = PhysicsWorld(frame: frame, excluding: .bottom)
        powerUpsManager = PowerUpManager()

        let xCoord = frame.width / 2
        let yCoord = CGFloat(Constants.pegRadius)
        launchPoint = CGPoint(x: xCoord, y: yCoord)
        launchAngle = CGFloat.pi / 2

        world.setDelegate(self)
        powerUpsManager.setEngine(self)
        self.delegate = delegate
    }

    /// Adds the `GamePeg` objects into the engine if they do not already exist.
    func loadIntoWorld(pegs: [GamePeg], blocks: [GameBlock]) {
        pegs.filter { !gamePegs.contains($0) }
            .forEach { world.insert(body: $0) }
        blocks.filter { !gameBlocks.contains($0) }
            .forEach { world.insert(body: $0) }
    }

    /// Updates the location of all pegs and cannon balls (if the latter is present).
    /// If the cannon has left the boundaries, it performs the removal of hit pegs and the cannon.
    func refresh(elapsed: TimeInterval) {
        world.update(time: elapsed)
        delegate?.updateCannonBallPosition()
        delegate?.highlightPegs()
        handleBallStuck()
        handleCannonExit()
    }

    // ======================= //
    // MARK: Turn End Handlers
    // ======================= //

    /// Checks if the cannon is within the playing area. If it has left, it is removed and all hit pegs are removed.
    func handleCannonExit() {
        guard
            let ball = cannonBall,
            ball.outOfBounds(frame: world.dimensions)
        else {
            return
        }

        ball.respawnAtTopIfPossible()
        if ball.outOfBounds(frame: world.dimensions) {
            removeAllHitPegs()
            removeCannonBall()
        }
    }

    func handleBallStuck() {
        guard let ball = cannonBall, ball.stuck else {
            return
        }
        removeAllHitPegs()
        removeCannonBall()
    }

    func removeCannonBall() {
        guard let ball = cannonBall else {
            return
        }
        world.remove(body: ball)
        cannonBall = nil
        ballLaunched = false
        delegate?.setLaunchButtonState()
        endGameIfPossible()
    }

    func removeAllHitPegs() {
        let hitPegs = gamePegs.filter { $0.hit }
        hitPegs.forEach { world.remove(body: $0) }
    }

    /// Checks if the conditions for ending the game have been met.
    /// If the game had no pegs to begin with, a no start is declared.
    /// If the player has gotten the required score within the number of cannon shots, he wins.
    /// If the player has used up all shots and failed to score the minimum score, he loses.
    /// Otherwise, the game continues.
    func endGameIfPossible() {
        // TODO: Implement this
        // delegate?.endGame(won)
        if requiredScore <= 0 {
            delegate?.endGame(condition: .noStart)
        }
        if shotsLeft >= 0 && score >= requiredScore {
            delegate?.endGame(condition: .won)
        }
        if shotsLeft < 1 && score < requiredScore {
            delegate?.endGame(condition: .lost)
        }
    }

    // ===================== //
    // MARK: Cannon Handling
    // ===================== //

    func aim(at coordinates: CGPoint) {
        launchAngle = calculateAngleOfFire(coordinates: coordinates)
    }

    /// Fires a cannon ball towards the given `coordinates` if there is no cannon active in the engine.
    func launch() {
        guard !ballLaunched, shotsLeft > 0 else {
            return
        }
        startCannonSimulation()
    }

    private func startCannonSimulation() {
        cannonBall = CannonBall(angle: launchAngle, coord: launchPoint)
        guard let ball = cannonBall else {
            fatalError("Cannon should be initialised by now")
        }
        world.insert(body: ball)
        ballLaunched = true
        delegate?.setLaunchButtonState()
        shotsLeft -= 1
    }

    func calculateAngleOfFire(coordinates: CGPoint) -> CGFloat {
        let xDist = coordinates.x - launchPoint.x
        let yDist = coordinates.y - launchPoint.y
        var angle = CGVector(dx: xDist, dy: yDist).angleInRads

        if xDist < 0 {
            angle += CGFloat.pi
        }
        return angle
    }

    // ============= //
    // MARK: Cleanup
    // ============= //

    /// Removes unneeded resources.
    func cleanUp() {
        cannonBall = nil
        gameBlocks = []
        gamePegs = []
        world.removeAll()
    }

    // ==================================== //
    // MARK: Physics World Delegate Methods
    // ==================================== //

    func updateAddedPegs() {
        let pegsToAdd = world.bodies.compactMap { $0 as? GamePeg }.filter { !gamePegs.contains($0) }
        for peg in pegsToAdd {
            gamePegs.append(peg)
            peg.delegate = self
        }
        shotsLeft += pegsToAdd.count
        shotsLeft = min(shotsLeft, 10)
        requiredScore += pegsToAdd.count * BlueGamePeg.score

        let blocksToAdd = world.bodies.compactMap { $0 as? GameBlock }.filter { !gameBlocks.contains($0) }
        blocksToAdd.forEach { gameBlocks.append($0) }

        delegate?.addMissingObjects(pegs: pegsToAdd, blocks: blocksToAdd)
    }

    func updateRemovedPegs() {
        gamePegs.filter { !world.contains(body: $0) }
            .forEach { remove(peg: $0) }
    }

    private func remove(peg: GamePeg) {
        guard let index = gamePegs.firstIndex(of: peg) else {
            return
        }
        gamePegs.remove(at: index)
        delegate?.removeView(of: peg)
    }

    // =============================== //
    // MARK: Game Peg Delegate Methods
    // =============================== //

    func updateScore(_ score: Int) {
        self.score += score
        delegate?.displayScore()
    }

    func activatePowerUp(_ peg: GamePeg) {
        guard peg.color == .green else {
            print("Only green pegs have power ups, loser.")
            return
        }
        powerUpsManager.activateNextPowerUp(from: peg)
    }

}

enum GameOverState {
    case won, lost, noStart
}
