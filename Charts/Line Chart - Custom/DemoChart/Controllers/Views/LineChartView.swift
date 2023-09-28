//
//  LineChartView.swift
//  DemoChart
//
//  Created by Hoang Lam on 03/06/2022.
//

import Foundation
import UIKit

@IBDesignable
class LineChartView: UIView {
    // Đường biểu thị
    private let lineLayer = CAShapeLayer()
    // Hình tròn
    private let circleLayer = CAShapeLayer()
    
    /*
     Vẽ đồ họa 2D trong đồ thị
     
     Trong trường hợp này, phép biến đổi sẽ lấy tọa độ XY của dữ liệu và vẽ chúng theo tọa độ XY của biểu đồ
     */
    private var chartTransform: CGAffineTransform?
    
    /// Màu đường thẳng
    @IBInspectable var lineColor: UIColor = .green {
        didSet {
            lineLayer.strokeColor = lineColor.cgColor
        }
    }
    
    /// Kích thước đường thẳng
    @IBInspectable var lineWidth: CGFloat = 1
    
    /// Hiển thị vòng tròn
    @IBInspectable var showPoints: Bool = true {
        didSet {
            circleLayer.isHidden = !showPoints
        }
    }
    
    /// Màu vòng tròn
    @IBInspectable var circleColor: UIColor = .red {
        didSet {
            circleLayer.fillColor = circleColor.cgColor
        }
    }
    
    /// Kích thước vòng tròn
    @IBInspectable var circleSizeMultiplier: CGFloat = 3
    
    /// Màu của trục
    @IBInspectable var axisColor: UIColor = .white
    /// Hiển thị lưới bên trong
    @IBInspectable var showInnerLines: Bool = true
    /// Text biểu thị tọa độ lưới
    @IBInspectable var labelFontSize: CGFloat = 10
    
    /// Độ rộng của mỗi đường kẻ trong lưới
    var axisLineWidth: CGFloat = 1
    /// Khoảng cách mỗi mắt lưới trên trục x
    var deltaX: CGFloat = 10
    /// Khoảng cách mỗi mắt lưới trên trục y
    var deltaY: CGFloat = 10
    /// Tọa độ x lớn nhất
    var xMax: CGFloat = 100
    /// Tọa độ y lớn nhất
    var yMax: CGFloat = 100
    /// Tọa độ x nhỏ nhất
    var xMin: CGFloat = 0
    /// Tọa độ y nhỏ nhất
    var yMin: CGFloat = 0
    
    /// Toạ độ điểm để nối trên đồ thị
    var data: [CGPoint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineLayer.frame = bounds
        circleLayer.frame = bounds
        
        if let d = data {
            setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
            plot(d)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext(), let t = chartTransform else { return }
        drawAxis(in: context, usingTransform: t)
    }
}

//MARK: - Setup
extension LineChartView {
    private func setupLayer() {
        layer.addSublayer(lineLayer)
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = lineColor.cgColor
        
        layer.addSublayer(circleLayer)
        circleLayer.fillColor = circleColor.cgColor
        circleLayer.strokeColor = UIColor.clear.cgColor
        
        layer.borderWidth = 1
        layer.borderColor = axisColor.cgColor
    }
}

//MARK: - Set tọa độ cho đồ thị chính
/*
 - Điều này bao gồm việc xác định `CGAffineTransform` sẽ trông như thế nào
 
 - Ta cần 2 phương pháp để thực hiện điểu trên
 + Đặt xMax, xMin, yMax, yMin một cách rõ ràng
 + Tính toán 1 tập hợp giá trị tối thiểu và tối đa thích hợp từ các điểm dữ liệu
 
 - Để làm điều thứ 2, cần tìm ra giá trị cao nhất trong dữ liệu, chia nó cho deltaX, làm tròn kết quả rồi nhân ngược lại với deltaX
 
 - Giả sử có giá trị tối đa = 190, deltaX = 30, sau khi thực hiện điều trên ta thu được giá trị cao nhất mới là 210
 Nếu đặt giá trị tối đa chỉ là 200, ta sử dụng phương pháp khác
 */
extension LineChartView {
    /// Lấy phạm vi của điểm lớn nhất. Bao gồm cả 2 trục `x` và `y`
    private func setAxisRange(forPoints points: [CGPoint]) {
        guard !points.isEmpty else {return}
        
        let xArr = points.map() { $0.x }
        let yArr = points.map() { $0.y }
        
        xMax = ceil(xArr.max()! / deltaX) * deltaX
        yMax = ceil(yArr.max()! / deltaY) * deltaY
        xMin = 0
        yMin = 0
        
        setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
    }
    
