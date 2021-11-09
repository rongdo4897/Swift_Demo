//
//  Action.swift
//  Custom_Alert
//
//  Created by Hoang Tung Lam on 11/17/20.
//

import Foundation
import UIKit

enum ActionStyle {
    case normal
    case destructive
    case destructiveDark
    case normalDark
    
    // handle the thems
    var titleColor: UIColor {
        switch self {
        case .destructive, .destructiveDark, .normalDark:
            return UIColor.white
        case .normal:
            return UIColor.black
        }
    }
    
    // background color of actionbutton
    var backgroundColor: UIColor {
        switch self {
        case .normal:
            return UIColor.darkGray.withAlphaComponent(0.5)
        case .destructive , .destructiveDark:
            return UIColor.red
        case .normalDark:
            return UIColor.lightGray
        }
    }
    
    var highlightTitleColor: UIColor {
        switch self {
        case .normal , .normalDark, .destructive, .destructiveDark:
            return self.titleColor.withAlphaComponent(0.6)
        }
    }
}

// A custom version of UIAlertAction
class Action {
    var title: String
    var style: ActionStyle
    var actionHandler: () -> Void
    
    init(with title: String, style: ActionStyle = .normal, actionHandler: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.actionHandler = actionHandler
    }
}
