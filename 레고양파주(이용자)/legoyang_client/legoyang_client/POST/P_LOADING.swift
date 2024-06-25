//
//  P_LOADING.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/13.
//

import UIKit
import FirebaseFirestore
import FirebaseMessaging

extension UIViewController {
    
    func GET_LOADING(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        Firestore.firestore().collection(AC_TYPE).document("ios").getDocument() { response, error in
            
            if let response = response {
                // 데이터 삭제
                UIViewController.appDelegate.OBJ_MAIN = API_MAIN(APP_CHECK: "", CHECK_CONTENT: "", ENABLE_ID: true, MAIN_CONTENTS: [], MAINLEGO_IMG: "", RATE_1_1: [], RATE_21_9: [], RATE_3_4: [], RATE_TITLE: [], TIMESTAMP: "", URL: "", VERSION_CODE: "", VERSION_NAME: "")
                UIViewController.appDelegate.OBJ_PANGPANG.removeAll()
                
                let DICT = response.data()
                let AP_VALUE = API_MAIN(
                    APP_CHECK: DICT?["app_check"] as? String ?? "",
                    CHECK_CONTENT: DICT?["check_content"] as? String ?? "",
                    COMMUNITY: self.SET_COMMUNITY(ARRAY: DICT?["community"] as? [Any] ?? []),
                    ENABLE_ID: DICT?["enable_id"] as? Bool ?? false,
                    MAIN_CONTENTS: self.SET_MAIN_CONTENTS(ARRAY: DICT?["main_contents"] as? [Any] ?? []),
                    MAINLEGO_IMG: DICT?["mainlego_img"] as? String ?? "",
                    RATE_1_1: self.SET_MAIN_CONTENTS(ARRAY: DICT?["rate_1_1"] as? [Any] ?? []),
                    RATE_21_9: self.SET_MAIN_CONTENTS(ARRAY: DICT?["rate_21_9"] as? [Any] ?? []),
                    RATE_3_4: self.SET_MAIN_CONTENTS(ARRAY: DICT?["rate_3_4"] as? [Any] ?? []),
                    RATE_TITLE: DICT?["rate_title"]as? [String] ?? [],
                    TIMESTAMP: DICT?["timestamp"] as? String ?? "",
                    URL: DICT?["url"] as? String ?? "",
                    VERSION_CODE: DICT?["version_code"] as? String ?? "",
                    VERSION_NAME: DICT?["version_name"] as? String ?? ""
                )
                // 데이더 추가
                UIViewController.appDelegate.OBJ_MAIN = AP_VALUE
            }; if UserDefaults.standard.bool(forKey: "first") { self.segueTabBarController(identifier: "TBC", idx: 2); if UserDefaults.standard.string(forKey: "member_id") ?? "" != "" { self.GET_LOGIN2(NAME: "로그인", AC_TYPE: "member") } }
            
            if let RVC1 = UIViewController.LoginViewController_DEL { RVC1.loadView2() }
            if let RVC2 = UIViewController.VC_MAIN_DEL { RVC2.NOTICE_V.isHidden = true; RVC2.loadView2() }
            if let RVC3 = UIViewController.VC_MORE_DEL { RVC3.loadView2(); RVC3.TABLEVIEW.reloadData() }
            
            self.GET_LOADING2(NAME: "오늘의 추천가게", AC_TYPE: "store")
        }
    }
    
    func SET_COMMUNITY(ARRAY: [Any]) -> [API_COMMUNITY] {
        
        var OBJ_COMMUNITY: [API_COMMUNITY] = []
        
        for (_, DATA) in ARRAY.enumerated() {
            
            let DICT = DATA as? [String: Any]
            let AP_VALUE = API_COMMUNITY()
            
            AP_VALUE.SET_DATE(DATE: DICT?["date"] as Any)
            AP_VALUE.SET_LIKE(LIKE: DICT?["like"] as Any)
            AP_VALUE.SET_TITLE(TITLE: DICT?["title"] as Any)
            AP_VALUE.SET_URL(URL: DICT?["url"] as Any)
            AP_VALUE.SET_VIEW(VIEW: DICT?["view"] as Any)
            AP_VALUE.SET_WRITER(WRITER: DICT?["writer"] as Any)
            // 데이터 추가
            OBJ_COMMUNITY.append(AP_VALUE)
        }
        
        return OBJ_COMMUNITY
    }
    