    /// Lấy phạm vi của vùng đồ thị và chia tỉ lệ đồ thi thông qua `xMax, xMin, yMax, yMin`
    private func setAxisRange(xMin: CGFloat, xMax: CGFloat, yMin: CGFloat, yMax: CGFloat) {
        self.xMin = xMin
        self.xMax = xMax
        self.yMin = yMin
        self.yMax = yMax
        
        setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
    }
    
    /// Xây dựng phép biến đổi affine mà chúng ta sử dụng để vẽ các trục và tất cả các điểm
    private func setTransform(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        // Toạ độ x,y cho label xMax và yMax được lấy theo fontSize
        let xLabelSize = "\(Int(maxX))".size(withSystemFontSize: labelFontSize)
        let yLabelSize = "\(Int(maxY))".size(withSystemFontSize: labelFontSize)
        
        // Phần bù cho tọa độ x,y vừa lấy
        let xOffSet = xLabelSize.height + 10
        let yOffset = yLabelSize.width + 5
        
        // Co dãn theo tỉ lệ của biểu đồ
        let xScale = (bounds.width - yOffset - xLabelSize.width / 2 - 2) / (maxX - minX)
        let yScale = (bounds.height - xOffSet - yLabelSize.height / 2 - 2) / (maxY - minY)
        
        // Khởi tạo CGAffineTransform
        /*
         a: tỉ lệ x so với x cũ | newX = a * oldX
         d: tỷ lệ y so với y cũ | newY = d * oldY
         tx: dịch newX bằng cách sử dụng hệ thống tỷ lệ của x cũ | newX = oldX * a + tX
         ty: giống như tx
         
         b, c chia tỷ lệ x & y tương ứng với y & x cũ - điều này gây ra xoay vòng, vì vậy không quan tâm ngay bây giờ và do đó cả hai đều bằng không.
         */
        chartTransform = CGAffineTransform(a: xScale, b: 0, c: 0, d: -yScale, tx: yOffset, ty: bounds.height - xOffSet)
        
        setNeedsDisplay()
    }
    
