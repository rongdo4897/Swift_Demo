//
//  GravityVC.swift
//  UIDynamics
//
//  Created by Yudiz Solutions on 06/08/18.
//  Copyright © 2018 Yudiz Solutions. All rights reserved.
//

import UIKit

class GravityVC: UIViewController {
    
    /// IBOutlets
    @IBOutlet var squareView: UIView!
    @IBOutlet var switchGravity: UISwitch!
    @IBOutlet var switchBounce: UISwitch!
    
    /// Variables
    var originalRect: CGRect!
    
    // UIDynamicAnimator: Cốt lõi để thực thi nhiều dynamic
    var dynamicAnimator   : UIDynamicAnimator!
    // UIGravityBehavior: Rơi theo hướng trọng lực
    var gravityBehavior   : UIGravityBehavior!
    // UICollisionBehavior: Va đập
    var collisionBehavior : UICollisionBehavior!
    // UIDynamicItemBehavior: Tùy chỉnh
    var bouncingBehavior  : UIDynamicItemBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

}

// MARK:- Functions
extension GravityVC {
    
    func prepareUI() {
        originalRect = squareView.frame
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        switchGravity.isOn = false
        switchBounce.isOn = false
    }
    
    func addGravity() {
        gravityBehavior  = UIGravityBehavior(items: [squareView])
        dynamicAnimator.addBehavior(gravityBehavior)
        
        // hướng rơi
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 1)       // rơi xuống dưới
//        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: -1)    // rơi lên trên
//        gravityBehavior.gravityDirection = CGVector(dx: 1, dy: 0)     // rơi bên phải phải
//        gravityBehavior.gravityDirection = CGVector(dx: -1, dy: 0)    // rơi bên trái

//        gravityBehavior.angle = CGFloat(90 * (Double.pi/180)) // góc
//        gravityBehavior.magnitude = CGFloat(5)                // Lực hấp dẫn (tốc độ)
//        gravityBehavior.setAngle(CGFloat(180 * (Double.pi/180)), magnitude: 0.2)
    }
    
    func addBounce() {
        collisionBehavior = UICollisionBehavior(items: [squareView])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        // Một cách khác để thiết lập ranh giới, bạn phải thêm từng ranh giới một
//        collisionBehavior.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x: 0, y: self.view.frame.size.height), to: CGPoint(x: self.view.frame.size.width, y: self.view.frame.size.height))
        
        dynamicAnimator.addBehavior(collisionBehavior)
        
        bouncingBehavior = UIDynamicItemBehavior(items: [squareView])
        // Mức độ co giãn được áp dụng cho các va chạm đối với các mục động của hành vi.
        bouncingBehavior.elasticity = 0.70
        dynamicAnimator.addBehavior(bouncingBehavior)
    }
}


// MARK:- Actions
extension GravityVC {
    
    // To pop a view controller
    @IBAction func popViewController(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchGravityTapped(_ sender: UISwitch) {
        if (sender.isOn) {
            if switchBounce.isOn {
                addBounce()
            }else {
                dynamicAnimator.removeAllBehaviors()
            }
            addGravity()
        } else {
            squareView.frame = originalRect
            dynamicAnimator.removeAllBehaviors()
        }
    }
}
