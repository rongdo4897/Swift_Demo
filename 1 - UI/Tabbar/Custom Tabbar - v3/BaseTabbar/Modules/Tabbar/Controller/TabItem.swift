//
//  TabItem.swift
//  CustomizedTabBar
//
//  Created by Thanh Nguyen Xuan on 08/12/2020.
//

import UIKit

enum TabItem: String, CaseIterable {
    case home = "home"
    case plan = "plan"
    case profile = "profile"

    var viewController: UIViewController {
        switch self {
        case .home:
            return RouterType.home.getVc()
        case .plan:
            return RouterType.plan.getVc()
        case .profile:
            return RouterType.profile.getVc()
        }
    }

    var icon: UIImage {
        switch self {
        case .home:
            return #imageLiteral(resourceName: "ic_home")
        case .plan:
            return #imageLiteral(resourceName: "ic_plan")
        case .profile:
            return #imageLiteral(resourceName: "ic_profile")
        }
    }

    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
