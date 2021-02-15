//
//  PegViewDelegate.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/1/21.
//

import UIKit

/**
 Delegate protocol to enable a controller to make changes to data based on
 gestures applied to a `PegView`.
 */
protocol PegViewDelegate: AnyObject {

    func holdToDeletePeg(_ gesture: UILongPressGestureRecognizer)

    func dragPeg(_ gesture: UIPanGestureRecognizer)
}
