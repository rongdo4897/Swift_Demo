//
//  RulerView.swift
//  CustomView
//
//  Created by V002861 on 7/7/22.
//

import UIKit

@IBDesignable
class RangeSlider: UIControl {
    @IBInspectable
    var hasShadow: Bool = true {
        didSet {
            self.updateShadow()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            let corner = cornerRadius < 0 ? 0 : (cornerRadius <= 15 ? cornerRadius : 15)
            self.layer.cornerRadius = corner
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            let border = borderWidth < 0 ? 0 : borderWidth
            self.layer.borderWidth = border
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var minimumValue: CGFloat = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable
    var maximumValue: CGFloat = 1 {
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable
    var lowerValue: CGFloat = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable
    var upperValue: CGFloat = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable
    var trackTintColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var trackHighlightTintColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var thumbImage = UIImage(named: "Oval")! {
        didSet {
            lowerThumbImageView.image = thumbImage
            upperThumbImageView.image = thumbImage
            updateLayerFrames()
        }
    }
    
    private let trackLayer = RangeSliderTrackLayer()
    private let lowerThumbImageView = UIImageView()
    private let upperThumbImageView = UIImageView()
    
    private var previousLocation = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateLayerFrames()
    }
    
    /*
     Phương thức này theo dõi các vị trí chạm
     
     - UIControl cung cấp một số phương pháp để theo dõi các lần chạm.
     - Nó cung cấp 3 phương thức
        + beginTracking(_:with:)
        + continueTracking(_:with:)
        + endTracking(_:with:)
     */
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // Chuyển sự kiện chạm vào không gian của UIControl (Lấy tọa độ chạm)
        previousLocation = touch.location(in: self)
        
        // Kiểm tra xem tọa độ chạm có thuộc 2 image hay không
        if lowerThumbImageView.frame.contains(previousLocation) {
            lowerThumbImageView.isHighlighted = true
        } else if upperThumbImageView.frame.contains(previousLocation) {
            upperThumbImageView.isHighlighted = true
        }
        
        // Theo dõi các sự kiện chạm sẽ tiếp tục nếu một trong hai image được đánh dấu đã chạm
        return lowerThumbImageView.isHighlighted || upperThumbImageView.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        // Tính toán vị trí kéo
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width
        previousLocation = location
        
        //
        if lowerThumbImageView.isHighlighted {
            lowerValue += deltaValue
            // Giá trị được tính từ giá trị lower hiện tại bắt đầu từ minimun đến vị trí upper hiện tại
            lowerValue = self.boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        } else {
            upperValue += deltaValue
            // Giá trị được tính từ giá trị upper hiện tại bắt đầu từ lower đến vị trí maximum hiện tại
            upperValue = self.boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        // Kết thúc đánh dấu cho hình ảnh
        lowerThumbImageView.isHighlighted = false
        upperThumbImageView.isHighlighted = false
    }
}

//MARK: - Init
extension RangeSlider {
    private func setupView() {
        updateLayoutConstraints()
        updateShadow()
        updateLayer()
        updateImageView()
    }
    
    private func updateLayoutConstraints() {
        let heightContraints = self.heightAnchor.constraint(equalToConstant: 30)
        self.addConstraint(heightContraints)
    }
    
    private func updateShadow() {
        if self.hasShadow {
            self.layer.shadowColor = UIColor.colorFromHexString(hex: "#5F89B1").withAlphaComponent(0.16).cgColor
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = CGSize(width: 2, height: 6)
            self.layer.shadowRadius = 1.5
        } else {
            self.layer.shadowColor = nil
            self.layer.shadowOpacity = 0
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 0
        }
    }
    
    private func updateImageView() {
        lowerThumbImageView.image = thumbImage
        addSubview(lowerThumbImageView)
        
        upperThumbImageView.image = thumbImage
        addSubview(upperThumbImageView)
    }
    
    private func updateLayer() {
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
    }
}

//MARK: - Layer Frame
extension RangeSlider {
    private func updateLayerFrames() {
        // Sử dụng CATransaction.setDisableActions nhằm đảm bảo các thay đổi được áp dụng ngay lập tức và không có hoạt ảnh
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        // Cập nhật lại tọa độ cho các thành phần
        trackLayer.frame = bounds.insetBy(dx: 0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        // Giá trị value được truyền vào ứng với giá trị lowerValue và upperValue
        lowerThumbImageView.frame = CGRect(origin: self.thumbOriginForValue(lowerValue), size: thumbImage.size)
        upperThumbImageView.frame = CGRect(origin: self.thumbOriginForValue(upperValue), size: thumbImage.size)

        CATransaction.commit()
    }
    
    // chia tỷ lệ giá trị đã cho theo bound context. (lấy giá trị độ dài theo tỉ lệ view)
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
    }
    
    // trả về vị trí để ảnh được căn giữa với giá trị được chia tỷ lệ.
    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let x = positionForValue(value) - thumbImage.size.width / 2
        let y = (bounds.height - thumbImage.size.height) / 2
        return CGPoint(x: x, y: y)
    }
}

//MARK: - Action
extension RangeSlider {
    // Trả về giá trị trong phạm vi được chỉ định
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
}
