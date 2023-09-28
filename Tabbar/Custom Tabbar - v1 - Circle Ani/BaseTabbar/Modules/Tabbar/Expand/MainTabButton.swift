//
//  MainTabButton.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/12/21.
//

import UIKit

class MainTabButton: UIButton {
    var selectedColor: UIColor! = .systemPink {
        didSet {
            reloadApperance()
        }
    }
    
    var unselectedColor: UIColor! = UIColor.colorFromHexString(hex: "8E9396") {
        didSet {
            reloadApperance()
        }
    }
    
    init(forItem item: UITabBarItem) {
        super.init(frame: .zero)
        let tintedImage = item.image?.withRenderingMode(.alwaysTemplate)
        setImage(tintedImage, for: .normal)
        setTitle(item.title, for: .normal)
    }
    
    init(image: UIImage, title: String){
        super.init(frame: .zero)
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        setImage(tintedImage, for: .normal)
        setTitle(title, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override public var isSelected: Bool {
        didSet {
            reloadApperance()
        }
    }
    
    func reloadApperance(){
        self.tintColor = isSelected ? selectedColor : unselectedColor
    }
}
