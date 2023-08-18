//
//  UIImage.swift
//  MailView
//
//  Created by Lam Hoang Tung on 7/31/23.
//

import UIKit

extension UIImage {
    static func mailIcon(size: CGSize, lineColor: UIColor, lineWidth: CGFloat) -> UIImage? {
        /*
         UIGraphicsBeginImageContextWithOptions
         
         Tạo một ngữ cảnh đồ họa (graphics context) mới để vẽ các hình ảnh và đồ họa tùy chỉnh
         
         Phiên bản chỉ định kích thước của ngữ cảnh đồ họa (graphics context) dưới dạng kích thước chiều rộng và chiều cao:
         
          + size: Kích thước của ngữ cảnh đồ họa mới bạn muốn tạo, được đại diện bằng đối tượng CGSize
          + opaque: Một giá trị Boolean xác định xem ngữ cảnh đồ họa có bị mờ (transparent) hay không (true cho không mờ và false cho mờ).
          + scale: Xác định tỷ lệ hiển thị của hình ảnh (độ phân giải). Giá trị này thường được đặt là 0.0 để sử dụng tỷ lệ màn hình hiện tại.
         
         UIScreen.main.scale được sử dụng để xác định tỷ lệ hiển thị (độ phân giải) của màn hình hiện tại. Thuộc tính này trả về một giá trị số kiểu CGFloat, biểu thị tỷ lệ số điểm ảnh (points) trên mỗi điểm ảnh vật lý (pixels) trên màn hình.
         */
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        /*
         UIGraphicsGetCurrentContext là một hàm trong framework UIKit của iOS, và nó được sử dụng để lấy ra ngữ cảnh đồ họa (graphics context) hiện tại để vẽ các hình ảnh và đồ họa tùy chỉnh.
         
         Hàm này trả về một con trỏ kiểu CGContext?, cho phép bạn truy cập và sử dụng các hàm vẽ của Core Graphics để tạo và chỉnh sửa các hình ảnh, các đối tượng đồ họa và các đường thẳng trong ngữ cảnh đó.
         */
        guard let ctx = UIGraphicsGetCurrentContext() else {return nil}
        // Tạo 1 hình chữ nhật với kích thuớc được truyền vào
        let rect = CGRect(origin: .zero, size: size)
        /*
         UIBezierPath là một lớp trong framework UIKit của iOS và macOS, được sử dụng để mô tả và vẽ các đường cong tùy chỉnh, các hình dạng và đường viền trong giao diện người dùng.

         UIBezierPath cho phép bạn tạo ra các đường cong đơn giản và phức tạp bằng cách kết hợp các điểm điều khiển và các hàm để định dạng các phần của đường cong. Các đường cong này có thể được vẽ trên các UIView, các đối tượng đồ họa hoặc các đối tượng đồ họa lớn hơn như các hình ảnh.
         */
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 3)
        // Thêm đối tượng đường dẫn đã tạo trước đó vào đường dẫn hiện tại trong ngữ cảnh đồ họa.
        ctx.addPath(path.cgPath)
        UIColor.white.setFill()
        ctx.fillPath()
        
