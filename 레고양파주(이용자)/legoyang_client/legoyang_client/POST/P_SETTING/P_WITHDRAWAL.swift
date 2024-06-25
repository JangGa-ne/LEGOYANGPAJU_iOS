//
//  P_WITHDRAWAL.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2023/01/03.
//

import UIKit
import FirebaseFirestore
import FirebaseMessaging

extension VC_WITHDRAWAL {
    
    func PUT_WITHDRAWAL(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        Firestore.firestore().collection("member").document(MEMBER_ID).setData(["secession": "\(setKoreaTimestamp()))+259200000)"], merge: true)
        
        self.S_NOTICE("회원탈퇴 요청함")
        // 데이터 초기화
        UIViewController.appDelegate.listener?.remove()
        UserDefaults.standard.setValue(true, forKey: "first")
        UserDefaults.standard.removeObject(forKey: "fcm_id")
        UserDefaults.standard.removeObject(forKey: "member_id")
        UserDefaults.standard.removeObject(forKey: "phonecheck")
        UserDefaults.standard.removeObject(forKey: "emailcheck")
        Messaging.messaging().unsubscribe(fromTopic: "legopangpang_ios")
        Messaging.messaging().unsubscribe(fromTopic: "around_test_ios")
        Messaging.messaging().unsubscribe(fromTopic: "inform_gonggu_ios")
        Messaging.messaging().unsubscribe(fromTopic: "gonggu_test_ios")
        
        self.segueViewController(identifier: "LoadingViewController")
    }
}
