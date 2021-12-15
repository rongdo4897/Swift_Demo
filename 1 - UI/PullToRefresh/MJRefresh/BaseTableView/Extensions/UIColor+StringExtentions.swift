//
//  UIColorExtentions.swift
//  AITranslate
//
//  Created by Trần An on 5/30/19.
//  Copyright © 2019 MespiTech. All rights reserved.
//

import UIKit
import NaturalLanguage

extension UIColor {
    public class func colorFromHexString(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
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
extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

extension String {
    func refact() -> String {
        let str =  String(self.filter { !" \n\t\r".contains($0) })

        return str
    }

    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }

    var firstUppercased: String {
        prefix(1).uppercased() + dropFirst()
    }

    var firstCapitalized: String {
        prefix(1).capitalized + dropFirst()
    }
}

extension String {
    func getHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func getWidth(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension String {
    func convertToLocalTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.current
        guard let date = dateFormatter.date(from : self) else {
            return ""
        }
        let newFormat = DateFormatter()
        newFormat.dateFormat = "yyyy/MM/dd HH:mm"
        newFormat.locale = Locale.current

        return newFormat.string(from: date)
    }
}
extension String {
    func getNumberWithFormat(_ number : NSNumber, format : String = "###,###") -> String {
         let numberFormatter = NumberFormatter()
         numberFormatter.locale = Locale.current
         numberFormatter.numberStyle = NumberFormatter.Style.decimal
         numberFormatter.usesGroupingSeparator = true

         numberFormatter.positiveFormat = format
         return numberFormatter.string(from: number)!
    }
}
extension String {
    func isEmail() -> Bool {
        let firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegex = firstpart + "@" + serverpart + "[A-Za-z]{2,8}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func getAddress() -> [String] {
        if let regex = try? NSRegularExpression(pattern: "\\d+[ ](?:[A-Za-z0-9.-]+[ ]?)+(?:Avenue|Lane|Road|Boulevard|Drive|Street|Ave|Dr|Rd|Blvd|Ln|St)\\.?", options: .caseInsensitive)
        {
            let string = self as NSString

            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "", with: "")
            }
        }
        return []
    }

    func getJob() -> [String] {
        if let regex = try? NSRegularExpression(pattern: "((([?:A-Za-z0-9.-]?+[ ]?)|[ ]?)+(?:Director|Deputy|Officer|Directors|Holder|Executive|Founder|President|Chairman|Manager|Supervisor|Leader|Assistant|Clerk|Receptionist|Expert|Collaborator|CEO|Owner|Proprietor|Principal|Partner|Member|Administrator|CXO|Accountant|Plumber|Philosopher|Disrupter|Controller|Designer|Trainer|Librarian|Specialist|Consultant|Relations|Copywriter|Buyer|Strategist|Bookkeeper|Analyst|Resources|Secretary|Coordinator|Collector|Scientist|Professional|Developer|Engineer|Programmer|Architect|Associate|Representative|BrokerAssociate|Cashier|Salesperson|Sales|Worker|Shareholders|Authorizer|Counselor|Planner|Technician|Stuff|Ninjaneer|Photographer|Editor|Producer)\\.?)|((Giám đốc|Trưởng phòng|Quản lý|Tổng giám đốc|Phụ trách|Nhân viên|Phó giám đốc|Chủ tịch)(.*)\\.?)", options: .caseInsensitive)
        {
            let string = self as NSString

            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "", with: "")
            }
        }
        return []
    }

    func getPhone() -> [String] {
        if let regex = try? NSRegularExpression(pattern: "([+]?+[(]?+[+]?[0-9]+[)]?)+[ .-]?+([(]?+[0-9]{2,16}+[)]?)?+[ .-]?+([0-9]{2,16})?+[ .-]?+([0-9]{2,16})?\\.?", options: .caseInsensitive)
        {
            let string = self as NSString

            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "", with: "")
            }
        }
        return []
    }
}
