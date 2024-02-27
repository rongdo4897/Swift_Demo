//
//  AppDelegate.swift
//  PushNotification-Firebase
//
//  Created by Lam Hoang Tung on 2/27/24.
//
import Firebase
import FirebaseMessaging
import UserNotifications
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
            guard success else {
                return
            }
            
            print("Success in APNS registry")
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token else {
                return
            }
            
            print("Token - ", token)
        }
    }
}
