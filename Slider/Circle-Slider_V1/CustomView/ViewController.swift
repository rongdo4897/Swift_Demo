//
//  ViewController.swift
//  CustomView
//
//  Created by V002861 on 7/7/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var sliderValue: UISlider!
    @IBOutlet weak var switchAnimated: UISwitch!
    @IBOutlet weak var knobView: KnobView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        knobView.lineWidth = 4
        knobView.pointerLength = 12
    }
    
    func updateLabel() {
        lblValue.text = String(format: "%.2f", knobView.value)
    }
    
    @IBAction func knowViewValueChange(_ sender: Any) {
        updateLabel()
    }
    
    @IBAction func sliderValueValueChange(_ sender: Any) {
        knobView.setValue(sliderValue.value)
        updateLabel()
    }
    
    @IBAction func switchAnimatedValueChange(_ sender: Any) {
        
    }
    
    @IBAction func btnRandomValueTapped(_ sender: Any) {
        let randomValue = Float(arc4random_uniform(101)) / 100.0
        knobView.setValue(randomValue, animated: switchAnimated.isOn)
        sliderValue.setValue(Float(randomValue), animated: switchAnimated.isOn)
    }
}

