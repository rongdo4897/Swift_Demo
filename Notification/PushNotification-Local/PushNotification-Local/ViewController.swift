//
//  ViewController.swift
//  PushNotification-Local
//
//  Created by Lam Hoang Tung on 2/28/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
    }

    func checkPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { isAllow, _ in
                    if isAllow {
                        self.dispatchNotification()
                    }
                }
            default:
                return
            }
        }
    }
    
    func dispatchNotification() {
        let identifier = "my-notification"
        let title = "Time to work out"
        let body = "Don't be a lazzy little but!"
        // Chỉ định thời gian hiển thị vào lúc 17:47 hàng ngày
        let hour = 17
        let minute = 47
        let isDaily = true

        let notificationCenter = UNUserNotificationCenter.current()
        
        // Thiết lập nội dung cho notification
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // Thiết lập lịch trình hiển thị
        let calendar = Calendar.current
        var dateComponent = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponent.hour = hour
        dateComponent.minute = minute
        
        // Tạo một trigger thông báo dựa trên lịch. Trong trường hợp này, trigger sẽ được kích hoạt vào một thời điểm nhất định được chỉ định bởi dateMatching và có thể lặp lại hàng ngày nếu isDaily được đặt thành true.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: isDaily)
        // Tạo một yêu cầu thông báo với một identifier (định danh) duy nhất, một content (nội dung) cho thông báo và một trigger (kích hoạt) đã được xác định trước. Khi yêu cầu này được đăng ký với UNUserNotificationCenter, thông báo sẽ được lên lịch và kích hoạt tại thời điểm được chỉ định.
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // loại bỏ các yêu cầu thông báo chưa được gửi đi và đang đợi để được gửi, sử dụng một danh sách các định danh (identifiers) đã cho.
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        // thêm một yêu cầu thông báo vào trung tâm thông báo của ứng dụng (UNUserNotificationCenter).
        notificationCenter.add(request)
    }
}

