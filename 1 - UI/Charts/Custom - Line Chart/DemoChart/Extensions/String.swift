//
//  String.swift
//  DemoChart
//
//  Created by Hoang Lam on 03/06/2022.
//

import Foundation
import UIKit

extension String {
    /// Lấy `size` của String dựa trên `font size`
    func size(withSystemFontSize pointSize: CGFloat) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: pointSize)])
    }
}
