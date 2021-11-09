//
//  ViewController.swift
//  CustomCalendar
//
//  Created by Hoang Tung Lam on 1/18/21.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {
    @IBOutlet weak var viewCalendar: FSCalendar!
    @IBOutlet weak var lblDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initCalendar()
    }

    func initCalendar() {
        viewCalendar.layer.cornerRadius = 20
        viewCalendar.dataSource = self
        viewCalendar.delegate = self
        // cho chọn nhiều ngày
        viewCalendar.allowsMultipleSelection = true
        // Chỉ mục ngày đầu tiên trong tuần. 2 = thứ hai
        viewCalendar.firstWeekday = 2
        // background
        viewCalendar.backgroundColor = .white
        // Màu sắc của các chấm sự kiện.
        viewCalendar.appearance.eventSelectionColor = .white
        // Độ lệch của các chấm sự kiện so với vị trí mặc định.
        viewCalendar.appearance.eventOffset = CGPoint(x: 0, y: 0)
        // Loại trình giữ chỗ của FSCalendar. Mặc định là FSCalendarPlaceholderTypeFillSixRows.
        viewCalendar.placeholderType = .fillSixRows
        // Phạm vi của calendar
        viewCalendar.scope = .month
        // Màu của văn bản tiêu đề tháng và Màu của văn bản các ngày trong tuần.
        viewCalendar.appearance.headerTitleColor = .black
        viewCalendar.appearance.weekdayTextColor = .black
        
        // register
        viewCalendar.today = nil
        viewCalendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        viewCalendar.clipsToBounds = false
        viewCalendar.swipeToChooseGesture.isEnabled = true // Bật kéo phải
        // Một chuỗi xác định phần tử.
        viewCalendar.accessibilityIdentifier = "calendar"
    }
}

extension ViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    // Yêu cầu nguồn dữ liệu cho một ô để chèn vào một dữ liệu cụ thể của lịch.
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    // Cho đại biểu biết rằng ô đã chỉ định sắp được hiển thị trong lịch.
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: monthPosition)
    }
    // Yêu cầu dữ liệu Nguồn cho một tiêu đề cho ngày cụ thể để thay thế văn bản ngày
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return nil
    }
    // Yêu cầu người đại diện cho màu văn bản ngày ở trạng thái không được chọn cho ngày cụ thể.
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .black
    }
    
    /// FSCalendar Delegate
    
    // Cho đại biểu biết lịch sắp thay đổi giới hạn.
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.viewCalendar.frame.size.width = bounds.height
    }
    // Hỏi người được ủy quyền xem ngày cụ thể có được phép chọn bằng cách nhấn hay không.
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    // Hỏi đại biểu xem ngày cụ thể có được phép bỏ chọn hay không bằng cách nhấn.
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    // Cho đại biểu biết một ngày trong lịch được chọn bằng cách chạm vào.
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.selectedDates.count == 3 {
            for date in calendar.selectedDates {
                calendar.deselect(date)
            }
            calendar.select(date)
        } else if calendar.selectedDates.count == 2 {
            var first = calendar.selectedDates[0]
            var second = calendar.selectedDates[1]
            if second <= first {
                let temp = first
                first = second
                second = temp
            }
            self.lblDate.text = "\(first)          \(second)"
        }
        self.configureVisiableCells()
    }
    // Cho đại biểu biết một ngày trong lịch được bỏ chọn bằng cách nhấn.
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisiableCells()
    }
    // Yêu cầu người được ủy quyền cho một phần bù cho các dấu chấm sự kiện cho ngày cụ thể.
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    // Cho đại biểu biết lịch sắp thay đổi trang hiện tại.
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let height = 300 - calendar.preferredWeekdayHeight - calendar.preferredHeaderHeight
        calendar.collectionView.height = height
        calendar.collectionViewLayout.invalidateLayout()
    }
    
    /// Private func
    
    // cấu hình cell
    private func configureVisiableCells() {
        viewCalendar.visibleCells().forEach { (cell) in
            let date = viewCalendar.date(for: cell)
            let position = viewCalendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    // cấu hình
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        guard let diyCell = cell as? DIYCalendarCell else {return}
        if position == .current {
            var seletionType = SelectionType.none
            if viewCalendar.selectedDates.count == 2 {
                var first = viewCalendar.selectedDates[0]
                var second = viewCalendar.selectedDates[1]
                if second <= first {
                    let temp = first
                    first = second
                    second = temp
                }
                if date == first {
                    seletionType = .leftBorder
                } else if date == second {
                    seletionType = .rightBorder
                } else if date >= first && date <= second {
                    seletionType = .middle
                }
            } else {
                if viewCalendar.selectedDates.contains(date) {
                    if viewCalendar.selectedDates.count == 1 {
                        seletionType = .single
                    } else {
                        seletionType = .none
                    }
                } else {
                    seletionType = .none
                }
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = seletionType
        } else {
            diyCell.selectionLayer.isHidden = true
        }
    }
    
}
