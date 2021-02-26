//
//  CannonView.swift
//  NotPeggle
//
//  Created by Ying Gao on 22/2/21.
//

import UIKit

class CannonView: UIImageView {

    static var sprite: UIImage! {
        #imageLiteral(resourceName: "cannon")
    }

    init(launchPosition: CGPoint) {
        let frame = CannonView.frameCenteredAt(position: launchPosition)
        super.init(frame: frame)
        contentMode = .scaleAspectFit
        image = CannonView.sprite
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func frameCenteredAt(position: CGPoint) -> CGRect {
        let width = Constants.cannonWidth
        let originX = position.x - CGFloat(width / 2)
        let originY = position.y - CGFloat(width / 2)
        let origin = CGPoint(x: originX, y: originY)
        let size = CGSize(width: width, height: width)
        return CGRect(origin: origin, size: size)
    }

    func rotate(facing position: CGPoint) {
        let vector = position.unitNormalTo(point: center)
        var angle = vector.angleInRads - CGFloat.pi / 2
        if vector.dx > 0 {
            angle += CGFloat.pi
        }
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform(rotationAngle: angle); })
    }

}
