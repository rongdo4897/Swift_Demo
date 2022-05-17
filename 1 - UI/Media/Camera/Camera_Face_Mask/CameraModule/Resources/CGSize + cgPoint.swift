//
//  CGSize + cgPoint.swift
//  CameraModule
//
//  Created by Hoang Lam on 26/04/2022.
//

import Foundation
import UIKit

extension CGSize {
    var cgPoint: CGPoint {
        return CGPoint(x: width, y: height)
    }
}
