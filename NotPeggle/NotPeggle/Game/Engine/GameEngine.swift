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
class GameEngine: PhysicsWorldDelegate {

    private(set) var ballLaunched = false
    private(set) var world: PhysicsWorld

    private(set) var launchPoint: CGPoint
    private(set) var launchAngle: CGFloat

    private(set) var cannon: CannonBall?
    private(set) var gamePegs: [GamePeg] = []

    weak var observer: GameEngineDelegate?

    init(frame: CGRect) {
        world = PhysicsWorld(frame: frame, excluding: .bottom)
        let xCoord = frame.width / 2
        let yCoord = CGFloat(Constants.pegRadius)
        launchPoint = CGPoint(x: xCoord, y: yCoord)
        launchAngle = CGFloat.pi / 2
        world.delegate = self
    }

    /// Adds the `GamePeg` objects into the engine if they do not already exist.
    func loadPegsIntoWorld(pegs: [GamePeg]) {
        pegs.filter { !gamePegs.contains($0) }
            .forEach { world.insert(body: $0) }
    }

    func setObserver(delegate: GameEngineDelegate) {
        observer = delegate
    }

    /// Updates the location of all pegs and cannon balls (if the latter is present).
    /// If the cannon has left the boundaries, it performs the removal of hit pegs and the cannon.
    func refresh(elapsed: TimeInterval) {
        world.update(time: elapsed)
        observer?.updateSprites()
        handleCannonExit()
    }

    // MARK: Turn End Handlers

    /// Checks if the cannon is within the playing area. If it has left, it is removed and all hit pegs are removed.
    func handleCannonExit() {
        guard let currentCannon = cannon else {
            return
        }
        let cannonHasLeftArea = currentCannon.outOfBounds(frame: world.dimensions)
        guard cannonHasLeftArea else {
            return
        }
        removeAllHitPegs()
        removeCannonBall()
    }

    func removeCannonBall() {
        guard let currentCannon = cannon else {
            return
        }
        world.remove(body: currentCannon)
        cannon = nil
        ballLaunched = false
    }

    func removeAllHitPegs() {
        let hitPegs = gamePegs.filter { $0.hit }
        hitPegs.forEach { world.remove(body: $0) }
    }

    // MARK: Cannon Handling

    func aim(at coordinates: CGPoint) {
        launchAngle = calculateAngleOfFire(coordinates: coordinates)
    }

    /// Fires a cannon ball towards the given `coordinates` if there is no cannon active in the engine.
    func launch() {
        guard !ballLaunched else {
            return
        }
        startCannonSimulation()
    }

    private func startCannonSimulation() {
        cannon = CannonBall(angle: launchAngle, coord: launchPoint)
        guard let cannon = cannon else {
            fatalError("Cannon should be initialised by now")
        }
        world.insert(body: cannon)
        ballLaunched = true
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

    // MARK: Cleanup

    /// Removes unneeded resources.
    func cleanUp() {
        cannon = nil
        gamePegs.removeAll()
    }

    // MARK: Delegate Methods

    func updateAddedPegs() {
        world.bodies
            .compactMap { $0 as? GamePeg }
            .filter { !gamePegs.contains($0) }
            .forEach { gamePegs.append($0) }
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
    }

}
