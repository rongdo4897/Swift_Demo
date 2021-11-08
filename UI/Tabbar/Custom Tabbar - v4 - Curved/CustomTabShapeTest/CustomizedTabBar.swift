//
//  CurvedBottomNavigationView.swift
//  CustomTabShapeTest
//
//  Created by Philipp Weiß on 16.11.18.
//  Copyright © 2018 pmw. All rights reserved.
//

import UIKit

@IBDesignable
class CustomizedTabBar: UITabBar {

	private var shapeLayer: CALayer?

	private func addShape() {
		let shapeLayer = CAShapeLayer()
        // sử dụng để thay đổi trạng thái (màu sắc) cho hình vừa tạo
		shapeLayer.path = createPath()
		shapeLayer.strokeColor = UIColor.lightGray.cgColor
		shapeLayer.fillColor = UIColor.white.cgColor
		shapeLayer.lineWidth = 1.0

		if let oldShapeLayer = self.shapeLayer {
			self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
		} else {
			self.layer.insertSublayer(shapeLayer, at: 0)
		}

		self.shapeLayer = shapeLayer
	}

	override func draw(_ rect: CGRect) {
		self.addShape()
	}

	func createPath() -> CGPath {
        // Độ sâu của phần lõm xuống
		let height: CGFloat = 40
        
		let path = UIBezierPath()
        // điểm lõm xuống (trung tâm màn hình)
		let centerWidth = self.frame.width / 2

		path.move(to: CGPoint(x: 0, y: 0)) // bắt đầu từ bị trí trái trên (0 ,0)
		path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // di chuyển đến vị trí bắt đầu cong

		// first curve down
		path.addCurve(to: CGPoint(x: centerWidth, y: height), // bẻ cong phía bên trái
					  controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
		// second curve up
		path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0), // bẻ cong phía bên phải
					  controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))

		// complete the rect
		path.addLine(to: CGPoint(x: self.frame.width, y: 0)) // nối tiếp đến vị trí phải trên
		path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height)) // nối đến vị trí phải dưới
		path.addLine(to: CGPoint(x: 0, y: self.frame.height)) // nối đến vị trí trái dưới
		path.close()

		return path.cgPath
	}

	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		let buttonRadius: CGFloat = 35
		return abs(self.center.x - point.x) > buttonRadius || abs(point.y) > buttonRadius
	}
}
