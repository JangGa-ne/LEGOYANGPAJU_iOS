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
    
    func LOCALPUSH(TITLE: String, BODY: String) {
        
        let CHECK_CONTENT = UNMutableNotificationContent()
        CHECK_CONTENT.title = TITLE
        CHECK_CONTENT.body = BODY
        CHECK_CONTENT.sound = .default
        
        let TRIGGER = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let REQUEST = UNNotificationRequest(identifier: "local_notification", content: CHECK_CONTENT, trigger: TRIGGER)
        UNUserNotificationCenter.current().add(REQUEST)
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
        
        let USERINFO = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(USERINFO)
        
        if let MESSAGE_ID = USERINFO[GCM_KEY] { print("알림 받음 MESSAGE ID: \(MESSAGE_ID)") }
        
        print("알림 누름 userNotificationCenter", USERINFO)
        
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
        
        let VC = STORYBOARD.instantiateViewController(withIdentifier: "VC_LOADING") as! VC_LOADING
        let NC = UINavigationController(rootViewController: VC)
        NC.setNavigationBarHidden(true, animated: true)
        WINDOW?.rootViewController = NC
        
        completionHandler(.newData)
    }
}
