//
//  AppRouter.swift
//  IVM
//
//  Created by an.trantuan on 7/9/20.
//  Copyright © 2020 an.trantuan. All rights reserved.
//

import UIKit

enum RouterType {
    case test
}

class AppRouter {
    class func routerTo(from vc: UIViewController, router: RouterType) {
        DispatchQueue.main.async {
            vc.navigationController?.pushViewController(router.getVc(), animated: true)
        }
    }
}

extension RouterType {
    func getVc() -> UIViewController {
        switch self {
        case .test:
            let vc = UIStoryboard(name: Constants.table, bundle: nil).instantiateViewController(ofType: TestViewController.self)
            return vc
        }
    }
}
