//
//  Double + Coordinate.swift
//  SmartTA
//
//  Created by Hoang Lam on 06/05/2022.
//  Copyright © 2022 vti. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func formatCoordinate() -> String {
        return String(format: "%.5f", self)
    }
}
