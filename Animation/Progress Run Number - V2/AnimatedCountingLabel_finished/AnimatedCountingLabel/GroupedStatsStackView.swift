//
//  GroupedStatsStackView.swift
//  AnimatedCountingLabel
//
//  Created by Brian Voong on 6/20/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class GroupedStatsStackView: UIStackView {
    init(startValue: Double, endValue: Double, duration: Double, title: String, image: UIImage) {
        super.init(frame: .zero)
        
        let label = CountingLabel(startValue: startValue, endValue: endValue, duration: duration)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.numberOfLines = 3
        label.beginCounting()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .light)
        titleLabel.textAlignment = .center
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        [label, titleLabel, imageView].forEach({addArrangedSubview($0)})
        axis = .vertical
        spacing = 6
        layoutMargins = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        isLayoutMarginsRelativeArrangement = true
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
