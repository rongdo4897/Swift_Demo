//
//  ViewController.swift
//  CustomView
//
//  Created by V002861 on 7/7/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var lblLower: UILabel!
    @IBOutlet weak var lblUpper: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblLower.text = "Lower: \(rangeSlider.lowerValue)"
        lblUpper.text = "Upper: \(rangeSlider.upperValue)"
    }

    @IBAction func rangeSliderValueChange(_ sender: RangeSlider) {
        lblLower.text = "Lower: \(sender.lowerValue)"
        lblUpper.text = "Upper: \(sender.upperValue)"
    }
}

