//
//  AppDelegate+Push.swift
//  MobileAppSourceCodeV1
//
//  Created by Kaushal Chaudhary on 27/10/23.
//

import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging

final class PushNotification: NSObject, UIApplicationDelegate,UNUserNotificationCenterDelegate  {
    private override init() {
        super.init()
    }
    static var shared = PushNotification()
    var fcmToken: String?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerForPushNotifications()
        return true
    }
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // 1. Check to see if permission is granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
}
extension PushNotification: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        self.fcmToken = fcmToken
    }
}
