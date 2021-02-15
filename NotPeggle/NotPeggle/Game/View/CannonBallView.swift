//
//  GameCannonBallView.swift
//  NotPeggle
//
//  Created by Ying Gao on 13/2/21.
//

import UIKit

class CannonBallView: UIView {

    static var image: UIImageView {
        return UIImageView(image: UIImage(named: "ball"))
    }

    init(center: CGPoint) {
        let radius = CGFloat(Constants.pegRadius)
        let frame = CGFrameFactory.createFrame(center: center, radius: radius)
        super.init(frame: frame)
        setImage()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setImage() {
        let image = CannonBallView.image
        image.frame = bounds
        addSubview(image)
    }

}