    func SET_MAIN_CONTENTS(ARRAY: [Any]) -> [API_MAIN_CONTENTS] {
        
        var OBJ_MAIN_CONTENTS: [API_MAIN_CONTENTS] = []
        
        for (_, DATA) in ARRAY.enumerated() {
            
            let DICT = DATA as? [String: Any]
            let AP_VALUE = API_MAIN_CONTENTS()
            
            AP_VALUE.SET_TYPE(TYPE: DICT?["type"] as Any)
            AP_VALUE.SET_URL(URL: DICT?["url"] as Any)
            AP_VALUE.SET_LINK_URL(LINK_URL: DICT?["link_url"] as Any)
            AP_VALUE.SET_STORE_ID(STORE_ID: DICT?["store_id"] as Any)
            AP_VALUE.SET_STORE_NAME(STORE_NAME: DICT?["store_name"] as Any)
            // 데이터 추가
            OBJ_MAIN_CONTENTS.append(AP_VALUE)
        }
        
        return OBJ_MAIN_CONTENTS
    }
    
    func GET_LOADING2(NAME: String, AC_TYPE: String) {
        
        Firestore.firestore().collection(AC_TYPE).order(by: "use_item_time", descending: true).limit(to: 100).getDocuments { response, error in
            
            if let response = response {
                
                for response in response.documents {
                    
                    let DICT = response.data()
                    let AP_VALUE = API_STORE()
                    
                    AP_VALUE.SET_ST_ID(ST_ID: DICT["store_id"] as Any)
                    AP_VALUE.SET_ST_IMAGE(ST_IMAGE: DICT["store_img"] as Any)
                    AP_VALUE.SET_ST_IMAGES(ST_IMAGES: DICT["img_array"] as Any)
                    AP_VALUE.SET_PP_REMAIN(PP_REMAIN: DICT["pangpang_remain"] as Any)
                    AP_VALUE.SET_USE_ITEM_TIME(USE_ITEM_TIME: DICT["use_item_time"] as Any)
                    // 데이터 추가
                    if UIViewController.appDelegate.OBJ_PANGPANG.count <= 15 && (DICT["use_pangpang"] as? String ?? "false" == "true") { UIViewController.appDelegate.OBJ_PANGPANG.append(AP_VALUE) }
                }
                
                if let RVC1 = UIViewController.VC_MAIN_DEL { RVC1.TABLEVIEW.reloadData() }
            }
        }
    }
}

// var <#name#>: String = ""
// func SET_<#name#>(<#name#>: Any) { self.<#name#> = <#name#> as? String ?? "" }

struct API_MAIN {
    
    var APP_CHECK: String = ""
    var CHECK_CONTENT: String = ""
    var COMMUNITY: [API_COMMUNITY] = []
    var ENABLE_ID: Bool = false
    var MAIN_CONTENTS: [API_MAIN_CONTENTS] = []
    var MAINLEGO_IMG: String = ""
    var RATE_1_1: [API_MAIN_CONTENTS] = []
    var RATE_21_9: [API_MAIN_CONTENTS] = []
    var RATE_3_4: [API_MAIN_CONTENTS] = []
    var RATE_TITLE: [String] = []
    var TIMESTAMP: String = ""
    var URL: String = ""
    var VERSION_CODE: String = ""
    var VERSION_NAME: String = ""
}

class API_COMMUNITY {
    
    var DATE: String = ""
    var LIKE: String = ""
    var TITLE: String = ""
    var URL: String = ""
    var VIEW: String = ""
    var WRITER: String = ""
    
