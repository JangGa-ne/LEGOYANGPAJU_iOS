//
//  P_LEPAY.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/06.
//

import UIKit
import FirebaseFirestore

extension VC_LEPAY {
    
    func GET_PAYMENT(NAME: String, AC_TYPE: String) {
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        UIViewController.AD.LISTENER = Firestore.firestore().collection(AC_TYPE).document(STORE_ID).addSnapshotListener { snapshot, error in
            // 데이터 삭제
            self.OBJ_PAYMENT.removeAll()
            
            if let response = snapshot, response.exists { // print("[\(NAME)] SUCCESS: \(response.data() as Any)")
                
                let _: [()]? = response.data()?.compactMap({ (key: String, value: Any) in
                    
                    let DICT = response.data()?[key] as? [String: Any]
                    let AP_VALUE = API_LEPAY_HISTORY()
                    
                    AP_VALUE.SET_LEPAY_AMOUNT(LEPAY_AMOUNT: DICT?["lepay_amount"] as Any)
                    AP_VALUE.SET_LEPAY_DETAIL(LEPAY_DETAIL: DICT?["lepay_detail"] as Any)
                    AP_VALUE.SET_LEPAY_TIME(LEPAY_TIME: DICT?["lepay_time"] as Any)
                    AP_VALUE.SET_LEPAY_TYPE(LEPAY_TYPE: DICT?["lepay_type"] as Any)
                    // 데이터 추가
                    self.OBJ_PAYMENT.append(AP_VALUE)
                })
            } else { print("[\(NAME)] FAILURE: \(error as Any)")
                self.S_NOTICE("데이터 없음")
            }; self.OBJ_PAYMENT.sort(by: { $0.LEPAY_TIME > $1.LEPAY_TIME }); self.TABLEVIEW.reloadData()
        }
    }
}

//    var <#name#>: String = ""
//    func SET_<#name#>(<#name#>: Any) { self.<#name#> = <#name#> as? String ?? "" }

class API_LEPAY_HISTORY {
    
    var LEPAY_AMOUNT: String = ""
    var LEPAY_DETAIL: String = ""
    var LEPAY_TIME: String = ""
    var LEPAY_TYPE: String = ""
    
    func SET_LEPAY_AMOUNT(LEPAY_AMOUNT: Any) { self.LEPAY_AMOUNT = LEPAY_AMOUNT as? String ?? "" }
    func SET_LEPAY_DETAIL(LEPAY_DETAIL: Any) { self.LEPAY_DETAIL = LEPAY_DETAIL as? String ?? "" }
    func SET_LEPAY_TIME(LEPAY_TIME: Any) { self.LEPAY_TIME = LEPAY_TIME as? String ?? "" }
    func SET_LEPAY_TYPE(LEPAY_TYPE: Any) { self.LEPAY_TYPE = LEPAY_TYPE as? String ?? "" }
}
