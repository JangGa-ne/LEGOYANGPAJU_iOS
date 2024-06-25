//
//  P_POPUP3.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/25.
//

import UIKit
import FirebaseFirestore

extension VC_POPUP3 {
    
    func PUT_FILTER(NAME: String, AC_TYPE: String) {
        
        START = (START+54000)*1000; END = (END+140400)*1000
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(STORE_ID).getDocument { snapshot, error in
            
            if let response = snapshot, response.exists {
                
                if AC_TYPE == "pangpang_history", let BVC = UIViewController.VC1_MAIN_DEL {
                    // 데이터 삭제
                    BVC.TOTAL_PRICE = 0; BVC.OBJ_PANGPANG.removeAll()
                    
                    let _: [()]? = response.data()?.compactMap({ (key: String, value: Any) in
                        
                        let DICT = response.data()?[key] as? [String: Any]
                        let AP_VALUE = API_PANGPANG_HISTORY()
                        
                        BVC.TOTAL_PRICE += (DICT?["sale_price"] as? Int ?? 0)
                        
                        AP_VALUE.SET_RECEIVE_TIME(RECEIVE_TIME: DICT?["receive_time"] as Any)
                        AP_VALUE.SET_REVIEW_IDX(REVIEW_IDX: DICT?["review_idx"] as Any)
                        AP_VALUE.SET_SALE_PRICE(SALE_PRICE: DICT?["sale_price"] as Any)
                        AP_VALUE.SET_USE_MENU(USE_MENU: DICT?["use_menu"] as Any)
                        AP_VALUE.SET_USE_NICK(USE_NICK: DICT?["use_nick"] as Any)
                        AP_VALUE.SET_USE_NUM(USE_NUM: DICT?["use_num"] as Any)
                        AP_VALUE.SET_USE_TIME(USE_TIME: DICT?["use_time"] as Any)
                        AP_VALUE.SET_WRITE_REVIEW(WRITE_REVIEW: DICT?["write_review"] as Any)
                        
                        let TIMESTAMP = Int(DICT?["receive_time"] as? String ?? "") ?? 0
                        // 데이터 추가
                        if ( self.START < TIMESTAMP) && (TIMESTAMP < self.END) { BVC.OBJ_PANGPANG.append(AP_VALUE) }
                    })
                    
                    if self.SORT == ">" {
                        BVC.OBJ_PANGPANG.sort(by: { $0.RECEIVE_TIME > $1.RECEIVE_TIME })
                    } else if self.SORT == "<" {
                        BVC.OBJ_PANGPANG.sort(by: { $0.RECEIVE_TIME < $1.RECEIVE_TIME })
                    }; if BVC.PANGPANG_V.isHidden { BVC.PRICE_L.text = "누적 판매금액: \(NF.string(from: BVC.TOTAL_PRICE as NSNumber) ?? "0")원"; BVC.TABLEVIEW.reloadData(); if BVC.OBJ_PANGPANG.count == 0 { self.S_NOTICE("데이터 없음") } }
                } else if AC_TYPE == "lepay_history", let BVC = UIViewController.VC_LEPAY_DEL {
                    // 데이터 삭제
                    BVC.OBJ_PAYMENT.removeAll()
                    
                    let _: [()]? = response.data()?.compactMap({ (key: String, value: Any) in
                        
                        let DICT = response.data()?[key] as? [String: Any]
                        let AP_VALUE = API_LEPAY_HISTORY()
                        
                        AP_VALUE.SET_LEPAY_AMOUNT(LEPAY_AMOUNT: DICT?["lepay_amount"] as Any)
                        AP_VALUE.SET_LEPAY_DETAIL(LEPAY_DETAIL: DICT?["lepay_detail"] as Any)
                        AP_VALUE.SET_LEPAY_TIME(LEPAY_TIME: DICT?["lepay_time"] as Any)
                        AP_VALUE.SET_LEPAY_TYPE(LEPAY_TYPE: DICT?["lepay_type"] as Any)
                        
                        let TIMESTAMP = Int(DICT?["lepay_time"] as? String ?? "") ?? 0
                        // 데이터 추가
                        if (self.START < TIMESTAMP) && (TIMESTAMP < self.END) {
                            if ("전체" == self.TYPE) || ((DICT?["lepay_detail"] as? String ?? "").replacingOccurrences(of: "레고업", with: "레고UP") == self.TYPE) { BVC.OBJ_PAYMENT.append(AP_VALUE) }
                        }
                    })
                    
                    if self.SORT == ">" {
                        BVC.OBJ_PAYMENT.sort(by: { $0.LEPAY_TIME > $1.LEPAY_TIME })
                    } else if self.SORT == "<" {
                        BVC.OBJ_PAYMENT.sort(by: { $0.LEPAY_TIME < $1.LEPAY_TIME })
                    }; BVC.TABLEVIEW.reloadData(); if BVC.OBJ_PAYMENT.count == 0 { self.S_NOTICE("데이터 없음") }
                }
            } else { print("[\(NAME)] FAILURE: \(error as Any)")
                self.S_NOTICE("데이터 없음")
            }; self.dismiss(animated: true, completion: nil)
        }
    }
}
