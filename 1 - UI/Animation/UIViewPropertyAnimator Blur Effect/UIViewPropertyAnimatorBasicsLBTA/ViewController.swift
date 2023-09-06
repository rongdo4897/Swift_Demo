//
//  ViewController.swift
//  UIViewPropertyAnimatorBasicsLBTA
//
//  Created by Brian Voong on 10/25/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // instance property
    let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    let visualEffectView = UIVisualEffectView(effect: nil)
    
    // here's the new stuff of UIViewPropertyAnimator
    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCenteredImageView()
        
        // setup our visual blur effect view
        setupVisualBlurEffectView()
        
        setupSlider()
        
        animator.addAnimations {
            // completed animation state
            self.imageView.transform = CGAffineTransform(scaleX: 4, y: 4)
            self.visualEffectView.effect = UIBlurEffect(style: .regular)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    fileprivate func setupVisualBlurEffectView() {
//        let blurEffect = UIBlurEffect(style: .regular)
        view.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
    }
    
    fileprivate func setupSlider() {
        let slider = UISlider()
        view.addSubview(slider)
        slider.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
    }
    
    @objc fileprivate func handleSliderChange(slider: UISlider) {
        print(slider.value)
        animator.fractionComplete = CGFloat(slider.value)
    }
    
    @objc func handleTap() {
        // its hard to interpolate and specify values such as middle of animation at 0.5 or 0.25
        UIView.animate(withDuration: 1.0) {
            self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
    }
    
    fileprivate func setupCenteredImageView() {
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.centerInSuperview(size: .init(width: 200, height: 200))
    }

}

