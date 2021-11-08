//
//  AppRouter.swift
//  AddContact
//
//  Created by Huong Nguyen on 3/3/21.
//

import UIKit

enum RouterType {
    case tabbar
    case home
    case plan
    case profile
}

class AppRouter {
    class func routerTo(from vc: UIViewController, router: RouterType) {
        DispatchQueue.main.async {
            vc.navigationController?.pushViewController(router.getVc(), animated: true)
        }
    }
    
//    class func setRootView() {
//        if let window = UIApplication.shared.keyWindow {
//            window.rootViewController = nil
//            let navigationController = UINavigationController(rootViewController: RouterType.overview.getVc())
//            navigationController.isNavigationBarHidden = true
//            window.rootViewController = navigationController
//            let options: UIView.AnimationOptions = .transitionCrossDissolve
//            let duration: TimeInterval = 0.3
//            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: { _ in
//                                })
//            window.makeKeyAndVisible()
//        }
//    }
}

extension RouterType {
    func getVc() -> UIViewController {
        switch self {
        case .tabbar:
            let vc = TabbarViewController.createTabbar()
            return vc
        case .home:
            let vc = UIStoryboard(name: Constants.home, bundle: nil).instantiateViewController(ofType: HomeViewController.self)
            return vc
        case .plan:
            let vc = UIStoryboard(name: Constants.plan, bundle: nil).instantiateViewController(ofType: PlanViewController.self)
            return vc
        case .profile:
            let vc = UIStoryboard(name: Constants.profile, bundle: nil).instantiateViewController(ofType: ProfileViewController.self)
            return vc
        }
    }
}
