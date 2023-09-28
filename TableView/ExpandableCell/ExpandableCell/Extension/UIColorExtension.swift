//
//  UIColorExtension.swift
//  ExpandableCell
//
//  Created by Hoang Tung Lam on 1/19/21.
//

import Foundation
import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
