//
//  CalendarCell.swift
//  TableView Calendar
//
//  Created by Hoang Tung Lam on 1/25/21.
//

import UIKit
import FSCalendar

protocol CaledarCellDelegate: class {
    func clickFilter()
    func collapsedCalendar()
}

class CalendarCell: UITableViewCell {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewFilter: UIView!
    
    weak var delegate: CaledarCellDelegate?
    var shouldCollapsed = false
    var startDate = ""
    var endDate = ""
    var currentDate = Date()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        initCalendar()
        lblTime.text = currentDate.fullDateString
        selectRangeInCalendar(currentDate, currentDate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell() {
        subView.addShadow(color: UIColor.black, radius: 5, opacity: 0.1)
        subView.layer.cornerRadius = 20
        viewFilter.layer.cornerRadius = 10
        viewFilter.addShadow()
    }

    func initCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.firstWeekday = 2
        calendar.backgroundColor = .clear
        calendar.appearance.eventSelectionColor = UIColor.white
        calendar.appearance.eventOffset = CGPoint(x: 0, y: 0)
        calendar.placeholderType = .none
        calendar.scope = .month
        calendar.appearance.headerTitleColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        calendar.appearance.weekdayTextColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        //calendar.appearance.
        calendar.today = nil // Hide the today circle
        calendar.register(DateCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.clipsToBounds = false // Remove top/bottom line
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        self.calendar.accessibilityIdentifier = "calendar"
    }

    func selectRangeInCalendar(_ first: Date, _ second: Date) {
        calendar.allowsMultipleSelection = true
        calendar.select(first)
        calendar.select(second)
        configureVisibleCells()
    }
    
    @IBAction func openFilter(_ sender: Any) {
        self.delegate?.clickFilter()
    }

    @IBAction func collapsedCalendar(_ sender: Any) {
        self.delegate?.collapsedCalendar()
    }
}

extension CalendarCell: FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }

    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }

    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return nil
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    }

    // MARK: - FSCalendarDelegate

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height

    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }

    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        if calendar.selectedDates.count == 3 {
            for date in calendar.selectedDates {
                calendar.deselect(date)
            }
            calendar.select(date)
        }

        if calendar.selectedDates.count == 1 {
            let date = calendar.selectedDates[0]
            self.startDate = date.fullDateString
            self.lblTime.text = "\(startDate) > \(startDate)"
        }

        if calendar.selectedDates.count == 2 {
            var first = calendar.selectedDates[0]
            var second = calendar.selectedDates[1]
            if second <= first {
                let temp = first
                first = second
                second = temp
            }
            self.startDate = first.fullDateString
            self.endDate = second.fullDateString
            self.lblTime.text = "\(self.startDate) > \(self.endDate)"
        }
        self.configureVisibleCells()
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }

    // MARK: - Private functions

    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }

    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        guard let diyCell = (cell as? DateCalendarCell) else {return}
        diyCell.circleImageView.isHidden = true
        if position == .current {
            var selectionType = SelectionType.none
            if calendar.selectedDates.count == 2 {
                var first = calendar.selectedDates[0]
                var second = calendar.selectedDates[1]
                if second <= first {
                    let temp = first
                    first = second
                    second = temp
                }
                if date == first {
                    selectionType = .leftBorder
                } else if date == second {
                    selectionType = .rightBorder
                } else if date >= first && date <= second {
                    selectionType = .middle
                }
            } else {
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.count == 1 {
                        selectionType = .single
                    } else {
                        selectionType = .none
                    }
                } else {
                    selectionType = .none
                }
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
        } else {
            diyCell.selectionLayer.isHidden = true
            diyCell.titleLabel.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        }
    }
}

