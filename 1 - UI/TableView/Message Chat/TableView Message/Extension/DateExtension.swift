//
//  DateExtension.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 1/27/21.
//

import Foundation

extension Date {
    static func dateFormCustomString(customString: String) -> Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        guard let date = dateFormater.date(from: customString) else {
            return Date()
        }
        return date
    }
    
    static func stringFromCustomDate(date: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormater.string(from: date)
        return dateString
    }
}