        do {
            let sidePad = size.width * 0.15
            let centerY = size.height * 0.58
            let edgeY = size.height * 0.23
            ctx.move(to: .init(x: sidePad, y: edgeY))
            ctx.addLine(to: .init(x: size.width / 2, y: centerY))
            ctx.addLine(to: .init(x: size.width - sidePad, y: edgeY))
            ctx.setStrokeColor(lineColor.cgColor)
            ctx.setLineWidth(lineWidth)
            ctx.setLineCap(.round)
            ctx.setLineJoin(.round)
            ctx.drawPath(using: .stroke)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func mailBadgeImage(boundSize size: CGSize, inset: CGFloat, cornerRadius: CGFloat, cornerPosition: UIRectCorner = .bottomRight) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        let rect = CGRect(origin: .zero, size: size)
        let rrRect = rect.insetBy(dx: inset, dy: inset)
        let ctx = UIGraphicsGetCurrentContext()!
        let width = size.width
        let r: CGFloat = 5
        let pi_8 = Double.pi / 8, r_tan_pi_8 = r/CGFloat(tan(pi_8))
        ctx.saveGState()
        ctx.translateBy(x: size.width / 2, y: size.height / 2)
        ctx.rotate(by: mailBadgeCtxRotationAngle(cornerPosition))
        ctx.translateBy(x: -size.width / 2, y: -size.height / 2)
        ctx.move(to: .init(x: rrRect.maxX, y: rrRect.maxY))
        ctx.addLine(to: .init(x: rrRect.maxX - width + r_tan_pi_8, y: rrRect.maxY))
        ctx.addArc(center: .init(x: rrRect.maxX - width + r_tan_pi_8, y: rrRect.maxY - r), radius: r, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi / 2 + CGFloat(pi_8) * 6 , clockwise: false)
        ctx.addLine(to: .init(x: rrRect.maxX - r - CGFloat(sin(pi_8 * 2)) * r, y: rrRect.maxY - width + r_tan_pi_8 - CGFloat(cos(pi_8 * 2)) * r))
        ctx.addArc(center: .init(x: rrRect.maxX - r, y: rrRect.maxY - width + r_tan_pi_8), radius: r, startAngle: -CGFloat(pi_8) * 6, endAngle: 0, clockwise: false)
        ctx.closePath()
        ctx.clip()
        let rrPath = UIBezierPath(roundedRect: rrRect, byRoundingCorners: UIRectCorner.bottomRight, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        ctx.addPath(rrPath.cgPath)
        let pink = #colorLiteral(red: 0.9725490196, green: 0.5176470588, blue: 0.6392156863, alpha: 1)
        pink.setFill()
        ctx.drawPath(using: .eoFill)
        ctx.restoreGState()
        //icon
        let iconSize = CGSize(width: 14, height: 10)
        let mailIconImage = mailIcon(size: .init(width: 14, height: 10), lineColor: #colorLiteral(red: 0.9725490196, green: 0.5176470588, blue: 0.6392156863, alpha: 1), lineWidth: 1)
        mailIconImage?.draw(at: mailBadgeImageOrigin(cornerPosition, roundedRectFrame: rrRect, iconSize: iconSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private static func mailBadgeCtxRotationAngle(_ cornerPos: UIRectCorner) -> CGFloat {
        switch cornerPos {
        case .bottomRight:          return .pi * 0.0
        case .bottomLeft:           return .pi * 0.5
        case .topLeft:              return .pi * 1.0
        case .topRight:             return .pi * 1.5
        default:                    return 0
        }
    }
    
    private static func mailBadgeImageOrigin(_ cornerPos: UIRectCorner, roundedRectFrame: CGRect, iconSize: CGSize) -> CGPoint {
        let rrRect = roundedRectFrame
        let iconCenter: CGPoint = {
            switch cornerPos {
            case .bottomRight:  return CGPoint(x: (rrRect.minX + rrRect.maxX * 2) / 3, y: (rrRect.minY + rrRect.maxY * 2) / 3)
            case .bottomLeft:   return CGPoint(x: (rrRect.minX * 2 + rrRect.maxX) / 3, y: (rrRect.minY + rrRect.maxY * 2) / 3)
            case .topLeft:      return CGPoint(x: (rrRect.minX * 2 + rrRect.maxX) / 3, y: (rrRect.minY * 2 + rrRect.maxY) / 3)
            case .topRight:     return CGPoint(x: (rrRect.minX + rrRect.maxX * 2) / 3, y: (rrRect.minY * 2 + rrRect.maxY) / 3)
            default:            return .zero
            }
        }()
        return CGPoint(x: iconCenter.x - iconSize.width / 2, y: iconCenter.y - iconSize.height / 2)
    }
}