    /// Vẽ trục tọa độ
    ///
    /// - context: Môi trường vẽ đồ họa 2D
    /// - usingTransform t: Đồ họa 2D cần vẽ
    ///
    private func drawAxis(in context: CGContext, usingTransform t: CGAffineTransform) {
        // Đẩy một bản sao của trạng thái đồ họa hiện tại vào ngăn xếp trạng thái đồ họa cho ngữ cảnh.
        context.saveGState()
        
        // Tạo 2 đường dẫn, 1 cho trục XY, 1 cho nối các điểm
        let thickerLines = CGMutablePath()
        let thinnerLines = CGMutablePath()
        
        // Tập tọa độ cho 2 trục của biểu đồ
        let xAxisPoints = [CGPoint(x: xMin, y: 0), CGPoint(x: xMax, y: 0)]
        let yAxisPoints = [CGPoint(x: 0, y: yMin), CGPoint(x: 0, y: yMax)]
        
        // Vẽ 2 đường trục và áp dụng phép biến đổi tương ứng với đồ thị
        thickerLines.addLines(between: xAxisPoints, transform: t)
        thickerLines.addLines(between: yAxisPoints, transform: t)
        
        // Tiếp theo chúng ta đi từ xMin tới xMax bởi deltaX bằng cách sử dụng stride
        for x in stride(from: xMin, through: xMax, by: deltaX) {
            // Tập các điểm cần nối trên đồ thị
            let tickPoints = showInnerLines ?
            [CGPoint(x: x, y: yMin).applying(t), CGPoint(x: x, y: yMax).applying(t)] :
            [CGPoint(x: x, y: 0).applying(t), CGPoint(x: x, y: 0).applying(t).adding(y: -5)]
            
            // Nối các điểm
            thinnerLines.addLines(between: tickPoints)
            
            if x != xMin {
                // Vẽ label đánh dấu
                let label = "\(Int(x))" as NSString
                print(label as! String)
                let labelSize = "\(Int(x))".size(withSystemFontSize: labelFontSize)
                let labelDrawPoint = CGPoint(x: x, y: 0).applying(t).adding(x: -labelSize.width / 2).adding(y: 1)
                
                label.draw(at: labelDrawPoint,
                           withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: labelFontSize),
                                            NSAttributedString.Key.foregroundColor: axisColor])
            }
        }
        
        // Vòng lặp cho y
        for y in stride(from: yMin, through: yMax, by: deltaY) {
            let tickPoints = showInnerLines ?
            [CGPoint(x: xMin, y: y).applying(t), CGPoint(x: xMax, y: y).applying(t)] :
            [CGPoint(x: 0, y: y).applying(t), CGPoint(x: 0, y: y).applying(t).adding(x: 5)]
            
            
            thinnerLines.addLines(between: tickPoints)
            
            if y != yMin {
                let label = "\(Int(y))" as NSString
                let labelSize = "\(Int(y))".size(withSystemFontSize: labelFontSize)
                let labelDrawPoint = CGPoint(x: 0, y: y).applying(t)
                    .adding(x: -labelSize.width - 1)
                    .adding(y: -labelSize.height/2)
                
                label.draw(at: labelDrawPoint,
                           withAttributes:
                            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: labelFontSize),
                             NSAttributedString.Key.foregroundColor: axisColor])
            }
        }
        
        // Cuối cùng đặt màu nét & độ rộng đường nét, sau đó đặt nét dày, lặp lại cho nét mỏng
        context.setStrokeColor(axisColor.cgColor)
        context.setLineWidth(axisLineWidth)
        context.addPath(thickerLines)
        context.strokePath()
        
        context.setStrokeColor(axisColor.withAlphaComponent(0.5).cgColor)
        context.setLineWidth(axisLineWidth/2)
        context.addPath(thinnerLines)
        context.strokePath()
        
        context.restoreGState()
    }
    
    private func circles(atPoints points: [CGPoint], withTransform t: CGAffineTransform) -> CGPath {
        
        let path = CGMutablePath()
        let radius = lineLayer.lineWidth * circleSizeMultiplier/2
        for i in points {
            let p = i.applying(t)
            let rect = CGRect(x: p.x - radius, y: p.y - radius, width: radius * 2, height: radius * 2)
            path.addEllipse(in: rect)
            
        }
        
        return path
    }
}

//MARK: - Public func
extension LineChartView {
    func plot(_ points: [CGPoint]) {
        lineLayer.path = nil
        circleLayer.path = nil
        data = nil
        
        guard !points.isEmpty else { return }
        
        self.data = points
        
        if self.chartTransform == nil {
            setAxisRange(forPoints: points)
        }
        
        let linePath = CGMutablePath()
        linePath.addLines(between: points, transform: chartTransform!)
        
        lineLayer.path = linePath
        
        if showPoints {
            circleLayer.path = circles(atPoints: points, withTransform: chartTransform!)
        }
    }
}
