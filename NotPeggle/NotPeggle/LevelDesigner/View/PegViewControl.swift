//
//  PegViewControls.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/2/21.
//

import UIKit

class PegViewControl: UIView {

    private(set) weak var target: PegView?

    func activate(target: PegView) {
        self.target = target
        isHidden = false
        isUserInteractionEnabled = true
    }

    func deactivate() {
        isHidden = true
        isUserInteractionEnabled = false
        target = nil
    }

}

class BlockViewControl: UIView {

    private(set) weak var target: BlockView?

    func activate(target: BlockView) {
        self.target = target
        isHidden = false
        isUserInteractionEnabled = true
    }

    func deactivate() {
        isHidden = true
        isUserInteractionEnabled = false
        target = nil
    }

}
