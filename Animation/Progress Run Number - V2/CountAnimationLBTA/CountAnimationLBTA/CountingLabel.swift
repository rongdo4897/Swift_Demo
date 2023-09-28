//
//  CountingLabel.swift
//  CountAnimationLBTA
//
//  Created by Brian Voong on 6/20/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class CountingLabel: UILabel {
    
    fileprivate let startValue: Double
    fileprivate let endValue: Double
    fileprivate let animationDuration: Double
    
    fileprivate let animationStartDate = Date()
    
    fileprivate var displayLink: CADisplayLink?
    
    init(startValue: Double, endValue: Double, animationDuration: Double) {
        self.startValue = startValue
        self.endValue = endValue
        self.animationDuration = animationDuration
        
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        
        self.text = "\(startValue)"
        self.textAlignment = .center
        self.font = UIFont.boldSystemFont(ofSize: 18)
        
        displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink?.add(to: .main, forMode: .defaultRunLoopMode)
    }
    
    @objc func handleUpdate() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            self.text = "\(endValue)"
            displayLink?.invalidate()
            displayLink = nil
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            self.text = "\(value)"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
