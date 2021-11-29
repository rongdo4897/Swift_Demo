//
//  AppDelegate.swift
//  BaseTableView
//
//  Created by Hoang Lam on 24/11/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let vc = RouterType.test.getVc()
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        
        window?.rootViewController = nav
        
        return true
    }
}

