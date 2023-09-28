//
//  AppDelegate.swift
//  BaseTabbar
//
//  Created by Hoang Lam on 29/10/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let tabbar = RouterType.tabbar.getVc()
        let nav = UINavigationController(rootViewController: tabbar)
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
        
        return true
    }
}

