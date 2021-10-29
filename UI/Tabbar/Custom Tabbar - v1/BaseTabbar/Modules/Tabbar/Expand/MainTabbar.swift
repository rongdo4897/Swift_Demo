//
//  MainTabbar.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/12/21.
//

import UIKit

protocol MainTabbarDelegate: class {
    func mainTabBar(_ sender: MainTabbar, didSelectItemAt index: Int)
}

class MainTabbar: UIView {

    weak var delegate: MainTabbarDelegate?
    
    var items: [UITabBarItem] = [] {
        didSet {
            reloadViews()
        }
    }
    
    override open func tintColorDidChange() {
        super.tintColorDidChange()
        reloadApperance()
    }
    
    func reloadApperance(){
        buttons().forEach { button in
            button.selectedColor = .white
        }
        
        indicatorView.tintColor = UIColor.colorFromHexString(hex: "4C9474")
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    
    lazy var indicatorView: MainTabIndicatorView = {
        let view = MainTabIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constraint(width: (Defined.tabbarWidth - Defined.horizontleSpacing * 2) / CGFloat(Defined.numberOfItem))
        view.constraint(height: Defined.tabBarHeight)
        view.backgroundColor = .white

        return view
    }()
    
    private var indicatorViewYConstraint: NSLayoutConstraint!
    private var indicatorViewXConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        stackView.arrangedSubviews.forEach {
            if let button = $0 as? UIControl {
                button.removeTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            }
        }
    }
    
    private func setup(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.addSubview(indicatorView)
        
        self.backgroundColor = UIColor.colorFromHexString(hex: "D2DFD2")
        
        self.addShadow(radius: 6)
        
        indicatorViewYConstraint?.isActive = false
        indicatorViewYConstraint = indicatorView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0)
        indicatorViewYConstraint.isActive = true
        
        tintColorDidChange()
    }
    
    func add(item: UITabBarItem){
        self.items.append(item)
        self.addButton(with: item.image!, title: item.title!)
    }
    
    func remove(item: UITabBarItem){
        if let index = self.items.firstIndex(of: item) {
            self.items.remove(at: index)
            let view = self.stackView.arrangedSubviews[index]
            self.stackView.removeArrangedSubview(view)
        }
    }
    
    private func addButton(with image: UIImage, title: String){
        let button = MainTabButton(image: image, title: title)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.selectedColor = .white
//        button.titleLabel?.font = Defined.fontWithSize(name: Constants.ralewaySemiBold, size: 12)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button.centerVertically()
        self.stackView.addArrangedSubview(button)
    }
    
    func select(at index: Int, notifyDelegate: Bool = true){
        for (bIndex, view) in stackView.arrangedSubviews.enumerated() {
            if let button = view as? UIButton {
                button.tintColor =  bIndex == index ? .white : UIColor.colorFromHexString(hex: "8E9396")
                button.setTitleColor(bIndex == index ? .white : UIColor.colorFromHexString(hex: "8E9396"), for: .normal)
            }
        }
        
        if notifyDelegate {
            self.delegate?.mainTabBar(self, didSelectItemAt: index)
        }
    }
    
    
    func reloadViews(){
        indicatorViewYConstraint?.isActive = false
        indicatorViewYConstraint = indicatorView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0)
        indicatorViewYConstraint.isActive = true
    
        for button in (stackView.arrangedSubviews.compactMap { $0 as? MainTabButton }) {
            stackView.removeArrangedSubview(button)
            button.removeFromSuperview()
            button.removeTarget(self, action: nil, for: .touchUpInside)
        }
        
        for item in items {
            if let image = item.image, let title = item.title {
                addButton(with: image, title: title)
            } else {
                addButton(with: UIImage(), title: "")
            }
        }
        
        select(at: 0)
    }
    
    
    
    private func buttons() -> [MainTabButton] {
        return stackView.arrangedSubviews.compactMap { $0 as? MainTabButton }
    }
    
    func select(at index: Int){
        /* move the indicator view */
        if indicatorViewXConstraint != nil {
            indicatorViewXConstraint.isActive = false
            indicatorViewXConstraint = nil
        }
        
        for (bIndex, button) in buttons().enumerated() {
            button.selectedColor = tintColor
            button.isSelected = bIndex == index
            
            if bIndex == index {
                indicatorViewXConstraint = indicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
                indicatorViewXConstraint.isActive = true
            }
        }
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
        
        
        self.delegate?.mainTabBar(self, didSelectItemAt: index)
    }
    
    
    @objc func buttonTapped(sender: MainTabButton){
        if let index = stackView.arrangedSubviews.firstIndex(of: sender){
            select(at: index)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let position = touches.first?.location(in: self) else {
            super.touchesEnded(touches, with: event)
            return
        }
        
        let buttons = self.stackView.arrangedSubviews.compactMap { $0 as? MainTabButton }.filter { !$0.isHidden }
        let distances = buttons.map { $0.center.distance(to: position) }
        
        let buttonsDistances = zip(buttons, distances)
        
        if let closestButton = buttonsDistances.min(by: { $0.1 < $1.1 }) {
            buttonTapped(sender: closestButton.0)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
        layer.cornerRadius = bounds.height / 2
    }
}
