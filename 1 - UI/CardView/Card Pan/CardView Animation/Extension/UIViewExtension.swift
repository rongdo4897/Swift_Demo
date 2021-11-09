//
//  UIViewExtensions.swift
//  Shimmer Animation
//
//  Created by Hoang Tung Lam on 2/18/21.
//

import Foundation
import UIKit

extension UIView {
    
    // ->1
    enum Direction: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
        case topLeftToBottomRight
        case topRightToBottomLeft
        case bottomLeftToTopRight
        case bottomRightToTopLeft
    }
    
    func startShimmeringAnimation(animationSpeed: Float = 1.4,
                                  direction: Direction = .leftToRight,
                                  repeatCount: Float = MAXFLOAT) {
        
        // Create color  ->2
        let lightColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
        let blackColor = UIColor.black.cgColor
        
        // Create a CAGradientLayer  ->3
        let gradientLayer = CAGradientLayer()
        // màu sắc gadient (trắng ở giữa)
        gradientLayer.colors = [blackColor, lightColor, blackColor]
        // kích thước gadient
        gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 4 * self.bounds.size.width, height: 4 * self.bounds.size.height)
        
        switch direction {
        case .topToBottom:
            // điểm sáng nhất tập trung tại x = 0.5 và di chuyển từ trên xuống dưới
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            // điểm sáng nhất tập trung tại x = 0.5 và di chuyển từ dưới lên trên
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            // điểm sáng nhất tập trung tại y = 0.5 và di chuyển từ trái sang phải
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            // điểm sáng nhất tập trung tại x = 0.5 và di chuyển từ phải sang trái
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            
        case .topLeftToBottomRight:
            // di chuyển từ (0.0,0.0) -> (1.0,1.0)
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            
        case .topRightToBottomLeft:
            // di chuyển từ (1.0,0.0) -> (0.0,1.0)
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            
        case .bottomLeftToTopRight:
            // di chuyển từ (0.0,1.0) -> (1.0,0.0)
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            
        case .bottomRightToTopLeft:
            // di chuyển từ (1.0,1.0) -> (0.0,0.0)
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        }
        
        // Một mảng tùy chọn của các đối tượng NSNumber xác định vị trí của mỗi điểm dừng gradient. animation
        gradientLayer.locations =  [0.35, 0.50, 0.65] //[0.4, 0.6]
        self.layer.mask = gradientLayer
        
        // Add animation over gradient Layer  ->4
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "locations")
        // Xác định giá trị mà máy thu sử dụng để bắt đầu nội suy.
        animation.fromValue = [0.0, 0.1, 0.2]
        // Xác định giá trị mà máy thu sử dụng để kết thúc nội suy.
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = CFTimeInterval(animationSpeed)
        animation.repeatCount = repeatCount
        CATransaction.setCompletionBlock { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.layer.mask = nil
        }
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        CATransaction.commit()
    }
    
    func stopShimmeringAnimation() {
        self.layer.mask = nil
    }
    
}
