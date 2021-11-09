//
//  Alert1ViewController.swift
//  Custom_Alert
//
//  Created by Hoang Tung Lam on 11/13/20.
//

import UIKit

class Alert1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSuccessTapped(_ sender: Any) {
        Alert1View.instance.showAlert(title: "Success", mesage: "Login succesfully into system", alertType: .success)
    }
    
    @IBAction func btnFailTapped(_ sender: Any) {
        Alert1View.instance.showAlert(title: "Failure", mesage: "Login fail into system", alertType: .failure)
    }
}
