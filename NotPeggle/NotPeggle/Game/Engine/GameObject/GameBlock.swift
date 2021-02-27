//
//  GameBlock.swift
//  NotPeggle
//
//  Created by Ying Gao on 27/2/21.
//

import UIKit

class GameBlock: PhysicsBlock {

    init(center: CGPoint, width: CGFloat, height: CGFloat, angle: CGFloat) {
        let boundingBox = OrientedBoundingBox(center: center, width: width, height: height, angle: angle)
        super.init(boundingBox: boundingBox, restitution: 0, velocity: CGVector.zero, acceleration: CGVector.zero)
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard object is GameBlock else {
            return false
        }
        return super.isEqual(object)
    }

}
