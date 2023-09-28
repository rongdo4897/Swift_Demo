//
//  KnobView + Layer.swift
//  CustomView
//
//  Created by V002861 on 7/12/22.
//

import UIKit

//MARK: - KnobRenderer (Layer Class)
extension KnobView {
    class KnobRenderer {
        // Màu layer
        var color: UIColor = .blue {
            didSet {
                trackLayer.strokeColor = color.cgColor
                pointerLayer.strokeColor = color.cgColor
            }
        }
        
        // Độ rộng layer
        var lineWidth: CGFloat = 2 {
            didSet {
                trackLayer.lineWidth = lineWidth
                pointerLayer.lineWidth = lineWidth
                updateTrackLayerPath()
                updatePointerLayerPath()
            }
        }
        
        // Góc bắt đầu
        var startAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8 {
            didSet {
                updateTrackLayerPath()
            }
        }
        
        // Góc kết thúc
        var endAngle: CGFloat = CGFloat(Double.pi) * 3 / 8 {
            didSet {
                updateTrackLayerPath()
            }
        }
        
        // Chiều cao của điểm hiện tại
        var pointerLength: CGFloat = 6 {
            didSet {
                updateTrackLayerPath()
                updatePointerLayerPath()
            }
        }
        
        // Điểm bắt đầu kéo
        private (set) var pointerAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8
        
        // Set lại vị trí điểm hiện tại
        func setPointerAngle(_ newPointerAngle: CGFloat, animated: Bool = false) {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            pointerLayer.transform = CATransform3DMakeRotation(newPointerAngle, 0, 0, 1)
            
            if animated {
                let midAngleValue = (max(newPointerAngle, pointerAngle) - min(newPointerAngle, pointerAngle)) / 2 + min(newPointerAngle, pointerAngle)
                let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
                animation.values = [pointerAngle, midAngleValue, newPointerAngle]
                animation.keyTimes = [0.0, 0.5, 1.0]
                animation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)]
                pointerLayer.add(animation, forKey: nil)
            }
            
            CATransaction.commit()
            
            pointerAngle = newPointerAngle
        }
        
        let trackLayer = CAShapeLayer()
        let pointerLayer = CAShapeLayer()
        
        init() {
            trackLayer.fillColor = UIColor.clear.cgColor
            pointerLayer.fillColor = UIColor.clear.cgColor
        }
        
        private func updateTrackLayerPath() {
            let bounds = trackLayer.bounds
            // midX, midY Trả về tọa độ x, y thiết lập tâm của hình chữ nhật.
            let center = CGPoint(x: bounds.midX, y: bounds.midY)
            let offset = max(pointerLength, lineWidth / 2)
            let radius = min(bounds.width, bounds.height) / 2 - offset
            
            // Vẽ layer chính
            let ring = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            trackLayer.path = ring.cgPath
        }
        
        private func updatePointerLayerPath() {
            let bounds = trackLayer.bounds
            
            // Vẽ layer điểm
            let pointer = UIBezierPath()
            pointer.move(to: CGPoint(x: bounds.width - CGFloat(pointerLength) - CGFloat(lineWidth) / 2, y: bounds.midY))
            pointer.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
            pointerLayer.path = pointer.cgPath
        }
        
        /// - Cập nhật lại kích thước layer với giới hạn được truyền từ ngoài vào
        func updateBounds(_ bounds: CGRect) {
            trackLayer.bounds = bounds
            trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
            updateTrackLayerPath()
            
            pointerLayer.bounds = trackLayer.bounds
            pointerLayer.position = trackLayer.position
            updatePointerLayerPath()
        }
    }

}
