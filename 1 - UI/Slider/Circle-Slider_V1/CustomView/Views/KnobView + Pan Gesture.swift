//
//  KnobView + Pan Gesture.swift
//  CustomView
//
//  Created by V002861 on 7/13/22.
//

import UIKit

extension KnobView {
    class RotationKnobGestureRecognizer: UIPanGestureRecognizer {
        private (set) var touchAngle: CGFloat = 0
        
        override init(target: Any?, action: Selector?) {
            super.init(target: target, action: action)
            
            maximumNumberOfTouches = 1
            minimumNumberOfTouches = 1
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
            super.touchesBegan(touches, with: event)
            updateAngle(with: touches)
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
            super.touchesMoved(touches, with: event)
            updateAngle(with: touches)
        }
        
        private func updateAngle(with touches: Set<UITouch>) {
            // lấy điểm chạm đầu tiên
            guard let touch = touches.first, let view = view else {return}
            // lấy tọa độ tương ứng của điểm chạm đầu tiên với view cha
            let touchPoint = touch.location(in: view)
            // Thực hiện tính toán và trả về góc cần thiết
            touchAngle = angle(for: touchPoint, in: view)
        }
        
        // Tính toán tọa độ điểm chạm và view để cho ra góc xoay
        private func angle(for point: CGPoint, in view: UIView) -> CGFloat {
            let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
            // Trả về arctang của mỗi cặp phần tử tương ứng trong hai vectơ.
            return atan2(centerOffset.y, centerOffset.x)
        }
    }
}
