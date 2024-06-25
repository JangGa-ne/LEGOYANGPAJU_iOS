//
//  P_QRSCAN.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/29.
//

import UIKit
import FirebaseFirestore

extension VC_QRSCAN {
    
//    func PUT_COUPON(NAME: String, AC_TYPE: String, CODE: String) {
//
//        let timestamp = setKoreaTimestamp()
//        let CODES = CODE.components(separatedBy: "|}{")
//        let PARAMETERS1: [String: Any] = [
//            "\(CODES[4])": [
//                "receive_time": CODES[4],
//                "review_idx": "",
//                "use_menu": OBJ_PANGPANG[OBJ_POSITION].USE_MENU,
//                "use_nick": CODES[3],
//                "use_num": CODES[1],
//                "use_time": "\(timestamp)",
//                "write_review": "false"
//            ]
//        ]
//        let PARAMETERS2: [String: Any] = [
//            "\(CODES[4])": [
//                "receive_time": CODES[4],
//                "review_idx": CODES[4]+CODES[2],
//                "use_menu": OBJ_PANGPANG[OBJ_POSITION].USE_MENU,
//                "use_time": "\(timestamp)",
//                "use_store_id": UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeId,
//                "use_store_name": UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeName,
//                "write_review": "false"
//            ]
//        ]
//
//        var ERROR: Bool = false
//        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
//        if STORE_ID == CODES[0] {
//            Firestore.firestore().collection("pangpang_history").document(CODES[0]).updateData(PARAMETERS1) { error in if error == nil { ERROR = false } else { ERROR = true }
//                Firestore.firestore().collection("member_pangpang_history").document(CODES[1]).updateData(PARAMETERS2) { error in if error == nil { ERROR = false } else { ERROR = true }
//                    if !ERROR {
//                        self.S_NOTICE("QR코드 인증됨")
//                        Firestore.firestore().collection("store").document(STORE_ID).setData(["pangpang_remain": UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].pangpangRemain-1], merge: true)
//                        if let refresh_1 = UIViewController.PangpangViewControllerDelegate {
//                            refresh_1.COUNT_TF.text = "\(UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].pangpangRemain-1)"
//                        }
//                        if let refresh = UIViewController.LoadingViewControllerDelegate {
//                            refresh.loadingData()
//                        }
//                    } else {
//                        self.S_NOTICE("오류 (!)")
//                    }
//                }
//            }
//        } else {
//            self.S_NOTICE("사용불가 쿠폰")
//        }; navigationController?.popViewController(animated: true)
//    }
    
    func putCoupon(code: String) {
        
        var checkError: Bool = false
        let storeId = UserDefaults.standard.string(forKey: "store_id") ?? ""
        
        let timestamp = setKoreaTimestamp()
        let codes = code.components(separatedBy: "|}{")
        
        let params1: [String: Any] = [
            "\(codes[4])": [
                "receive_time": codes[4],
                "review_idx": "",
                "use_menu": OBJ_PANGPANG[OBJ_POSITION].USE_MENU,
                "use_nick": codes[3],
                "use_num": codes[1],
                "use_time": "\(timestamp)",
                "write_review": "false"
            ]
        ]
        let params2: [String: Any] = [
            "\(codes[4])": [
                "receive_time": codes[4],
                "review_idx": codes[4]+codes[2],
                "use_menu": OBJ_PANGPANG[OBJ_POSITION].USE_MENU,
                "use_time": "\(timestamp)",
                "use_store_id": UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeId,
                "use_store_name": UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeName,
                "write_review": "false"
            ]
        ]
        
        if storeId == codes[0] {
            
            let DispatchGroup = DispatchGroup()
            
            DispatchGroup.enter()
            DispatchQueue.global().async {
                
                Firestore.firestore().collection("pangpang_history").document(codes[0]).updateData(params1) { error in
                    if error == nil { checkError = false } else { checkError = true }; DispatchGroup.leave()
                }
            }
            
            DispatchGroup.enter()
            DispatchQueue.global().async {
                
                Firestore.firestore().collection("member_pangpang_history").document(codes[1]).updateData(params2) { error in
                    if error == nil { checkError = false } else { checkError = true }; DispatchGroup.leave()
                }
            }
            
            DispatchGroup.notify(queue: .main) {
                
                if !checkError {
                    self.S_NOTICE("QR코드 인증됨")
                    Firestore.firestore().collection("store").document(storeId).setData(["pangpang_remain": UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].pangpangRemain-1], merge: true)
                    UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].pangpangRemain -= 1
                    if let refresh_1 = UIViewController.MarketViewControllerDelegate {
                        refresh_1.TABLEVIEW.reloadData()
                    }
//                    if let refresh_2 = UIViewController.PangpangViewControllerDelegate {
//                        refresh_2.COUNT_TF.text = "\(UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].pangpangRemain)"
//                    }
                } else {
                    self.S_NOTICE("오류 (!)")
                }
                
                self.buttonPressed = false
            }
        } else {
            self.S_NOTICE("사용불가 쿠폰")
        }
        
        navigationController?.popViewController(animated: true)
    }
}
