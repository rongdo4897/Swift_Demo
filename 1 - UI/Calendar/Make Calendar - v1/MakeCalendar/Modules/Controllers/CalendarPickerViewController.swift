//
//  ViewController.swift
//  MakeCalendar
//
//  Created by Hoang Lam on 29/11/2021.
//

import UIKit

//MARK: - Outlet, Override
class CalendarPickerViewController: UIViewController {
    private var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.text = "Chọn thời gian"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.layer.borderWidth = 1.5
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 10
        return label
    }()
    
    private lazy var dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()
    
    private lazy var headerView = CalendarPickerHeaderView { [weak self] in
        guard let self = self else { return }
        
        self.hiddenDateComponent(isHidden: true)
    }
    
    private lazy var footerView = CalendarPickerFooterView(
        didTapLastMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            
            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: -1,
                to: self.baseDate
            ) ?? self.baseDate
        },
        didTapNextMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            
            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: 1,
                to: self.baseDate
            ) ?? self.baseDate
        }
    )

    
    private let calendar = Calendar(identifier: .gregorian)
    
    private lazy var dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "d"
      return dateFormatter
    }()
    private lazy var accessibilityDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
        return dateFormatter
    }()
    
    private lazy var days = generateDaysInMonth(for: selectedDate)
    private var numberOfWeeksInBaseDate: Int {
      calendar.range(of: .weekOfMonth, in: .month, for: selectedDate)?.count ?? 0
    }
    
    var baseDate = Date() {
        didSet {
            days = generateDaysInMonth(for: baseDate)
            collectionView.reloadData()
            headerView.baseDate = baseDate
        }
    }
    var selectedDate = Date() {
        didSet {
            label.text = accessibilityDateFormatter.string(from: selectedDate)
            days = generateDaysInMonth(for: selectedDate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
    }
}

//MARK: - Các hàm khởi tạo, Setup
extension CalendarPickerViewController {
    private func initComponents() {
        initLabel()
        initView()
        initCollectionView()
        initHeaderAndFooterColletionView()
    }
    
    private func initLabel() {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            label.heightAnchor.constraint(equalToConstant: 60),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
        
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel)))
        label.isUserInteractionEnabled = true
    }
    
    private func initView() {
        view.addSubview(dimmedBackgroundView)
        dimmedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dimmedBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor),
            dimmedBackgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            dimmedBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dimmedBackgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func initCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        CalendarDateCell.registerCellByClass(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func initHeaderAndFooterColletionView() {
        view.addSubview(headerView)
        view.addSubview(footerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 85),
            
            footerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        headerView.baseDate = baseDate
    }
}

//MARK: - Customize
extension CalendarPickerViewController {
    private func customizeComponents() {
        
    }
}

//MARK: - Action - Obj
extension CalendarPickerViewController {
    @objc private func tapLabel() {
        hiddenDateComponent(isHidden: false)
        collectionView.reloadData()
    }
}

//MARK: - Các hàm chức năng
extension CalendarPickerViewController {
    private func hiddenDateComponent(isHidden: Bool) {
        dimmedBackgroundView.isHidden = isHidden
        collectionView.isHidden = isHidden
        headerView.isHidden = isHidden
        footerView.isHidden = isHidden
    }
}

//MARK: - Các hàm chức năng - Date
extension CalendarPickerViewController {
    /// - Lấy dữ liệu tháng
    private func monthMetaData(for baseDate: Date) throws -> MonthMetaData {
        // numberOfDaysInMonth: Số ngày của tháng
        // firstDayOfMonth: Ngày đầu tiên của tháng
        guard let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count, let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate)) else {
            throw CalendarDataError.metadataGeneration
        }
        
        // firstDayWeekday: Ngày đầu tiên của tuần
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        return MonthMetaData(numberOfDays: numberOfDaysInMonth, firstDay: firstDayOfMonth, firstDayWeekday: firstDayWeekday)
    }
    
    /// - Khởi tạo ngày trong tháng
    func generateDaysInMonth(for baseDate: Date) -> [Day] {
        guard let metadata = try? monthMetaData(for: baseDate) else {
            preconditionFailure("Đã xảy ra lỗi khi khởi tạo siêu dữ liệu cho \(baseDate)")
        }
        
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        
        /*
         Nếu một tháng bắt đầu vào một ngày không phải Chủ nhật, bạn thêm vài ngày cuối cùng của tháng trước vào đầu. Điều này tránh khoảng trống trong hàng đầu tiên của tháng. Tại đây, bạn tạo một Range<Int>xử lý tình huống này. Ví dụ: nếu một tháng bắt đầu vào thứ Sáu, offsetInInitialRowsẽ thêm năm ngày nữa để tăng hàng. Sau đó, bạn chuyển đổi phạm vi này thành [Day], sử dụng map(_:).
         */
        var days: [Day] = (1 ..< (numberOfDaysInMonth + offsetInInitialRow)).map { day in
            // Kiểm tra xem ngày hiện tại trong vòng lặp nằm trong tháng hiện tại hay một phần của tháng trước.
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            // Tính phần bù day của ngày đầu tiên của tháng. Nếu day là của tháng trước, giá trị này sẽ là số âm.
            let dayOffset = isWithinDisplayedMonth ? (day - offsetInInitialRow) : -(offsetInInitialRow - day)
            
            return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
        }
        
        days += generateStartOfNextMonth(using: firstDayOfMonth)
        
        return days
    }
    
    /// - Tạo ngày
    private func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        
        // inSameDayAs: Ngày được lựa chọn
        return Day(
            date: date,
            number: dateFormatter.string(from: date) ,
            isSelect: calendar.isDate(date, inSameDayAs: self.selectedDate),
            isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }
    
    /// - Lấy ngày đầu tiên của tháng được hiển thị và trả về một mảng các đối tượng Day.
    private func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
        // Truy xuất ngày cuối cùng của tháng được hiển thị. Nếu điều này không thành công, bạn trả về một mảng trống.
        guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfDisplayedMonth) else {
            return []
        }
        
        // Tính số ngày thừa bạn cần để điền vào hàng cuối cùng của lịch. Ví dụ: nếu ngày cuối cùng của tháng là thứ bảy, kết quả bằng 0 và bạn trả về một mảng trống.
        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {return []}
        
        // Tạo một Phạm vi Int từ một đến giá trị của Ngày bổ sung, như trong phần trước. Sau đó, nó biến điều này thành một mảng Ngày. Lần này, createDay (offsetBy: for: isWithinDisplayedMonth:) thêm ngày hiện tại trong vòng lặp vào lastDayInMonth để tạo các ngày vào đầu tháng tiếp theo.
        let days: [Day] = (1 ... additionalDays).map {
            generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false)
        }
        
        return days
    }
}

//MARK: - Collection
extension CalendarPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = days[indexPath.row]
        guard let cell = CalendarDateCell.loadCell(collectionView, path: indexPath) as? CalendarDateCell else {return UICollectionViewCell()}
        cell.day = day
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.width / 7)
        let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = days[indexPath.row].date
        hiddenDateComponent(isHidden: true)
    }
}
