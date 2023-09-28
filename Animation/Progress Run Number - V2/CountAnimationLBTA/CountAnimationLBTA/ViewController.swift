//
//  ViewController.swift
//  CountAnimationLBTA
//
//  Created by Brian Voong on 6/19/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let stackView = StatsStackView()
        view.addSubview(stackView)
        stackView.frame = view.frame
    }

}














