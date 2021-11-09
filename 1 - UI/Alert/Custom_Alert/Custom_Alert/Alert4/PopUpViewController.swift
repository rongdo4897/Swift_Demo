//
//  PopUpViewController.swift
//  Custom_Alert
//
//  Created by Hoang Tung Lam on 11/16/20.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.addAnimation()
    }
    
    @IBAction func btnClosePopUpTapped(_ sender: Any){
        self.removeAnimation()
    }
    
    func addAnimation() {
        self.viewMain.transform = CGAffineTransform(translationX: 0, y: self.viewMain.frame.height)
        UIView.animate(withDuration: 0.5) {
            self.viewMain.transform = .identity
        }
    }
    
    func removeAnimation() {
        self.viewMain.transform = .identity
        UIView.animate(withDuration: 0.5) {
            self.viewMain.transform = CGAffineTransform(translationX: 0, y: self.viewMain.frame.height)
        } completion: { (done) in
            if done {
                self.view.removeFromSuperview()
            }
        }
    }
}
