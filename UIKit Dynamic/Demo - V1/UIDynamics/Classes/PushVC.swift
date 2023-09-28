//
//  PushVC.swift
//  UIDynamics
//
//  Created by Yudiz Solutions on 06/08/18.
//  Copyright © 2018 Yudiz Solutions. All rights reserved.
//

import UIKit

class PushVC: UIViewController {

    /// IBOutlets
    @IBOutlet weak var squareView: UIView!
    @IBOutlet weak var switchPush: UISwitch!
    
    /// Variables
    var originalRect: CGRect!
    
    // UIDynamicAnimator: Cốt lõi
    var dynamicAnimator: UIDynamicAnimator!
    // UIGravityBehavior: Trọng lực
    var gravityBehavior: UIGravityBehavior!
    // UICollisionBehavior: Va đập
    var collisionBehavior: UICollisionBehavior!
    // UIPushBehavior: Đẩy
    var pushBehavior: UIPushBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

}


// MARK: - Functions
extension PushVC {
    
    func prepareUI() {
        originalRect = squareView.frame
        squareView.frame = originalRect
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        switchPush.isOn = false
    }
    
    
    // MARK:- Behavior Setter Methods
    func addGravity() {
        gravityBehavior  = UIGravityBehavior(items: [squareView])
        collisionBehavior = UICollisionBehavior(items: [squareView])                                        // Collision with Floor
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(gravityBehavior)
        dynamicAnimator.addBehavior(collisionBehavior)
    }
    
    func addPushBehavior() {
        dynamicAnimator.removeAllBehaviors()
        pushBehavior = UIPushBehavior(items: [squareView], mode: .continuous)
        // Độ lớn của vectơ lực đối với hành trình đẩy.
        pushBehavior.magnitude = 0.1
        // Đẩy lên
        pushBehavior.pushDirection = CGVector(dx: 0, dy: -1)
        // Đặt độ lệch từ tâm của một mục động để áp dụng vectơ lực của hành vi đẩy.
        pushBehavior.setTargetOffsetFromCenter(UIOffset(horizontal: -10, vertical: 0), for: squareView)     // Sẽ quay theo chiều kim đồng hồ nguyên nhân bù đắp
//        pushBehavior.pushDirection = CGVector(dx: 1, dy: 0)
//        pushBehavior.setTargetOffsetFromCenter(UIOffset(horizontal: 0, vertical: 10), for: squareView)
        
        collisionBehavior = UICollisionBehavior(items: [squareView])
        // Thêm ranh giới va chạm, được chỉ định dưới dạng đoạn thẳng, vào hành vi va chạm.
        collisionBehavior.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: CGPoint(x: 0, y: 64), to: CGPoint(x: self.view.frame.size.width, y: 64))

//        collisionBehavior.translatesReferenceBoundsIntoBoundary = true // Nó sẽ coi màn hình là ranh giới
        dynamicAnimator.addBehavior(pushBehavior)
        dynamicAnimator.addBehavior(collisionBehavior)
    }
}


// MARK: - Actions
extension PushVC {
    
    // To pop a view controller
    @IBAction func popViewController(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Button Actions
    @IBAction func swtichPushTapped(_ sender: UISwitch) {
        if (sender.isOn) {
            addPushBehavior()
        } else {
            addGravity()
        }
    }
}
