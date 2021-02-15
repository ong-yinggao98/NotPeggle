//
//  CGFrameFactory.swift
//  NotPeggle
//
//  Created by Ying Gao on 13/2/21.
//

import UIKit

/**
 Utility construct for building frames for circular UIView objects.
 */
struct CGFrameFactory {
    static func createFrame(center: CGPoint, radius: CGFloat) -> CGRect {
        let origin = CGPoint(x: center.x - radius, y: center.y - radius)
        let diameter = radius * 2
        let size = CGSize(width: diameter, height: diameter)
        return CGRect(origin: origin, size: size)
    }
}
