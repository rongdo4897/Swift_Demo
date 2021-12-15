//
//  WCLLoadingView.swift
//  BaseTableView
//
//  Created by Hoang Lam on 15/12/2021.
//

import Foundation
import UIKit

class WCLLoadingView: UIView, CAAnimationDelegate {
    
    // Chiều rộng dòng
    var lineWidth:CGFloat = 0
    // Số dài dòng
    var lineLength:CGFloat = 0
    // Lề
    var margin:CGFloat = 0
    // Thời gian hoạt ảnh
    var duration:Double = 2
    // Khoảng thời gian hoạt ảnh
    var interval:Double = 1
    // Màu sắc của bốn dòng
    var colors:[UIColor] = [UIColor.colorFromHexString(hex: "#9DD4E9") , UIColor.colorFromHexString(hex: "#F5BD58"),  UIColor.colorFromHexString(hex: "#FF317E") , UIColor.colorFromHexString(hex: "#6FC9B5")]
    // Trạng thái hoạt ảnh
    private(set) var status:AnimationStatus = .normal
    // Bốn dòng (layer)
    private var lines:[CAShapeLayer] = []
    
    enum AnimationStatus {
        // Trạng thái bình thường
        case normal
        // Trạng thái hoạt hình
        case animating
        // tạm ngừng
        case pause
    }
    
    //MARK: Public Methods
    /**
     Bắt đầu hoạt ảnh
     */
    func startAnimation() {
        angleAnimation()
        lineAnimationOne()
        lineAnimationTwo()
        lineAnimationThree()
    }
    
    /**
     Tạm dừng hoạt ảnh
     */
    func pauseAnimation() {
        layer.pauseAnimation()
        for lineLayer in lines {
            lineLayer.pauseAnimation()
        }
        status = .pause
    }
    
    /**
     Tiếp tục hoạt ảnh
     */
    func resumeAnimation() {
        layer.resumeAnimation()
        for lineLayer in lines {
            lineLayer.resumeAnimation()
        }
        status = .animating
    }
    
    /**
     Kết thúc hoạt ảnh
    */
    func stopAnimation() {
        layer.removeAllAnimations()
        for lineLayer in lines {
            lineLayer.removeAllAnimations()
        }
        status = .normal
    }
    
