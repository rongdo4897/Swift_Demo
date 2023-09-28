//
//  Alert4ViewController.swift
//  Custom_Alert
//
//  Created by Hoang Tung Lam on 11/16/20.
//

import UIKit

class Alert4ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnOpenPopUpTapped(_ sender: Any){
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "PopUpViewController") as! PopUpViewController
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

}
