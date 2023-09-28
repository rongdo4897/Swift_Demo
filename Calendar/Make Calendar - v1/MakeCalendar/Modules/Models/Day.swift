//
//  Day.swift
//  MakeCalendar
//
//  Created by Hoang Lam on 29/11/2021.
//

import Foundation

struct Day {
    // Ngày đại diện cho một ngày nhất định trong một tháng.
    let date: Date
    // số sẽ được hiển thị
    let number: String
    // Kiểm tra xem ngày có được chọn hay không
    let isSelect: Bool
    // Kiểm tra xem ngày có nằm trong tháng hiện tại hay không
    let isWithinDisplayedMonth: Bool
}
