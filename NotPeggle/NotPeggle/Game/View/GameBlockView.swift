//
//  GameBlockView.swift
//  NotPeggle
//
//  Created by Ying Gao on 27/2/21.
//

import UIKit

class GameBlockView: UIView {

    static var sprite: UIImageView {
        UIImageView(image: #imageLiteral(resourceName: "Block"))
    }

    init(center: CGPoint, width: CGFloat, height: CGFloat, angle: CGFloat) {
        let origin = CGPoint(x: center.x - (width / 2), y: center.y - (height / 2))
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: width, height: height))

        initialiseImage()
        transform = CGAffineTransform(rotationAngle: angle)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialiseImage() {
        let imageView = BlockView.sprite
        imageView.frame = bounds
        addSubview(imageView)
    }

}