    //MARK: Initial Methods
    convenience init(frame: CGRect , colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = colors
        config()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    //MARK: Animation Delegate
    // Hoạt ảnh đã bắt đầu
    func animationDidStart(_ anim: CAAnimation) {
        if let animation = anim as? CABasicAnimation {
            if animation.keyPath == "transform.rotation.z" {
                status = .animating
            }
        }
    }

    // Hoạt ảnh đã kết thúc
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animation = anim as? CABasicAnimation {
            if animation.keyPath == "strokeEnd" {
                if flag {
                    status = .normal
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(interval) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                        if self.status != .animating {
                            self.startAnimation()
                        }
                    })
                }
            }
        }
    }
    
    //MARK: Privater Methods
    //MARK: Vẽ đường thẳng
    /**
     Vẽ bốn đường
     */
    private func drawLineShapeLayer() {
        // Điểm khởi đầu
        let startPoint = [point(lineWidth/2, y: margin),
                          point(lineLength - margin, y: lineWidth/2),
                          point(lineLength - lineWidth/2, y: lineLength - margin),
                          point(margin, y: lineLength - lineWidth/2)]
        // Điểm cuối
        let endPoint   = [point(lineLength - lineWidth/2, y: margin) ,
                         point(lineLength - margin, y: lineLength - lineWidth/2) ,
                         point(lineWidth/2, y: lineLength - margin) ,
                         point(margin, y: lineWidth/2)]
        for i in 0...3 {
            let line:CAShapeLayer = CAShapeLayer()
            line.lineWidth   = lineWidth
            line.lineCap     = CAShapeLayerLineCap.round
            line.opacity     = 0.8
            line.strokeColor = colors[i].cgColor
            line.path        = getLinePath(startPoint[i], endPoint: endPoint[i]).cgPath
            layer.addSublayer(line)
            lines.append(line)
        }
        
    }
    
    /**
     Nhận đường dẫn của dòng
     
     - parameter startPoint: Điểm khởi đầu
     - parameter endPoint:   Điểm cuối
     
     - returns: Đường đi của dòng
     */
    private func getLinePath(_ startPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        return path
    }
    
    //MARK: Các bước hoạt ảnh
    /**
     Xoay hoạt ảnh, hai cách xoay
     */
    private func angleAnimation() {
        let angleAnimation                 = CABasicAnimation.init(keyPath: "transform.rotation.z")
        angleAnimation.beginTime           = CACurrentMediaTime()
        angleAnimation.fromValue           = angle(-30)
        angleAnimation.toValue             = angle(690)
        angleAnimation.fillMode            = CAMediaTimingFillMode.forwards
        angleAnimation.isRemovedOnCompletion = false
        angleAnimation.duration            = duration
        angleAnimation.delegate            = self
        layer.add(angleAnimation, forKey: "angleAnimation")
    }
    
    
    /**
     Bước đầu tiên của hoạt ảnh dòng, độ dài dòng thay đổi từ dài sang ngắn
     */
    private func lineAnimationOne() {
        let lineAnimationOne                 = CABasicAnimation.init(keyPath: "strokeEnd")
        lineAnimationOne.beginTime           = CACurrentMediaTime()
        lineAnimationOne.duration            = duration/2
        lineAnimationOne.fillMode            = CAMediaTimingFillMode.forwards
        lineAnimationOne.isRemovedOnCompletion = false
        lineAnimationOne.fromValue           = 1
        lineAnimationOne.toValue             = 0
        for i in 0...3 {
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationOne, forKey: "lineAnimationOne")
        }
    }
    
    /**
     Hoạt ảnh bước thứ hai của dòng, dòng di chuyển đến giữa
     */
    private func lineAnimationTwo() {
        for i in 0...3 {
            var keypath = "transform.translation.x"
            if i%2 == 1 {
                keypath = "transform.translation.y"
            }
            let lineAnimationTwo                   = CABasicAnimation.init(keyPath: keypath)
            lineAnimationTwo.beginTime             = CACurrentMediaTime() + duration/2
            lineAnimationTwo.duration              = duration/4
            lineAnimationTwo.fillMode              = CAMediaTimingFillMode.forwards
            lineAnimationTwo.isRemovedOnCompletion = false
            lineAnimationTwo.autoreverses          = true
            lineAnimationTwo.fromValue             = 0
            if i < 2 {
                lineAnimationTwo.toValue = lineLength/4
            }else {
                lineAnimationTwo.toValue = -lineLength/4
            }
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationTwo, forKey: "lineAnimationTwo")
        }
        
        // Tỉ lệ hai cạnh của tam giác
        let scale = (lineLength - 2 * margin) / (lineLength - lineWidth)
        for i in 0...3 {
            var keypath = "transform.translation.y"
            if i % 2 == 1 {
                keypath = "transform.translation.x"
            }
            let lineAnimationTwo                   = CABasicAnimation.init(keyPath: keypath)
            lineAnimationTwo.beginTime             = CACurrentMediaTime() + duration/2
            lineAnimationTwo.duration              = duration/4
            lineAnimationTwo.fillMode              = CAMediaTimingFillMode.forwards
            lineAnimationTwo.isRemovedOnCompletion = false
            lineAnimationTwo.autoreverses          = true
            lineAnimationTwo.fromValue             = 0
            if i == 0 || i == 3 {
                lineAnimationTwo.toValue = lineLength/4 * scale
            }else {
                lineAnimationTwo.toValue = -lineLength/4 * scale
            }
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationTwo, forKey: "lineAnimationThree")
        }
    }
    
    /**
     Hoạt ảnh bước thứ ba của dòng, dòng thay đổi từ ngắn sang dài
     */
    private func lineAnimationThree() {
        // Hoạt ảnh của chuyển động dòng
        let lineAnimationFour                   = CABasicAnimation.init(keyPath: "strokeEnd")
        lineAnimationFour.beginTime             = CACurrentMediaTime() + duration
        lineAnimationFour.duration              = duration/4
        lineAnimationFour.fillMode              = CAMediaTimingFillMode.forwards
        lineAnimationFour.isRemovedOnCompletion = false
        lineAnimationFour.fromValue             = 0
        lineAnimationFour.toValue               = 1
        for i in 0...3 {
            if i == 3 {
                lineAnimationFour.delegate = self
            }
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationFour, forKey: "lineAnimationFour")
        }
    }
    
    //MARK: Private Methods
    private func point(_ x:CGFloat , y:CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    private func angle(_ angle: Double) -> CGFloat {
        return CGFloat(angle *  (Double.pi/180))
    }
    
    private func config() {
        layoutIfNeeded()
        lineLength = max(frame.width, frame.height)
        lineWidth  = lineLength/6.0
        margin     = lineLength/4.5 + lineWidth/2
        drawLineShapeLayer()
        // Điều chỉnh góc độ
        transform = CGAffineTransform.identity.rotated(by: angle(-30))
    }
}

extension CALayer {
    // Tạm dừng hoạt ảnh
    func pauseAnimation() {
        // Chuyển đổi thời gian hiện tại CACurrentMediaTime thành thời gian trên lớp, nghĩa là chuyển đổi thời gian gốc thành giờ địa phương
        let pauseTime = convertTime(CACurrentMediaTime(), from: nil)
        // Đặt timeOffset của lớp, cũng sẽ được sử dụng trong hoạt động liên tục
        timeOffset    = pauseTime
        // Tỷ lệ thời gian cục bộ so với thời gian gốc là 0, có nghĩa là thời gian cục bộ bị tạm ngưng
        speed         = 0
    }
    
    // Tiếp tục hoạt ảnh
    func resumeAnimation() {
        let pausedTime = timeOffset
        speed          = 1
        timeOffset     = 0
        beginTime      = 0
        // Tính thời gian tạm dừng
        let sincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        // giờ địa phương liên quan đến giờ bắt đầu Thời gian của giờ gốc
        beginTime      = sincePause
    }
}
