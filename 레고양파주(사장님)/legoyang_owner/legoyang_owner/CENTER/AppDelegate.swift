//
//  AppDelegate.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/11/14.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import FirebaseFirestore
import FirebaseDatabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
// MARK: FIREBASE -------------------------------------------------------
    
    let GCM_KEY = "gcm.message_id"
    
    var REAL_REF: DatabaseReference!
    var STORE_REF: DatabaseReference!
    
    var LISTENER: ListenerRegistration!
    
// MARK: APPDELEGATE ----------------------------------------------------
    
    var WINDOW: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var STORYBOARD: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var SWIPE_GESTURE: Bool = false
    
    var OBJ_VERSION: API_VERSION = API_VERSION()
    var OBJ_USER: [API_USER] = []
    var OBJ_STORE: [API_USER] = []
    
    var AppObject: AppData = AppData()
    var StoreObject: [StoreData] = []
    var row: Int = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UserDefaults.standard.setValue(true, forKey: "first")
//        UserDefaults.standard.setValue("01031870005", forKey: "store_id")
        
        LISTENER = nil
        
        DF.locale = Locale(identifier: "ko_kr"); DF.timeZone = TimeZone(identifier: "Asia/Seoul"); DF.dateFormat = "yyyy-MM-dd HH:mm:ss"
        NF.numberStyle = .decimal
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, Error in })
        application.registerForRemoteNotifications()
        
        REAL_REF = Database.database().reference()
        STORE_REF = Database.database().reference()
        
        let VC = STORYBOARD.instantiateViewController(withIdentifier: "VC_LOADING") as! VC_LOADING
        let NC = UINavigationController(rootViewController: VC)
        NC.setNavigationBarHidden(true, animated: true)
        WINDOW?.rootViewController = NC; WINDOW?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        WINDOW?.endEditing(true)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        Firestore.firestore().collection("app").document("ios").getDocument { response, error in
            
            guard let response = response else { return }
            
            let dict = response.data() ?? [:]
            
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
            let appBuildCode = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1") ?? 1
            let storeVersion = dict["version_name"] as? String ?? ""
            let storeBuildCode = Int(dict["version_code"] as? String ?? "") ?? 1
            
            print("version - 앱: \(appVersion)(\(appBuildCode)) / 스토어: \(storeVersion)(\(storeBuildCode))")
            
            if let delegate = UIViewController.TabBarControllerDelegate {
                
                if storeBuildCode > appBuildCode {
                    
                    let alert = UIAlertController(title: "소프트웨어 업데이트", message: "레고양파주 파트너 \(storeVersion)을(를) 사용자의 iPhone에서 사용할 수 있으며 설치할 준비가 되었습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "지금 설치", style: .default, handler: { _ in
                        UIApplication.shared.open(URL(string: UIViewController.appDelegate.AppObject.versionUrl)!) { success in
                            if success { exit(0) }
                        }
                    }))
                    delegate.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

