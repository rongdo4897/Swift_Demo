//
//  ClockViewCenterCircle.swift
//  Clock View
//
//  Created by V002861 on 11/29/22.
//

import UIKit

class ClockViewCenterCircle: UIImageView {
    convenience init(radius: CGFloat, circleDiameter: CGFloat, lineWidth: CGFloat, color: UIColor) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: radius * 2, height: radius * 2))
        let circle: UIImage = renderer.image { (ctx) in
            let rectangle = CGRect(x: radius - circleDiameter * lineWidth / 2,
                                   y: radius - circleDiameter * lineWidth / 2,
                                   width: circleDiameter * lineWidth,
                                   height: circleDiameter * lineWidth)
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.setStrokeColor(color.cgColor)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        self.init(image: circle)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
