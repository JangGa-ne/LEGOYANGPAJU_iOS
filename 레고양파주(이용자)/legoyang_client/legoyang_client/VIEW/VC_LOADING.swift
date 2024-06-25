//
//  VC_LOADING.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/13.
//

import UIKit

class VC_LOADING: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var STORE: Double = 1.0
    let APP: Double = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? Double ?? 1.0
    
    override func loadView() {
        super.loadView()
        
        UserDefaults.standard.setValue(true, forKey: "first"); UIViewController.appDelegate.listener?.remove()
        
        // 초기화
        UIViewController.appDelegate.listener = nil
        UIViewController.appDelegate.OBJ_MAIN = API_MAIN(APP_CHECK: "", CHECK_CONTENT: "", ENABLE_ID: true, MAIN_CONTENTS: [], MAINLEGO_IMG: "", RATE_1_1: [], RATE_21_9: [], RATE_3_4: [], RATE_TITLE: [], TIMESTAMP: "", URL: "", VERSION_CODE: "", VERSION_NAME: "")
        UIViewController.appDelegate.OBJ_USER = API_USER(BENEFIT_POINT: "0", DELIVERY_ADDRESS: [], FCM_ID: "", FREE_DELIVERY_COUPON: 0, GRADE: "", ID: "", LAT: "", LEGONGGU_TOPIC: "false", LON: "", MYLIKE_STORE: [], NAME: "", NICK: "", NOTI_LIST: [], PASSWORD: "", NUMBER: "", PANGPANG_TOPIC: "false", PLATFORM: "", POINT: "0", PROFILE_IMG: "", SECESSION: "", SIGNUP_TIME: "")
        
        GET_LOADING(NAME: "초기정보", AC_TYPE: "app_lego")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}
