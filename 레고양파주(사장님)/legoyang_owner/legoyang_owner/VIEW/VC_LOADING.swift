//
//  VC_LOADING.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/11/15.
//

import UIKit
import FirebaseFirestore

class VC_LOADING: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var UPDATE: String = ""
    var STORE: Double = 1.0
    let APP: Double = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? Double ?? 1.0
    
    override func loadView() {
        super.loadView()
        
//        /// 5만원 충전
//        Firestore.firestore().collection("store").getDocuments { snapshot, error in
//            snapshot?.documents.enumerated().forEach({ i, document in
//                Firestore.firestore().collection("store").document(document.documentID).updateData(["store_cash": "50000"])
//            })
//        }
        
        if (UserDefaults.standard.string(forKey: "store_id") ?? "") == "" {
            UIViewController.AD.OBJ_USER.removeAll()
            UIViewController.AD.OBJ_STORE.removeAll()
            UserDefaults.standard.setValue(true, forKey: "first")
            UserDefaults.standard.removeObject(forKey: "fcm_id")
            UserDefaults.standard.removeObject(forKey: "store_id")
            UserDefaults.standard.removeObject(forKey: "store_category")
            UserDefaults.standard.removeObject(forKey: "payment_agree")
            UserDefaults.standard.removeObject(forKey: "waiting_step")
            UserDefaults.standard.removeObject(forKey: "use_pangpang")
            UserDefaults.standard.removeObject(forKey: "option_ad_term")
            UserDefaults.standard.removeObject(forKey: "option_privacy_term")
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.appDelegate.LISTENER = nil
        UIViewController.LoadingViewControllerDelegate = self
        
        loadingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false) 
    }
}
