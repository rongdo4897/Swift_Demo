//
//  DateExtension.swift
//  SmartTA
//
//  Created by THUY Nguyen Duong Thu on 19/11/2020.
//  Copyright © 2020 vti. All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!
    }
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }

    var currentYear: Int {
        return Calendar.current.component(.year, from: Date())
    }

    var currentMonth: Int {
        return Calendar.current.component(.month, from: Date())
    }

    var currentDay: Int {
        return Calendar.current.component(.day, from: Date())
    }

    var components: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .weekOfYear, .hour, .minute], from: self)
    }

    var currentDayString: String {
        let day = self.components.day
        let month = self.components.month
        return "\(String(format: "%02d", day!))/\(String(format: "%02d", month!))"
    }

    var year: String {
        return self.components.year?.description ?? ""
    }

    var monthNumber: String {
        let month = self.components.month
        return "\(String(format: "%02d", month!))"
    }

    var day: String {
        let day = self.components.day
        return "\(String(format: "%02d", day!))"
    }
    //Oct
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    //October
    var fullMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    //Mon
    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ccc"
        return dateFormatter.string(from: self)
    }

    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        return localDate
    }
    //2020-12-12
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    var dateToString: String {
        let dateFormmater = DateFormatter()
        dateFormmater.timeZone = TimeZone.current
        //dateFormmater.timeZone = TimeZone(identifier: "UTC")
        dateFormmater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormmater.string(from: self)
    }

    var hour: String {
        return "\(String(format: "%02d", self.components.hour!))"
    }

    var minute: String {
        return "\(String(format: "%02d", self.components.minute!))"
    }

    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }

    //8:20
    var shortTimeString: String {
        return "\(hour)h\(minute)"
    }

    var shortTimesheetTimeString: String {
        return "\(hour):\(minute)"
    }

    var fullDateString: String {
        return "\(month) \(day), \(year)"
    }

    // 2020-12-08 9:30
    var dateTimeRequest: String {
        return "\(year)-\(monthNumber)-\(day)"
    }

    var fullDateDefault: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.string(from: self)
    }
}

extension String {
    var stringToDateFinal: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self)!
        return date
    }
}
extension TimeZone {

    func timeZoneOffsetInHours() -> Int {
        let seconds = secondsFromGMT()
        let hours = seconds/3600
        return hours
    }
    func timeZoneOffsetInMinutes() -> Int {
        let seconds = secondsFromGMT()
        let minutes = abs(seconds / 60)
        return minutes
    }
}
