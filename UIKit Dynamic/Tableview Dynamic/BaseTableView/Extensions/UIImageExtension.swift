//
//  UIImageExtension.swift
//  Add Contact
//
//  Created by Hoang Tung Lam on 3/8/21.
//

import Foundation
import UIKit

extension UIImage {
    func crop(withPath: UIBezierPath) -> UIImage {
        let r: CGRect = withPath.cgPath.boundingBox
        UIGraphicsBeginImageContextWithOptions(r.size, false, self.scale)
        if let context = UIGraphicsGetCurrentContext() {
            let rect = CGRect(origin: .zero, size: size)
//            context.setFillColor(andColor.cgColor)
            context.fill(rect)
            context.translateBy(x: -r.origin.x, y: -r.origin.y)
            context.addPath(withPath.cgPath)
            context.clip()
        }
        draw(in: CGRect(origin: .zero, size: size))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    func cropImage(rect: CGRect) -> UIImage {
        let r: CGRect = rect
        UIGraphicsBeginImageContextWithOptions(r.size, false, self.scale)
        if let context = UIGraphicsGetCurrentContext() {
            let rect = CGRect(origin: .zero, size: size)
//            context.setFillColor(andColor.cgColor)
            context.fill(rect)
            context.translateBy(x: -r.origin.x, y: -r.origin.y)
//            context.addPath(withPath.cgPath)
            context.clip()
        }
        draw(in: CGRect(origin: .zero, size: size))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    func flattenImage(topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) -> CIImage {
        let docImage = self.ciImage ?? CIImage()
        let rect = CGRect(origin: CGPoint.zero, size: self.size)
        let perspectiveCorrection = CIFilter(name: "CIPerspectiveCorrection")!
        perspectiveCorrection.setValue(CIVector(cgPoint: self.cartesianForPoint(point: topLeft, extent: rect)), forKey: "inputTopLeft")
        perspectiveCorrection.setValue(CIVector(cgPoint: self.cartesianForPoint(point: topRight, extent: rect)), forKey: "inputTopRight")
        perspectiveCorrection.setValue(CIVector(cgPoint: self.cartesianForPoint(point: bottomLeft, extent: rect)), forKey: "inputBottomLeft")
        perspectiveCorrection.setValue(CIVector(cgPoint: self.cartesianForPoint(point: bottomRight, extent: rect)), forKey: "inputBottomRight")
        perspectiveCorrection.setValue(docImage, forKey: kCIInputImageKey)
        
        return perspectiveCorrection.outputImage!
    }
    
    func cartesianForPoint(point:CGPoint,extent:CGRect) -> CGPoint {
        return CGPoint(x: point.x,y: extent.height - point.y)
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
