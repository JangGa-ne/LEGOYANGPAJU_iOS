//
//  P_WITHDRAWAL.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2023/01/03.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

extension VC_WITHDRAWAL {
    
    func PUT_WITHDRAWAL(NAME: String, AC_TYPE: String) {
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        Firestore.firestore().collection("pangpang_history").document(STORE_ID).delete()
        Firestore.firestore().collection(AC_TYPE).document(STORE_ID).delete() { error in
            
            if error == nil {
                self.S_NOTICE("회원탈퇴 처리됨")
                UserDefaults.standard.removeObject(forKey: "store_id")
                self.segueViewController(identifier: "VC_LOADING")
            } else {
                self.S_NOTICE("오류: 고객센터에 문의바랍니다")
            }
        }
    }
}
