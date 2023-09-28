//
//  ViewController.swift
//  AnimatedCountingLabel
//
//  Created by Brian Voong on 6/18/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(r: 23, g: 43, b: 67)
        navigationController?.isNavigationBarHidden = true
        
        let stackView = StatsStackView(frame: view.frame)
        view.addSubview(stackView)
    }

}

