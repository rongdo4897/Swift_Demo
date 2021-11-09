//
//  ActionButton.swift
//  Custom_Alert
//
//  Created by Hoang Tung Lam on 11/17/20.
//

import Foundation
import UIKit

class ActionButton: UIButton {
    private var actionHanler: (() -> Void)!
    
    init(withAction action: Action) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.actionHanler = action.actionHandler
        self.setUpButtonWith(action: action)
    }
    
    private func setUpButtonWith(action: Action) {
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.setTitle(action.title, for: .normal)
        self.layer.cornerRadius = 5
        addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        self.setUpUIForStyle(style: action.style)
    }
    
    private func setUpUIForStyle(style: ActionStyle) {
        self.backgroundColor = style.backgroundColor
        self.setTitleColor(style.titleColor, for: .normal)
        self.setTitleColor(style.highlightTitleColor, for: .highlighted)
    }
    
    @objc func didTapButton() {
        self.actionHanler?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
