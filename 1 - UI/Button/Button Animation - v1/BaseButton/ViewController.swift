//
//  ViewController.swift
//  BaseButton
//
//  Created by Hoang Lam on 26/11/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imgButton: UIImageView!
    @IBOutlet weak var lblCount: UILabel!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imgButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage)))
        imgButton.isUserInteractionEnabled = true
    }
}

extension ViewController {
    @objc func tapImage() {
        count += 1
        lblCount.text = String(count)
        showTheApplauseInView(view: view, belowView: imgButton)
    }
}

extension ViewController {
    private func showTheApplauseInView(view: UIView, belowView: UIView) {
        let index = arc4random_uniform(7)
        let image = UIImage(named: "applause_\(index)")
        let applauseImageView: UIImageView = UIImageView(frame: CGRect(x: belowView.frame.origin.x, y: belowView.frame.origin.y, width: 40, height: 40))
        applauseImageView.image = image
        
        view.insertSubview(applauseImageView, belowSubview: belowView)
        
        // Chiều cao của đường dẫn hoạt ảnh
        let animH: CGFloat = 500
        // Khởi tạo hoạt ảnh
        applauseImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        applauseImageView.alpha = 0
        
        // Hoạt ảnh bật lên
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            applauseImageView.transform = CGAffineTransform.identity
            applauseImageView.alpha = 0.9
        }, completion: nil)
        
        // Góc lệch ngẫu nhiên
        let i = arc4random_uniform(2)
        // Hướng quay (-1 hoặc 1, hướng ngẫu nhiên)
        let rotationDirection = 1 - (2 * Int(i))
        // Góc ngẫu nhiên
        let rotationFraction = arc4random_uniform(10)
        
        // Hình ảnh xoay trong quá trình đi lên
        UIView.animate(withDuration: 4, animations: {
            applauseImageView.transform = CGAffineTransform(rotationAngle: CGFloat(rotationDirection) * CGFloat(Double.pi) / CGFloat((4 + Double(rotationFraction) * 0.2)))
        }, completion: nil)
        
        // Đường dẫn hoạt ảnh
        let heartTravelPath = UIBezierPath()
        heartTravelPath.move(to: applauseImageView.center)
        
        // Kết thúc ngẫu nhiên
        let viewX = applauseImageView.center.x
        let viewY = applauseImageView.center.y
        let endPoint = CGPoint(x: viewX + CGFloat(rotationDirection) * 10, y: viewY - animH)
        
        // Điểm kiểm soát ngẫu nhiên
        let j = arc4random_uniform(2)
        let travelDirection = 1 - (2 * Int(j)) // Đặt ngẫu nhiên -1 HOẶC 1
        
        let m1 = viewX + CGFloat(travelDirection * (Int(arc4random_uniform(20)) + 50))
        let n1 = viewY - 60 + CGFloat(travelDirection * Int(arc4random_uniform(20)))
        let m2 = viewX - CGFloat(travelDirection*(Int(arc4random_uniform(20)) + 50))
        let n2 = viewY - 90 + CGFloat(travelDirection * Int(arc4random_uniform(20)))
        
        // Điều khiển linh hoạt điều chỉnh theo hiệu ứng mong muốn của hoạt ảnh của bạn
        let controlPoint1 = CGPoint(x: m1, y: n1)
        let controlPoint2 = CGPoint(x: m2, y: n2)
        
        // Thêm hoạt ảnh dựa trên đường cong Bezier
        heartTravelPath.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        // Hoạt ảnh khung chính để nhận ra sự dịch chuyển toàn bộ hình ảnh
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        keyFrameAnimation.path = heartTravelPath.cgPath
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)]
        // Thời lượng hoạt ảnh trở lên, tốc độ có thể được kiểm soát
        keyFrameAnimation.duration = 3
        applauseImageView.layer.add(keyFrameAnimation, forKey: "positionOnPath")
        
        // Biến mất hoạt ảnh
        UIView.animate(withDuration: 3) {
            applauseImageView.alpha = 0
        } completion: { _ in
            applauseImageView.removeFromSuperview()
        }

    }
}
