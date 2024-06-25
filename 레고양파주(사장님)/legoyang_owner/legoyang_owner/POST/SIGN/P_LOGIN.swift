//
//  P_LOGIN.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/11/30.
//

import UIKit
import FirebaseFirestore

extension VC_LOGIN {
    
    func GET_LOGIN(NAME: String, AC_TYPE: String) {
        
        Firestore.firestore().collection(AC_TYPE).document(ID_TF.text!).getDocument { response, error in
            
            if response?.data() != nil { // print("[\(NAME)] SUCCESS: \(response?.data() as Any)")
                
                let DICT = response?.data() ?? [:]
                if DICT["store_password"] as? String ?? "" == self.PW_TF.text! {
                    UserDefaults.standard.setValue(DICT["store_id"] as? String ?? self.ID_TF.text!, forKey: "store_id")
                    UserDefaults.standard.setValue(DICT["store_category"] as? String ?? "", forKey: "store_category")
                    UserDefaults.standard.setValue(DICT["waiting_step"] as? String ?? "0", forKey: "waiting_step")
                    self.segueViewController(identifier: "VC_LOADING")
                } else {
                    self.S_NOTICE("로그인 실패")
                }
            } else if response?.data() == nil {
                self.S_NOTICE("로그인 실패")
            } else { print("[\(NAME)] FAILURE: \(error as Any)")
                self.S_NOTICE("응답 에러")
            }; self.LOGIN_B.isHidden = false; S_INDICATOR(self.view, animated: false)
        }
    }
}
