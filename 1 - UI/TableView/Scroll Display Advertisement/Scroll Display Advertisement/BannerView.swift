//
//  BannerView.swift
//  Scroll Display Advertisement
//
//  Created by Lam Hoang Tung on 9/19/23.
//

import UIKit

class BannerView: UIControl {
    let imageView = UIImageView()
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.black.withAlphaComponent(0.25) : .clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.image = UIImage(named: "banner")
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = bounds
        imageView.isUserInteractionEnabled = false
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
