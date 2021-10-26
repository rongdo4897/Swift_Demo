//
//  UIImageExtension.swift
//  Chrome_PullToRrefress
//
//  Created by Hoang Tung Lam on 4/12/21.
//

import Foundation
import UIKit

extension UIImage {
    func newColor(with color: UIColor) -> UIImage
    {
        UIGraphicsBeginImageContext(self.size)
         guard let context = UIGraphicsGetCurrentContext() else { return self }
            
        // flip the image
         context.scaleBy(x: 1.0, y: -1.0)
         context.translateBy(x: 0.0, y: -self.size.height)
            
        // multiply blend mode
         context.setBlendMode(.multiply)
                
         let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
         context.clip(to: rect, mask: self.cgImage!)
         color.setFill()
         context.fill(rect)
            
        // create UIImage
         guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
         UIGraphicsEndImageContext()
            
         return newImage
    }
}
