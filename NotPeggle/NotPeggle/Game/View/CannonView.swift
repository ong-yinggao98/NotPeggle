//
//  CannonView.swift
//  NotPeggle
//
//  Created by Ying Gao on 22/2/21.
//

import UIKit

class CannonView: UIImageView {

    static var sprite: UIImage! {
        return UIImage(named: "cannon")
    }

    init(angle: CGFloat, launchPosition: CGPoint) {
        super.init(frame: CGRect.zero)
        image = CannonView.sprite
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
