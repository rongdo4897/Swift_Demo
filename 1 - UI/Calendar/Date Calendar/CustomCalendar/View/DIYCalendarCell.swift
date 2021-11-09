//
//  DIYCalendarCell.swift
//  CustomCalendar
//
//  Created by Hoang Tung Lam on 1/18/21.
//

import UIKit
import FSCalendar

enum SelectionType: Int {
    case none
    case single
    case leftBorder
    case rightBorder
    case middle
}

class DIYCalendarCell: FSCalendarCell {
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    
    fileprivate var lightBlue = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    fileprivate var darkBlue = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = darkBlue.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, at: 0)
        self.selectionLayer = selectionLayer
        self.shapeLayer.isHidden = true
        let view = UIView(frame: self.bounds)
        self.backgroundView = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.eventIndicator.isHidden = true
        self.backgroundView?.frame = self.bounds.insetBy(dx: 0, dy: 0)
        self.selectionLayer.frame = self.contentView.bounds
        self.selectionLayer.fillColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.selectionLayer.sublayers?.removeAll()
        
        if selectionType == .middle {
            self.selectionLayer.fillColor = lightBlue.cgColor
            self.titleLabel.textColor = darkBlue
            self.selectionLayer.path = UIBezierPath(rect: CGRect(origin: CGPoint(x: self.selectionLayer.bounds.minX, y: self.selectionLayer.bounds.minY + 6), size: CGSize(width: self.selectionLayer.frame.width, height: self.selectionLayer.frame.height - 12))).cgPath
        } else if selectionType == .rightBorder {
            let layer = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: self.selectionLayer.frame.maxY / 2))
            path.addLine(to: CGPoint(x: 10, y: 2))
            path.addLine(to: CGPoint(x: self.selectionLayer.frame.maxX - 10, y: 2))
            path.addLine(to: CGPoint(x: self.selectionLayer.frame.maxX - 10, y: self.selectionLayer.frame.maxY - 2))
            path.addLine(to: CGPoint(x: 10, y: self.selectionLayer.frame.maxY - 2))
            path.close()
            layer.path = path.cgPath
            layer.fillColor = darkBlue.cgColor
            layer.borderWidth = 1
            self.selectionLayer.insertSublayer(layer, at: 0)
            self.selectionLayer.fillColor = lightBlue.cgColor
            self.titleLabel.textColor = .white
            self.selectionLayer.lineCap = .round
            self.selectionLayer.lineWidth = 3
            self.selectionLayer.path = UIBezierPath(rect: CGRect(origin: CGPoint(x: self.selectionLayer.bounds.minX, y: self.selectionLayer.bounds.minY + 6), size: CGSize(width: self.selectionLayer.frame.width - 10, height: self.selectionLayer.frame.height - 12))).cgPath
        } else if selectionType == .leftBorder {
            let layer = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 10, y: 2))
            path.addLine(to: CGPoint(x: self.selectionLayer.frame.maxX - 10, y: 2))
            path.addLine(to: CGPoint(x: self.selectionLayer.frame.maxX, y: self.selectionLayer.frame.maxY / 2))
            path.addLine(to: CGPoint(x: self.selectionLayer.frame.maxX - 10, y: self.selectionLayer.frame.maxY - 2))
            path.addLine(to: CGPoint(x: 10, y: self.selectionLayer.frame.maxY - 2))
            path.close()
            layer.path = path.cgPath
            layer.fillColor = darkBlue.cgColor
            layer.borderWidth = 1
            self.selectionLayer.insertSublayer(layer, at: 0)
            self.selectionLayer.fillColor = lightBlue.cgColor
            self.titleLabel.textColor = .white
            self.selectionLayer.lineCap = .round
            self.selectionLayer.lineWidth = 3
            self.selectionLayer.path = UIBezierPath(rect: CGRect(origin: CGPoint(x: self.selectionLayer.bounds.minX + 10, y: self.selectionLayer.bounds.minY + 6), size: CGSize(width: self.selectionLayer.frame.width - 10, height: self.selectionLayer.frame.height - 12))).cgPath
        } else if selectionType == .single {
            self.selectionLayer.fillColor = darkBlue.cgColor
            self.titleLabel.textColor = lightBlue
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        } else {
            self.selectionLayer.fillColor = UIColor.white.cgColor
            self.titleLabel.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        self.eventIndicator.isHidden = true
    }
}
