//
//  AppDelegate.swift
//  Time Picker
//
//  Created by Lam Hoang Tung on 10/13/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let nav = UINavigationController(rootViewController: ExampleViewController())
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
        return true
    }
}

