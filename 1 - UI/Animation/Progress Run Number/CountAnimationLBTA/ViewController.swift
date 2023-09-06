//
//  ViewController.swift
//  CountAnimationLBTA
//
//  Created by Brian Voong on 6/19/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let countingLabel: UILabel = {
        let label = UILabel()
        label.text = "1234"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(countingLabel)
        countingLabel.frame = view.frame
        
        // create my CADisplayLink here
        displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink?.add(to: .main, forMode: .defaultRunLoopMode)
    }
    
    var displayLink: CADisplayLink?
    
    var startValue: Double = 900
    let endValue: Double = 1000
    let animationDuration: Double = 3.5
    
    let animationStartDate = Date()
    
    @objc func handleUpdate() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            self.countingLabel.text = "\(endValue)"
            displayLink?.invalidate()
            displayLink = nil
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            self.countingLabel.text = "\(value)"
        }
        
//        self.countingLabel.text = "\(startValue)"
//        startValue += 1
//
//        if startValue > endValue {
//            startValue = endValue
//        }
//        let seconds = Date().timeIntervalSince1970
//        print(seconds)
//        self.countingLabel.text = "\(seconds)"
    }

}














