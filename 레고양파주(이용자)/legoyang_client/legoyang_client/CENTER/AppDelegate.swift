//
//  AppDelegate.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/13.
//

import UIKit
import AVKit
import CoreLocation
import FirebaseCore
import FirebaseMessaging
import FirebaseFirestore
import FirebaseDatabase
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
// MARK: CORELOCATION ---------------------------------------------------
    
    let APP = UIApplication.shared
    var TASK_ID = UIBackgroundTaskIdentifier.invalid
    var LOC_MANAGER = CLLocationManager()
    
// MARK: FIREBASE -------------------------------------------------------
    
    let GCM_KEY = "gcm.message_id"
    
    var REAL_REF: DatabaseReference!
    var STORE_REF: DatabaseReference!
    
    var listener: ListenerRegistration?
    
// MARK: APPDELEGATE ----------------------------------------------------
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var backSwipeGesture: Bool = false
    
    var PUSH: Int = 0
    var LOGIN: Bool = false
    
    var OBJ_MAIN: API_MAIN = API_MAIN()
    var OBJ_PANGPANG: [API_STORE] = []
    var OBJ_USER: API_USER = API_USER()
    var OBJ_VIRTUAL_USER: API_VIRTUAL_USER = API_VIRTUAL_USER()
    
    var appVersion: String = "1.0"
    var appBuildCode: Int = 1
    var storeVersion: String = "1.0"
    var storeBuildCode: Int = 1
    
    var first: Bool = true
    var pushUpdate: String = "default"
    var pushData: String = ""
    var shareType: String = "default"
    var shareId: String = ""
    var shareData: [String: Any] = [:]
    var noticeCount: Int = 0
    var MemberId: String = ""
    
    var SignupObject: [String: Any] = [:]
    var AppLegoObject: AppLegoData = AppLegoData()
    var MemberObject: MemberData = MemberData()
    var MemberPangpangHistoryObject: [MemberPangpangHistoryData] = []
    var MainPangpangStoreObject: [StoreData] = []
    var MainLegongguObject: [LegongguData] = []
    var CategoryObject: [CategoryData] = []
    var StoreObject: [StoreData] = []
    var LegongguObject: [LegongguData] = []
    var LegongguOptionObject: [LegongguData] = []
    var NoticeListObject: [NoticeListData] = []
    
    var VC = UIViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UserDefaults.standard.removeObject(forKey: "apple_id")
        
        NF.numberStyle = .decimal
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, Error in })
        application.registerForRemoteNotifications()
        
        let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] ?? [:]
        let type = userInfo["type"] as? String ?? ""
        let customData = userInfo["customData"] as? String ?? ""
        
        if (type == "inform_gonggu_ios") || (type == "gonggu_test_ios") {
            UIViewController.appDelegate.pushUpdate = "gonggu"
        } else if (type == "legopangpang_ios") || (type == "around_test_ios") {
            UIViewController.appDelegate.pushUpdate = "around"
            UIViewController.appDelegate.pushData = customData
        }
        
        REAL_REF = Database.database().reference()
        STORE_REF = Database.database().reference()
        
        let VC = storyboard.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
        let NC = UINavigationController(rootViewController: VC)
        NC.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = NC; window?.makeKeyAndVisible()
        
        setNaverAPI()
        setKakaoAPI()
        
        let audioSession = AVAudioSession.sharedInstance()
        do { try audioSession.setCategory(.playback) } catch { }
        
        return true
    }
    
    func setNaverAPI() {
        if let instance = NaverThirdPartyLoginConnection.getSharedInstance() {
            instance.isNaverAppOauthEnable = true
            instance.isInAppOauthEnable = true
            instance.consumerKey = "juuyajZZhVPrjOLEmHjc"
            instance.consumerSecret = "B9uPItQSqU"
            instance.appName = "레고양파주"
            instance.serviceUrlScheme = "naverjuuyajZZhVPrjOLEmHjc"
        }
    }
    
    func setKakaoAPI() {
        KakaoSDK.initSDK(appKey: "dd4152baa6283c2d8745bb850f1dc102")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 네이버
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        // 카카오
        if AuthApi.isKakaoTalkLoginUrl(url) { return AuthController.handleOpenUrl(url: url) }
        
        if "\(url)".contains("kakao") {
            
            print("\(url)")
            
            let dict = url.params() ?? [:]
            
            let type = dict["type"] as? String ?? ""
            if type == "store" {
                shareType = type; shareId = dict["store_id"] as? String ?? ""
            } else if type == "legonggu" {
                shareType = type; shareId = dict["item_name"] as? String ?? ""
            } else if type == "event" {
                shareType = type; shareId = dict["event_id"] as? String ?? ""
                shareData = [
                    "recommender": dict["recommender"] as? String ?? "",
                    "code": dict["code"] as? String ?? "",
                    "type": dict["type"] as? String ?? "",
                    "event_id": dict["event_id"] as? String ?? "",
                    "inviter_from": dict["inviter_from"] as? String ?? "",
                    "inviter_code": dict["inviter_code"] as? String ?? "",
                    "coupon_type": dict["coupon_type"] as? String ?? "",
                ]
            } else {
                shareType = "default"; shareId = ""; shareData.removeAll()
            }
            
            if let delegate = UIViewController.TabBarControllerDelegate {
                delegate.shareLoadingData()
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        window?.endEditing(true)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        if first { return }
        
        Firestore.firestore().collection("app_lego").document("ios").getDocument { response, error in
            
            guard let response = response else { return }
            
            let dict = response.data() ?? [:]
            
            UIViewController.appDelegate.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
            UIViewController.appDelegate.appBuildCode = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1") ?? 1
            UIViewController.appDelegate.storeVersion = dict["version_name"] as? String ?? "1.0"
            UIViewController.appDelegate.storeBuildCode = Int(dict["version_code"] as? String ?? "1") ?? 1
            
            print("version - 앱: \(self.appVersion)(\(self.appBuildCode)) / 스토어: \(self.storeVersion)(\(self.storeBuildCode))")
            
            if let delegate = UIViewController.TabBarControllerDelegate {
                
                if self.storeBuildCode > self.appBuildCode {
                    
                    let alert = UIAlertController(title: "소프트웨어 업데이트", message: "레고양파주 \(self.storeVersion)을(를) 사용자의 iPhone에서 사용할 수 있으며 설치할 준비가 되었습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "지금 설치", style: .default, handler: { _ in
                        UIApplication.shared.open(URL(string: UIViewController.appDelegate.AppLegoObject.versionUrl)!) { success in
                            if success { exit(0) }
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "나중에 설치", style: .cancel, handler: nil))
                    delegate.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        if let refresh = UIViewController.LoadingViewControllerDelegate {
            refresh.loadingData(mainUpdate: true, popup: true)
        }
        if let refresh_1 = UIViewController.LegongguViewControllerDelegate {
            refresh_1.gridView.reloadData()
        }
    }
}

