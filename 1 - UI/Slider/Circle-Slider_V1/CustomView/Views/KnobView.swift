//
//  KnobView.swift
//  CustomView
//
//  Created by V002861 on 7/12/22.
//

import UIKit

class KnobView: UIControl {
    var minimumValue: Float = 0
    var maximumValue: Float = 1
    
    private (set) var value: Float = 0
    
    private let renderer = KnobRenderer()
    
    var lineWidth: CGFloat {
        get {return renderer.lineWidth}
        set {renderer.lineWidth = newValue}
    }
    
    var startAngle: CGFloat {
        get {return renderer.startAngle}
        set {renderer.startAngle = newValue}
    }
    
    var endAngle: CGFloat {
        get {return renderer.endAngle}
        set {renderer.endAngle = newValue}
    }
    
    var pointerLength: CGFloat {
        get {return renderer.pointerLength}
        set {renderer.pointerLength = newValue}
    }
    
    // Kiểm tra xem control có nên được gọi lại nhiều lần khi giá trị thay đổi, nếu set `false` thì nó được gọi lại 1 lần sau khi người dùng tương tác xong với nó
    var isContinuous = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initComponents()
    }
}

//MARK: - Init
extension KnobView {
    private func initComponents() {
        renderer.updateBounds(bounds)
        renderer.color = tintColor
        // cài đặt điểm bắt đầu
        renderer.setPointerAngle(renderer.startAngle, animated: false)
        
        layer.addSublayer(renderer.trackLayer)
        layer.addSublayer(renderer.pointerLayer)
        
        // cài đặt điểm chạm
        let gestureRecognizer = RotationKnobGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(gestureRecognizer)
    }
}

//MARK: - Customize
extension KnobView {
    private func customizeComponents() {
        
    }
}

//MARK: - Action - Obj
extension KnobView {
    @objc private func handleGesture(_ gesture: RotationKnobGestureRecognizer) {
        // Tính toán góc đại diện cho điểm giữa góc bắt đầu và góc kết thúc, nó đại diện cho góc mà con trỏ phải lật giữa các giá trị lớn nhất và nhỏ nhất
        let midPointAngle = (2 * CGFloat(Double.pi) + startAngle - endAngle) / 2 + endAngle
        // Góc được tính toán bởi trình nhận dạng cử chỉ sẽ nằm trong khoảng -π và π, Tuy nhiên, góc cần thiết cho đường chạy phải liên tục giữa startAngle và endAngle. Do đó, hãy tạo một biến `boundedAngle` mới và điều chỉnh nó để đảm bảo rằng nó vẫn nằm trong phạm vi cho phép.
        var boundedAngle = gesture.touchAngle
        if boundedAngle > midPointAngle || boundedAngle < (midPointAngle - 2 * CGFloat(Double.pi)) {
            boundedAngle -= 2 * CGFloat(Double.pi)
        }
        
        // Cập nhật `boundedAngle` để nó nằm bên trong các giới hạn được chỉ định của các góc.
        boundedAngle = min(endAngle, max(startAngle, boundedAngle))
        
        // Chuyển đổi góc thành một giá trị
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = Float(boundedAngle - startAngle) / Float(angleRange) * valueRange + minimumValue
        
        // Đặt lại giá trị được set
        setValue(angleValue)
        
        if isContinuous {
            sendActions(for: .valueChanged)
        } else {
            if gesture.state == .ended || gesture.state == .cancelled {
                sendActions(for: .valueChanged)
            }
        }
    }
}

//MARK: - Action
extension KnobView {
    // Hàm này sẽ nhận giá trị từ ngoài truyền vào
    func setValue(_ newValue: Float, animated: Bool = false) {
        value = min(maximumValue, max(minimumValue, newValue))
        
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = CGFloat(value - minimumValue) / CGFloat(valueRange) * angleRange + startAngle
        renderer.setPointerAngle(angleValue, animated: animated)
    }
}
