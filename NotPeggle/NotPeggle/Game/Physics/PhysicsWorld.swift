//
//  PhysicsWorld.swift
//  NotPeggle
//
//  Created by Ying Gao on 10/2/21.
//

import UIKit

/**
 Physics engine.
 It contains a set of `PhysicsObject` objects capable of interacting with each other, as well as
 borders representing walls to collide into.
 */
class PhysicsWorld: NSObject {

    private(set) var bodies: Set<PhysicsBody> = []
    let dimensions: CGRect
    private(set) var borders: Set<Border> = [.top, .bottom, .left, .right]

    weak var delegate: PhysicsWorldDelegate?

    /// Constructs a `PhysicsWorld` with the given boundaries.
    init(frame: CGRect) {
        dimensions = frame
    }

    /// Constructs a `PhysicsWorld` without the given `borders`.
    /// The resulting engine will not trigger collision events for objects touching excluded borders.
    init(frame: CGRect, excluding borders: Border...) {
        dimensions = frame
        for border in borders {
            self.borders.remove(border)
        }
    }

    internal init(frame: CGRect, bodies: [PhysicsBody]) {
        dimensions = frame
        self.bodies = Set(bodies)
    }

    func insert(body: PhysicsBody) {
        guard !bodies.contains(body) else {
            return
        }
        bodies.insert(body)
        delegate?.updateAddedPegs()
    }

    func remove(body: PhysicsBody) {
        bodies.remove(body)
        delegate?.updateRemovedPegs()
    }

    func contains(body: PhysicsBody) -> Bool {
        bodies.contains(body)
    }

    func removeAll() {
        bodies = []
        delegate?.updateRemovedPegs()
    }

    /// Updates the location of every `PhysicsObject` in the world after an elapsed `time`, and
    /// also resolves collisions between objects.
    func update(time: TimeInterval) {
        for body in bodies {
            body.updateProperties(time: time)
            bodies.forEach { body.handleCollision(object: $0) }
            body.handleCollisionWithBorders(frame: dimensions, borders: borders)
        }
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? PhysicsWorld else {
            return false
        }
        return dimensions == other.dimensions
            && bodies == other.bodies
    }

}

enum Border: String, Hashable {
    case top, bottom, left, right
}
