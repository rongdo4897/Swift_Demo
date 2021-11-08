//
//  TabbarViewController.swift
//  LimberTabbar
//
//  Created by Hoang Lam on 25/10/2021.
//

import UIKit

//MARK: - Outlet, Override
class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
        self.delegate = self
    }
}

//MARK: - Các hàm khởi tạo, Setup
extension TabbarViewController {
    private func initComponents() {
        initMiddleButton()
    }
    
    private func initMiddleButton() {
        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - middleButtonRadius, y: -middleButtonRadius/2-5, width: middleButtonHeight, height: middleButtonHeight))
        middleBtn.setImage(#imageLiteral(resourceName: "ic_plan"), for: .normal)
        middleBtn.backgroundColor = UIColor.red
        middleBtn.layer.cornerRadius = middleButtonRadius
        middleBtn.layer.masksToBounds = true
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.middleButtonTapped), for: .touchUpInside)
        self.view.layoutIfNeeded()
    }
}

//MARK: - Customize
extension TabbarViewController {
    private func customizeComponents() {
        
    }
}

//MARK: - Action - Obj
extension TabbarViewController {
    @objc func middleButtonTapped(sender: UIButton) {
        let plan = RouterType.plan.getVc()
        self.navigationController?.pushViewController(plan, animated: true)
    }
}

//MARK: - Các hàm chức năng
extension TabbarViewController {
    class func createTabbar() -> TabbarViewController {
        let tabbar = UIStoryboard(name: Constants.tabbar, bundle: nil).instantiateViewController(ofType: TabbarViewController.self)
        
        let home = RouterType.home.getVc()
        let middle = UIViewController()
        let profile = RouterType.profile.getVc()
        
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.isNavigationBarHidden = true
        let profileNav = UINavigationController(rootViewController: profile)
        profileNav.isNavigationBarHidden = true

        let homeItem = UITabBarItem(title: Constants.home, image: #imageLiteral(resourceName: "ic_home"), tag: 0)
        let middleItem = UITabBarItem(title: nil, image: nil, tag: 1)
        let profileItem = UITabBarItem(title: Constants.profile, image: #imageLiteral(resourceName: "ic_profile"), tag: 2)

        homeNav.tabBarItem = homeItem
        middle.tabBarItem = middleItem
        profileNav.tabBarItem = profileItem
        
        tabbar.tabBar.isTranslucent = false
        tabbar.viewControllers = [homeNav, middle, profileNav]
        
        return tabbar
    }
}

extension TabbarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
