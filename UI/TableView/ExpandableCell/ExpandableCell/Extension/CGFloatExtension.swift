//
//  CGFloatExtension.swift
//  ExpandableCell
//
//  Created by Hoang Tung Lam on 1/19/21.
//

import Foundation
import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
