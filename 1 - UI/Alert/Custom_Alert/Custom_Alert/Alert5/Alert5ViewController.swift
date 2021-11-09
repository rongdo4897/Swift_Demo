//
//  Alert5ViewController.swift
//  Custom_Alert
//
//  Created by Hoang Tung Lam on 11/17/20.
//

import UIKit

class Alert5ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnShowAlert1Tapped(_ sender: Any) {
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Title",
                                      message: "Hello world",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "",
                                      style: <#T##UIAlertAction.Style#>,
                                      handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>))
    }
    
    func showActionSheet() {
        
    }
}
