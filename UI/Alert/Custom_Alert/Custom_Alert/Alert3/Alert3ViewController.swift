//
//  Alert3ViewController.swift
//  Custom_Alert
//
//  Created by Hoang Tung Lam on 11/16/20.
//

import UIKit

class Alert3ViewController: UIViewController {
    
    let customAlert = MyAlert()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnShowAlert1Tapped(sender: Any){
        customAlert.showAlert(with: "Hello world",
                              message: "This is my custom alert", on: self)
    }
    
    @objc func dismissAlert() {
        customAlert.dismissAlert()
    }
}

class MyAlert {
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    private var myTargetView: UIView?
    
    func showAlert(with title: String, message: String, on viewController: UIViewController) {
        guard let targetView = viewController.view else {
            return
        }
        
        myTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        alertView.frame = CGRect(x: 40,
                                 y: -300,
                                 width: targetView.bounds.width - 80,
                                 height: 300)
        
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0,
                                               y: 0,
                                               width: alertView.frame.width,
                                               height: 80))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        
        let messageLabel = UILabel(frame: CGRect(x: 0,
                                                 y: titleLabel.bounds.height,
                                                 width: alertView.frame.width,
                                                 height: 170))
        messageLabel.text = message
        messageLabel.textAlignment = .left
        messageLabel.numberOfLines = 0
        
        let button = UIButton(frame: CGRect(x: 20,
                                            y: 250,
                                            width: alertView.frame.width - 40,
                                            height: 50))
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        button.setTitleColor(.link, for: .normal)
        
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(button)
        
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        } completion: { (done) in
            if done {
                UIView.animate(withDuration: 0.25) {
                    self.alertView.center = targetView.center
                }
            }
        }

    }
    
    @objc func dismissAlert() {
        guard let targetView = myTargetView else {
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            self.alertView.frame = CGRect(x: 40,
                                          y: targetView.bounds.height,
                                          width: targetView.bounds.width - 80,
                                          height: 300)
        } completion: { (done) in
            if done {
                UIView.animate(withDuration: 0.25) {
                    self.backgroundView.alpha = 0
                } completion: { (done) in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                }
            }
        }
    }
}
