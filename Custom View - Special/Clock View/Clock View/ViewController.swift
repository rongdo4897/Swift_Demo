//
//  ViewController.swift
//  Clock View
//
//  Created by V002861 on 11/24/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var clockView: ClocketView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        clockView.displayRealTime = true
        clockView.startClock()
    }


}

