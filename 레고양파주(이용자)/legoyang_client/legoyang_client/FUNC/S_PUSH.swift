//
//  S_PUSH.swift
//  legoyang
//
//  Created by 장 제현 on 2022/10/09.
//

import UIKit
import UserNotifications
import FirebaseMessaging

// MARK: PUSH 설정
extension UIViewController {
    
    func LOCALPUSH(TITLE: String, BODY: String, USERINFO: [String: Any] = [:]) {
        
        let CHECK_CONTENT = UNMutableNotificationContent()
        CHECK_CONTENT.title = TITLE
        CHECK_CONTENT.body = BODY
        CHECK_CONTENT.sound = .default
        CHECK_CONTENT.userInfo = USERINFO
        
        let TRIGGER = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let REQUEST = UNNotificationRequest(identifier: "local_notification", content: CHECK_CONTENT, trigger: TRIGGER)
        UNUserNotificationCenter.current().add(REQUEST)
    }
    
    func setReviewPush(pushId: String, title: String, body: String, userInfo: [String: Any] = [:]) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = userInfo
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)
        let request = UNNotificationRequest(identifier: pushId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: PUSH 알림 설정
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // PUSH(포그라운드) 받음
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let USERINFO = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(USERINFO)
        
        if let MESSAGE_ID = USERINFO[GCM_KEY] { print("알림 받음 MESSAGE ID: \(MESSAGE_ID)") }
        
        print("알림 받음 userNotificationCenter", USERINFO)
        
        completionHandler([.alert, .sound, .badge])
    }
    
    // PUSH(포그라운드) 누름
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let MESSAGE_ID = userInfo[GCM_KEY] { print("알림 받음 MESSAGE ID: \(MESSAGE_ID)") }
        
        print("알림 누름 userNotificationCenter", userInfo)
        
        let type = userInfo["type"] as? String ?? ""
        let customData = userInfo["customData"] as? String ?? ""
        
        if let delegate = UIViewController.TabBarControllerDelegate {
            if (type == "inform_gonggu_ios") || (type == "gonggu_test_ios") {
                UIViewController.appDelegate.pushUpdate = "gonggu"
            } else if (type == "legopangpang_ios") || (type == "around_test_ios") {
                UIViewController.appDelegate.pushUpdate = "around"
                UIViewController.appDelegate.pushData = customData
            } else if type == "use_coupon_ios" {
                UIViewController.appDelegate.pushUpdate = "coupon"
            }
            delegate.pushLoadingData()
        } else if type == "use_coupon_ios" {
            UIViewController.appDelegate.pushUpdate = "coupon"
        }
        
        if let delegate = UIViewController.TutorialViewControllerDelegate { delegate.dismiss(animated: false, completion: nil) }
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("Firebase registration token: \(fcmToken ?? "-")")
        
        UserDefaults.standard.setValue("\(fcmToken ?? "-")", forKey: "fcm_id")

        let DATADICT: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: DATADICT)
    }
}

extension AppDelegate {

    // PUSH(서스펜드) 누름
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        Messaging.messaging().appDidReceiveMessage(userInfo)

        completionHandler(.newData)
    }
}
