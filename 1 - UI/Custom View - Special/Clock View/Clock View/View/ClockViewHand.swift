//
//  ClockViewHand.swift
//  Clock View
//
//  Created by V002861 on 11/29/22.
//

import UIKit

struct ClockViewHandParameters {
    var frame: CGRect
    var length: CGFloat
    var width: CGFloat
    var tailLength: CGFloat
    var color: UIColor
    var shadowIsOn: Bool
    var initValue: Double
}

class ClockViewHand: UIImageView {
    convenience init(parameters: ClockViewHandParameters) {
        let radius = min(parameters.frame.width, parameters.frame.height)
        let center = CGPoint(x: radius, y: radius)
        let tail = parameters.tailLength
        let length = parameters.length * radius
        let handTail = tail * radius
        let width = parameters.width * radius
        let color = parameters.color
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: radius * 2, height: radius * 2))
        let point1 = CGPoint(x: center.x - width / 3, y: center.y - length)
        let point2 = CGPoint(x: center.x + width / 3, y: center.y - length)
        let point3 = CGPoint(x: center.x + width / 2, y: center.y + handTail)
        let point4 = CGPoint(x: center.x - width / 2, y: center.y + handTail)
        let hand: UIImage = renderer.image { (ctx) in
            ctx.cgContext.move(to: point1)
            ctx.cgContext.addLine(to: point2)
            ctx.cgContext.addLine(to: point3)
            ctx.cgContext.addLine(to: point4)
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.setStrokeColor(color.cgColor)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        self.init(image: hand)
        
        if parameters.shadowIsOn {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowRadius = parameters.length
            layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSize(width: parameters.length, height: parameters.length)
        }
        transform = CGAffineTransform(rotationAngle: CGFloat(parameters.initValue * Double.pi/180.0)) //set the initial hand position, where initialValue == 60.0 is "15 min"
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateHandAngle(angle: CGFloat, duration: Double = 0.5) {
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { self.transform = CGAffineTransform(rotationAngle: angle) },
                       completion: { (finished: Bool) in
                        return
        })
    }
}
