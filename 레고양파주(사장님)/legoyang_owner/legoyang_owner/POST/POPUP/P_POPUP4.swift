//
//  P_POPUP4.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/27.
//

import UIKit
import FirebaseFirestore

extension VC_POPUP4 {
    
    func SET_PASSWORD(NAME: String, AC_TYPE: String) {
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(STORE_ID).setData(["store_password": PW_TF3.text!], merge: true) { error in
            
            if let _ = error {
                self.S_NOTICE("오류 (!)")
            } else {
                self.S_NOTICE("비밀번호 변경됨")
                
                self.dismiss(animated: true) {
                    
                    if let BVC = UIViewController.VC_SETTING_DEL {
                        
                        let ALERT = UIAlertController(title: "", message: "비밀번호가 바뀌어 로그아웃 합니다.", preferredStyle: .alert)
                        ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            UserDefaults.standard.removeObject(forKey: "fcm_id")
                            UserDefaults.standard.removeObject(forKey: "store_id")
                            UserDefaults.standard.removeObject(forKey: "store_category")
                            UserDefaults.standard.removeObject(forKey: "payment_agree")
                            UserDefaults.standard.removeObject(forKey: "waiting_step")
                            UserDefaults.standard.removeObject(forKey: "use_pangpang")
                            BVC.segueViewController(identifier: "VC_LOADING")
                        }))
                        BVC.present(ALERT, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
