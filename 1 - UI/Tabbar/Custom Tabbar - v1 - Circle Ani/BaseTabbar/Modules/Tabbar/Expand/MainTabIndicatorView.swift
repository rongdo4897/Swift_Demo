//
//  MainTabIndicatorView.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/12/21.
//

import UIKit

class MainTabIndicatorView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2

    }
    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.backgroundColor = tintColor
    }
}
