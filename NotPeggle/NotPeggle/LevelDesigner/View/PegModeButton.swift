//
//  PegModeButton.swift
//  NotPeggle
//
//  Created by Ying Gao on 25/1/21.
//

import UIKit

/**
 A button used for selecting the mode that the level designer should be in.
 The mode can either be:
    - Adding blue pegs
    - Adding orange pegs
    - Deleting pegs
 It has no special functionality as far as `UIButton` goes, except that it becomes
 opaque when selected and slightly translucent otherwise.
 */
class PegModeButton: UIButton {

    static let selectedAlpha = CGFloat(1.0)
    static let unselectedAlpha = CGFloat(0.7)

    override var isSelected: Bool {
        didSet {
            changeAppearance()
        }
    }

    func changeAppearance() {
        if isSelected {
            alpha = PegModeButton.selectedAlpha
        } else {
            alpha = PegModeButton.unselectedAlpha
        }
    }
}
