//
//  HorizontalProgressViewSectionItem.swift
//  DemoChart
//
//  Created by Hoang Lam on 27/05/2022.
//

import Foundation
import UIKit

protocol HorizontalProgressViewSectionItemDelegate: AnyObject {
    func didTapSection(_ section: HorizontalProgressViewSectionItem)
}

open class HorizontalProgressViewSectionItem: UIView {
    private let rightBorder: UIView = {
        let border = UIView()
        border.backgroundColor = .white
        return border
    }()
    
    weak var delegate: HorizontalProgressViewSectionItemDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initComponents()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initComponents()
    }
}

//MARK: - Init
extension HorizontalProgressViewSectionItem {
    private func initComponents() {
        initViews()
    }
    
    private func initViews() {
        // content view
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapViews)))
        
        // rightBorder view
        updateBorderWidth(with: 0)
    }
}

//MARK: - Objc
extension HorizontalProgressViewSectionItem {
    @objc private func tapViews() {
        delegate?.didTapSection(self)
    }
}

//MARK: - Action
extension HorizontalProgressViewSectionItem {
    func updateBorderWidth(with width: CGFloat = 0) {
        self.addSubview(rightBorder)
        rightBorder.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, width: width)
    }
    
    func updateBackgroundColor(with color: UIColor = .white) {
        self.backgroundColor = color
    }
}
