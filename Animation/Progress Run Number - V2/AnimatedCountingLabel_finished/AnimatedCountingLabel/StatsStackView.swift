//
//  StatsStackView.swift
//  AnimatedCountingLabel
//
//  Created by Brian Voong on 6/20/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class StatsStackView: UIStackView {
    let stepsGroup = GroupedStatsStackView(startValue: 0, endValue: 12538, duration: 2, title: "Steps", image: #imageLiteral(resourceName: "keep_trying"))
    
    let caloriesGroup = GroupedStatsStackView(startValue: 0, endValue: 1684, duration: 2, title: "Calories", image: #imageLiteral(resourceName: "eat_healthy"))
    
    let rankGroup = GroupedStatsStackView(startValue: 0, endValue: 93, duration: 2, title: "Ranking", image: #imageLiteral(resourceName: "ironman"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let containers = [stepsGroup, caloriesGroup, rankGroup].map { (group) -> UIView in
            let containerView = UIView()
            containerView.backgroundColor = .white
            containerView.addSubview(group)
            containerView.layer.cornerRadius = 5
            group.fillSuperview()
            return containerView
        }
        
        containers.forEach({addArrangedSubview($0)})
        
        distribution = .fillEqually
        axis = .vertical
        spacing = 32
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 32, left: 32, bottom: 32, right: 32)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
        [stepsGroup, caloriesGroup, rankGroup].forEach({
            $0.subviews.forEach({
                if let countingLabel = $0 as? CountingLabel {
                    countingLabel.beginCounting()
                }
            })
        })
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
