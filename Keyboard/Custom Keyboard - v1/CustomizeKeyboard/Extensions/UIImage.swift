//
//  UIImage.swift
//  CustomizeKeyboard
//
//  Created by Hoang Lam on 15/12/2021.
//

import Foundation
import UIKit

extension UIImage {
    /// - Hình ảnh màu
    public static func image(color: UIColor) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
