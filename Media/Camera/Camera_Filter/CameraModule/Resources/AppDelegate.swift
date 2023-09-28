//
//  AppDelegate.swift
//  CameraModule
//
//  Created by Hoang Lam on 26/04/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        guard let vc = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController else {return false}
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
        return true
    }
}

