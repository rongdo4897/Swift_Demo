//
//  AppDelegate.swift
//  TableView_StretchyHeaderEffect
//
//  Created by Hoang Tung Lam on 12/1/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIStoryboard(name: "Stretchy3", bundle: nil).instantiateViewController(withIdentifier: "Stretchy3ViewController") as! Stretchy3ViewController
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }

}
