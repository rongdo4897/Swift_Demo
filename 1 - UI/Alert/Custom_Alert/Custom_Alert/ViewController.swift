//
//  ViewController.swift
//  Custom_Alert
//
//  Created by Hoang Tung Lam on 11/12/20.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func click(_ sender: Any) {
        
        let n = 6
        var stringNum = ""
        
        for i in 0..<n {
            for j in 0..<n{
                if j < n-i-1 {
                    stringNum += " "
                } else {
                    stringNum += "#"
                }
            }
            print(stringNum)
            stringNum = ""
            
        }
        
    }
}

