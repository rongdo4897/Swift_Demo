//
//  CGPoint.swift
//  DemoChart
//
//  Created by Hoang Lam on 03/06/2022.
//

import Foundation
import UIKit

extension CGPoint {
    /// Trả về tọa độ mới dựa trên `x` được thêm vào
    func adding(x: CGFloat) -> CGPoint { return CGPoint(x: self.x + x, y: self.y) }
    /// Trả về tọa độ mới dựa trên `y` được thêm vào
    func adding(y: CGFloat) -> CGPoint { return CGPoint(x: self.x, y: self.y + y) }
}