    func SET_DATE(DATE: Any) { self.DATE = DATE as? String ?? "" }
    func SET_LIKE(LIKE: Any) { self.LIKE = LIKE as? String ?? "" }
    func SET_TITLE(TITLE: Any) { self.TITLE = TITLE as? String ?? "" }
    func SET_URL(URL: Any) { self.URL = URL as? String ?? "" }
    func SET_VIEW(VIEW: Any) { self.VIEW = VIEW as? String ?? "" }
    func SET_WRITER(WRITER: Any) { self.WRITER = WRITER as? String ?? "" }
}

class API_MAIN_CONTENTS {
    
    var TYPE: String = ""
    var URL: String = ""
    var LINK_URL: String = ""
    var STORE_ID: String = ""
    var STORE_NAME: String = ""
    
    func SET_TYPE(TYPE: Any) { self.TYPE = TYPE as? String ?? "" }
    func SET_URL(URL: Any) { self.URL = URL as? String ?? "" }
    func SET_LINK_URL(LINK_URL: Any) { self.LINK_URL = LINK_URL as? String ?? "" }
    func SET_STORE_ID(STORE_ID: Any) { self.STORE_ID = STORE_ID as? String ?? "" }
    func SET_STORE_NAME(STORE_NAME: Any) { self.STORE_NAME = STORE_NAME as? String ?? "" }
}

extension UIViewController {
    
