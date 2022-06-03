//
//  UIColorUtil.swift
//  iOSClient
//
//  Created by HYRON-JS-YEYANG on 2019/8/20.
//  Copyright © 2019 sonylife. All rights reserved.
//

import UIKit
extension UIColor {
    public class func colorFromHexString(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
extension UIColor {

    // ブランドカラー
    class func brandColor() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x002B69)
    }

    // 背景カラー
    class func backgroundColorGray() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xF0F1F2)
    }

    class func backgroundColorYellow() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xFFD453)
    }

    class func grayedBackgroundYellow() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xA28A44)
    }

    class func backgroundColorYellowOrange() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xFCCF00)
    }

    class func backgroundIndigoBlue() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x173666)
    }

    class func backgroundLightBlue() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xEDF5FF)
    }

    class func backgroundRedTextFieldMailUpdateInput() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xFFF2F2)
    }

    class func backgroundGray() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xE6E6E6)
    }

    // 原色カラー
    class func baseColorWhite() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xFFFFFF)
    }

    class func baseColorGray() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xD5D5D5)
    }

    class func baseBlueColor() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x1C74B4)
    }

    class func baseRedColor() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xFF5050)
    }

    class func basePinkColor() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xFFF2F2)
    }

    // 線カラー
    class func borderColor() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xE0E3E8)
    }

    // 文字色カラー
    class func fontColorDarkNavyBlue() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x204073)
    }

    class func fontColorDarkNavyBluePurple() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x173666)
    }

    class func fontColorDarkGray() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x333333)
    }

    class func fontColorGray() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x808080)
    }

    class func fontColorLiteGray() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xB3B3B3)
    }

    class func fontColorLiteBlue() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x3D79D9)
    }

    // Button
    class func shadowButtonColorGray() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x5F89B1, alpha: 0.69)
    }

    class func shadowButtonColorGrayLight() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x5F89B1, alpha: 0.45)
    }

    // アイコンカラー
    class func iconColorGray() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x9EA8B7)
    }

    class func iconColorRed() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xD13731)
    }

    class func editMenuCellSelectedColor() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x021A3D)
    }

    // TextField
    class func textFieldHighLightColorGray() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x989898)
    }

    class func textFieldNormalColorGray() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xD5D5D5)
    }

    class func grayDisableColor() -> UIColor {
        return UIColor.colorFromHexString(hex: "#DBDCDD")
    }

    // Message
    class func sendMsgBackgroundColorBlue() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xAFE4ED)
    }

    class func sendMsgResendBackgroundColorGray() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xCCCCCC)
    }

    class func sendMsgTextColorGray() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xBFBFBF)
    }

    class func linkTextColorBlue() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x1C74B4)
    }

    class func irisBlueColor() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x00969D)
    }

    class func darkGrayColor() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0xAAAAAA)
    }

    class func primaryColor() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x375796)
    }

    class func blackColor() -> UIColor {
        return UIColor.rgbColor(rgbValue: 0x000000)
    }
    /// 指定色のUIColorを取得
    ///
    /// - Parameters:
    ///   - rgbValue: rgb
    ///   - alpha: 透明度
    /// - Returns: 色のUIColor
    class func rgbColor(rgbValue: UInt, alpha: Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
        let blue = CGFloat(rgbValue & 0xFF) / 256.0
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}
