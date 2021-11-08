//
//  TabbarViewController.swift
//  LimberTabbar
//
//  Created by Hoang Lam on 25/10/2021.
//

import UIKit

class TabbarViewController: MainTabViewController {
    override func viewDidLoad() {
        createTabbar()
        super.viewDidLoad()
    }
    
    func createTabbar() {
        let home = RouterType.home.getVc()
        let plan = RouterType.plan.getVc()
        let profile = RouterType.profile.getVc()
        
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.isNavigationBarHidden = true
        let planNav = UINavigationController(rootViewController: plan)
        planNav.isNavigationBarHidden = true
        let profileNav = UINavigationController(rootViewController: profile)
        profileNav.isNavigationBarHidden = true

        let homeItem = UITabBarItem(title: Constants.home, image: #imageLiteral(resourceName: "ic_home"), tag: 0)
        let planItem = UITabBarItem(title: Constants.plan, image: #imageLiteral(resourceName: "ic_plan"), tag: 1)
        let profileItem = UITabBarItem(title: Constants.profile, image: #imageLiteral(resourceName: "ic_profile"), tag: 2)

        homeNav.tabBarItem = homeItem
        planNav.tabBarItem = planItem
        profileNav.tabBarItem = profileItem
        
        self.viewControllers = [homeNav, planNav, profileNav]
    }
}