    func GET_LOGIN2(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).setData(["fcm_id": UserDefaults.standard.string(forKey: "fcm_id") ?? ""], merge: true)
        UIViewController.appDelegate.listener = Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).addSnapshotListener { response, error in
            
            if let response = response {
                // 데이터 삭제
                UIViewController.appDelegate.OBJ_USER = API_USER(BENEFIT_POINT: "0", DELIVERY_ADDRESS: [], FCM_ID: "", FREE_DELIVERY_COUPON: 0, GRADE: "", ID: "", LAT: "", LEGONGGU_TOPIC: "false", LON: "", MYLIKE_STORE: [], NAME: "", NICK: "", NOTI_LIST: [], PASSWORD: "", NUMBER: "", PANGPANG_TOPIC: "false", PLATFORM: "", POINT: "0", PROFILE_IMG: "", SECESSION: "", SIGNUP_TIME: "")
                
                let DICT = response.data()
                let AP_VALUE = API_USER(
                    BENEFIT_POINT: DICT?["benefit_point"] as? String ?? "",
                    DELIVERY_ADDRESS: DICT?["delivery_address"] as? [String] ?? [],
                    FCM_ID: DICT?["fcm_id"] as? String ?? "",
                    FREE_DELIVERY_COUPON: DICT?["free_delivery_coupon"] as? Int ?? 0,
                    GRADE: DICT?["grade"] as? String ?? "",
                    ID: DICT?["id"] as? String ?? "",
                    LAT: DICT?["lat"] as? String ?? "",
                    LEGONGGU_TOPIC: DICT?["legonggu_topic"] as? String ?? "",
                    LON: DICT?["lon"] as? String ?? "",
                    MYLIKE_STORE: DICT?["mylike_store"] as? [String] ?? [],
                    NAME: DICT?["name"] as? String ?? "",
                    NICK: DICT?["nick"] as? String ?? "",
                    NOTI_LIST: self.SET_NOTI_LIST(ARRAY: [DICT?["noti_list"]] as? [Any] ?? []),
                    PASSWORD: DICT?["password"] as? String ?? "",
                    NUMBER: DICT?["number"] as? String ?? "",
                    PANGPANG_TOPIC: DICT?["pangpang_topic"] as? String ?? "",
                    PLATFORM: DICT?["platform"] as? String ?? "",
                    POINT: DICT?["point"] as? String ?? "",
                    PROFILE_IMG: DICT?["profile_img"] as? String ?? "",
                    SECESSION: DICT?["secession"] as? String ?? "",
                    SIGNUP_TIME: DICT?["signup_time"] as? String ?? ""
                )
                if DICT?["pangpang_topic"] as? String ?? "" == "true" {
                    Messaging.messaging().subscribe(toTopic: "legopangpang_ios")
                    // 테스트 푸시
                    if UserDefaults.standard.string(forKey: "member_id") ?? "" == "01031870005" || UserDefaults.standard.string(forKey: "member_id") ?? "" == "01031853309" {
                        Messaging.messaging().subscribe(toTopic: "around_test")
                    }
                } else {
                    Messaging.messaging().unsubscribe(fromTopic: "legopangpang_ios")
                    Messaging.messaging().unsubscribe(fromTopic: "around_test")
                }
                // 데이터 추가
                UIViewController.appDelegate.OBJ_USER = AP_VALUE
            }
            
            if UIViewController.appDelegate.OBJ_USER.SECESSION != "" { self.segueViewController(identifier: "LoginAAViewController"); return }
            
            if let RVC1 = UIViewController.VC_MAIN_DEL {
                if UserDefaults.standard.string(forKey: "member_id") ?? "" != "" {
                    for DATA in UIViewController.appDelegate.OBJ_USER.NOTI_LIST { if DATA.READORNOT == "false" { RVC1.NOTICE_V.isHidden = false } }
                    if UIViewController.appDelegate.OBJ_USER.PROFILE_IMG != "" {
                        RVC1.NUKE(IV: RVC1.USER_I, IU: UIViewController.appDelegate.OBJ_USER.PROFILE_IMG, RD: 10, CM: .scaleAspectFill)
                    } else {
                        RVC1.USER_I.image = UIImage(named: "my"); RVC1.USER_I.layer.cornerRadius = 10
                    }; RVC1.USER_I.backgroundColor = .H_F4F4F4
                } else {
                    RVC1.USER_I.backgroundColor = .clear
                }
            }
            if let RVC2 = UIViewController.VC_NOTICE_DEL { RVC2.TABLEVIEW.reloadData() }
            if let RVC3 = UIViewController.VC_MORE_DEL { RVC3.loadView2() }
//            if let RVC4 = UIViewController.SettingViewControllerDelegate {
//                if UIViewController.appDelegate.OBJ_USER.LEGONGGU_TOPIC == "true" { RVC4.PUSH0[1] = true } else { RVC4.PUSH0[1] = false }
//                if UIViewController.appDelegate.OBJ_USER.PANGPANG_TOPIC == "true" { RVC4.PUSH0[2] = true } else { RVC4.PUSH0[2] = false }
//                RVC4.TABLEVIEW.reloadData()
//            }
            
            if UIViewController.appDelegate.PUSH == 1 {
                UIViewController.TabBarControllerDelegate? .segueViewController(identifier: "VC_AROUND")
            } else if UIViewController.appDelegate.PUSH == 3 {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "VC_COUPON") as! VC_COUPON
                VC.POSITION = 1
                UIViewController.TabBarControllerDelegate? .navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
    
    func SET_NOTI_LIST(ARRAY: [Any]) -> [API_NOTI_LIST] {
        
        var OBJ_NOTI_LIST: [API_NOTI_LIST] = []
        
        for (_, DATA) in ARRAY.enumerated() {
            
            let _: [()] = (DATA as? [String: Any] ?? [:]).compactMap({ (key: String, value: Any) in
                
                let DICT = (DATA as? [String: Any] ?? [:])[key] as? [String: Any]
                let AP_VALUE = API_NOTI_LIST()
                
                AP_VALUE.SET_BODY(BODY: DICT?["body"] as Any)
                AP_VALUE.SET_DATA(DATA: DICT?["data"] as Any)
                AP_VALUE.SET_READORNOT(READORNOT: DICT?["readornot"] as Any)
                AP_VALUE.SET_RECEIVE_TIME(RECEIVE_TIME: DICT?["receive_time"] as Any)
                AP_VALUE.SET_TIMESTAMP(TIMESTAMP: key as Any)
                AP_VALUE.SET_TITLE(TITLE: DICT?["title"] as Any)
                AP_VALUE.SET_TYPE(TYPE: DICT?["type"] as Any)
                // 데이터 추가
                OBJ_NOTI_LIST.append(AP_VALUE)
            }); OBJ_NOTI_LIST.sort { front, behind in Int(front.TIMESTAMP) ?? 0 > Int(behind.TIMESTAMP) ?? 0 }
        }
        
        return OBJ_NOTI_LIST
    }
}

