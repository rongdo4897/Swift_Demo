//
//  Constants.swift
//  IVM
//
//  Created by an.trantuan on 6/26/20.
//  Copyright © 2020 an.trantuan. All rights reserved.
//

import UIKit

class Constants {
    // api defined
    static let timeOut = TimeInterval(30)
    static let authorization = "Authorization"
    static let domain = "domain"

    // storyboard
    static let table: String = "Table"
}

class Defined {
    static let devideId = UIDevice.current.identifierForVendor!.uuidString
    static let devideName = UIDevice.current.name
    // color
    static let whiteColor = UIColor.white
    static let blackColor = UIColor.black
    static let lightGrayColor = UIColor.colorFromHexString(hex: "E8E8E8")
    static let lightGrayColor2 = UIColor.colorFromHexString(hex: "f4f4f2")
    static let orangeColor = UIColor.colorFromHexString(hex: "F28157")
    static let blue2 = UIColor.colorFromHexString(hex: "2D9CDB")
    static let grayClockColor = UIColor.colorFromHexString(hex: "828282")
    static let reuColor = UIColor.colorFromHexString(hex: "11374B")
    static let blueMenu = UIColor.colorFromHexString(hex: "BDEBFA")
    static let blue3Menu = UIColor.colorFromHexString(hex: "56CCF2")
    static let lineColor = UIColor.colorFromHexString(hex: "E0E0E0")
    static let filterColor = UIColor.colorFromHexString(hex: "2F80ED")
    // font
    static let secureColor = UIColor.colorFromHexString(hex: "F16F6A")
    static let unsecuredColor = UIColor.colorFromHexString(hex: "33CC99")
    static let lineBorderColor = UIColor.colorFromHexString(hex: "BDBDBD")
    static let invalidRedColor = UIColor.colorFromHexString(hex: "EB5757")
    static let line0Color = UIColor.colorFromHexString(hex: "2F80ED")
    static let line1Color = UIColor.colorFromHexString(hex: "FD8686")
    static let line2Color = UIColor.colorFromHexString(hex: "F4D36C")
    static let line3Color = UIColor.colorFromHexString(hex: "56CCF2")
    static let line4Color = UIColor.colorFromHexString(hex: "979797")
    static let eyeColor = UIColor.colorFromHexString(hex: "333333")
    static let draftColor = UIColor.colorFromHexString(hex: "BDBDBD")
    static let rejectedColor = UIColor.colorFromHexString(hex: "EB5757")
    static let pendingColor = UIColor.colorFromHexString(hex: "F2C94C")
    static let approvedColor = UIColor.colorFromHexString(hex: "33CC99")
    static let lightBlue = UIColor.colorFromHexString(hex: "D4F2FC")
    static let blueDropDownColor = UIColor.colorFromHexString(hex: "ECF4FD")
    static let boldFont: UIFont =  UIFont.systemFont(ofSize: 15, weight: .bold)

    static func fontWithSize(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont()
    }

    // texview limit
    static let MAX_LENGTH = 65535
}
