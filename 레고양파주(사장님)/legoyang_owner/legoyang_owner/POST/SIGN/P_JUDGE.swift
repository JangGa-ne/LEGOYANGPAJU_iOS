//
//  P_JUDGE.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/24.
//

import UIKit
import FirebaseFirestore

extension VC_JUDGE {
    
    func SET_JUDGE(NAME: String, AC_TYPE: String) {
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(STORE_ID).setData(["waiting_step": "2"], merge: true) { error in
            
            if let _ = error {
                self.S_NOTICE("오류 (!)")
            } else {
                
                UserDefaults.standard.setValue("2", forKey: "waiting_step")
                    
                let TBC = self.storyboard?.instantiateViewController(withIdentifier: "TBC") as! TBC
                TBC.selectedIndex = 3
                self.navigationController?.pushViewController(TBC, animated: true, completion: {
                    self.segueViewController(identifier: "VC3_STORE_EDIT")
                })
            }
        }
    }
}
