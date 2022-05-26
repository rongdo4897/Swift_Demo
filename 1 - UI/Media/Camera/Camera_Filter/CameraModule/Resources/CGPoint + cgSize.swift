//
//  CGPoint + cgSize.swift
//  CameraModule
//
//  Created by Hoang Lam on 26/04/2022.
//

import Foundation
import UIKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (left: CGPoint, right: CGFloat) -> CGPoint {
  return CGPoint(x: left.x * right, y: left.y * right)
}

extension CGPoint {
    var cgSize: CGSize {
        return CGSize(width: x, height: y)
    }
    
    func absolutePoint(in rect: CGRect) -> CGPoint {
        return CGPoint(x: x * rect.size.width, y: y * rect.size.height) + rect.origin
    }
}

