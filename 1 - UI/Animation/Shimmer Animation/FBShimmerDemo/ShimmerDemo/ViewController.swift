//
//  ViewController.swift
//  ShimmerDemo
//
//  Created by Brian Voong on 6/12/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let shimmerTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Shimmer"
        label.font = UIFont.systemFont(ofSize: 88, weight: .regular)
        label.textColor = UIColor(white: 1, alpha: 0.9)
        label.textAlignment = .center
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Shimmer"
        label.font = UIFont.systemFont(ofSize: 88, weight: .regular)
        label.textColor = UIColor(white: 1, alpha: 0.1)
        label.textAlignment = .center
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupShimmeringImage()
//        setupShimmeringText()
    }
    
    fileprivate func setupShimmeringImage() {
        let bgImageView = UIImageView(image: #imageLiteral(resourceName: "fb_bg2"))
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.frame = view.frame
        
        let shimmerImageView = UIImageView(image: #imageLiteral(resourceName: "fb_shimmer"))
        shimmerImageView.contentMode = .scaleAspectFill
        shimmerImageView.frame = view.frame
        
        view.addSubview(shimmerImageView)
        view.addSubview(bgImageView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor, UIColor.clear.cgColor,
            UIColor.black.cgColor, UIColor.black.cgColor,
            UIColor.clear.cgColor, UIColor.clear.cgColor
        ]

        gradientLayer.locations = [0, 0.2, 0.4, 0.6, 0.8, 1]
        
        let angle = -60 * CGFloat.pi / 180
        let rotationTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        gradientLayer.transform = rotationTransform
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.frame
        
        bgImageView.layer.mask = gradientLayer
        
        gradientLayer.transform = CATransform3DConcat(gradientLayer.transform, CATransform3DMakeScale(3, 3, 0))
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.repeatCount = Float.infinity
        animation.autoreverses = false
        animation.fromValue = -3.0 * view.frame.width
        animation.toValue = 3.0 * view.frame.width
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        gradientLayer.add(animation, forKey: "shimmerKey")
    }
    
    fileprivate func setupShimmeringText() {
        view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        view.addSubview(textLabel)
        view.addSubview(shimmerTextLabel)
        textLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        shimmerTextLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        
        let gradient = CAGradientLayer()
        
        gradient.frame = textLabel.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
        let angle = -60 * CGFloat.pi / 180
        gradient.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        shimmerTextLabel.layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.repeatCount = Float.infinity
        animation.autoreverses = false
        animation.fromValue = -view.frame.width
        animation.toValue = view.frame.width
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        gradient.add(animation, forKey: "shimmerKey")
    }

}

