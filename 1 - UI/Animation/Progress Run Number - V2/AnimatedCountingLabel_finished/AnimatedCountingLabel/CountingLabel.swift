//
//  CountingLabel.swift
//  AnimatedCountingLabel
//
//  Created by Brian Voong on 6/18/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class CountingLabel: UILabel {
    
    var customFormatter: ((String) -> (NSAttributedString))?
    
    fileprivate var startDate: Date!
    fileprivate let duration: Double
    fileprivate let startValue: Double
    fileprivate let endValue: Double
    fileprivate var lastUpdated: Date?
    
    fileprivate var displayLink: CADisplayLink?
    
    init(startValue: Double, endValue: Double, duration: Double) {
        self.startValue = startValue
        self.endValue = endValue
        self.duration = duration
        super.init(frame: .zero)
        
    }
    
    func beginCounting() {
        startDate = Date()
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink?.add(to: .main, forMode: .defaultRunLoopMode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleUpdate() {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.numberStyle = .decimal
        
        let textValue: Double
        
        if startDate == nil {
            startDate = Date()
            textValue = startValue
        } else {
            let now = Date()
            let totalDiff = now.timeIntervalSince(startDate)
            if totalDiff > duration {
                textValue = endValue
                displayLink?.invalidate()
                displayLink = nil
            } else {
                let percentage = totalDiff / duration
                textValue = Double(startValue) + percentage * Double(endValue - startValue)
            }
        }
        
        guard let finalValue = numberFormatter.string(from: NSNumber(value: textValue)) else { return }
        if customFormatter != nil {
            self.attributedText = customFormatter?(finalValue)
        } else {
            self.text = finalValue
        }
    }
    
}
