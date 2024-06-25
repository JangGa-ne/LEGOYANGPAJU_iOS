//
//  P1_MAIN.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/19.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

extension TC1_MAIN {
    
    func SET_PRICE(NAME: String, AC_TYPE: String) {
        
        let DATA = OBJ_PANGPANG[OBJ_POSITION]
        let PARAMETERS: [String: Any] = [
            DATA.RECEIVE_TIME: [
                "receive_time": DATA.RECEIVE_TIME,
                "review_idx": DATA.REVIEW_IDX,
                "sale_price": Int(PRICE_TF.text!.replacingOccurrences(of: ",", with: "")) ?? 0,
                "use_menu": DATA.USE_MENU,
                "use_nick": DATA.USE_NICK,
                "use_num": DATA.USE_NUM,
                "use_time": DATA.USE_TIME,
                "write_review": DATA.WRITE_REVIEW
            ]
        ]
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(STORE_ID).updateData(PARAMETERS)
    }
}

extension VC1_MAIN {
    
    func FirebaseStoragePutData(file: [String: Data], store_id: String, completionHandler: @escaping (_ storage: [String], _ count: Int) -> Void) {
        
        var OBJ_STORAGE: [String] = []
        if file.count > 0 {
             
            for (_, DATA) in file.enumerated() {
                
                let STORAGE_REF = Storage.storage(url: "gs://legoyangpaju.appspot.com").reference()
                let FILE_REF = STORAGE_REF.child("PangPangImage/\(store_id)")
                let META_DATA = StorageMetadata(); META_DATA.contentType = DATA.key.mimeType()
                FILE_REF.putData(DATA.value, metadata: META_DATA).observe(.success) { snapshot in
                    // 데이터 추가
                    FILE_REF.downloadURL { url, error in OBJ_STORAGE.append("\(url!)"); completionHandler(OBJ_STORAGE, OBJ_STORAGE.count) }
                }
            }
        } else {
            completionHandler([], 0)
        }
    }
    
    func PUT_PANGPANG(NAME: String, AC_TYPE: String) {
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        FirebaseStoragePutData(file: OBJ_SELECT, store_id: STORE_ID) { storage, count in
            
            if self.OBJ_SELECT.count == count {
                    
                var PARAMETERS: [String: Any] = [
                    "daily_pangpanginit": Int(self.COUNT_TF.text!) ?? 0,
                    "pangpang_menu": self.COUPON_TF.text!,
                    "pangpang_remain": Int(self.COUNT_TF.text!) ?? 0,
                    "pangpang_pw": self.PASSWORD_TF.text!
                ]
                
                if storage.count > 0 { PARAMETERS["pangpang_image"] = storage[0] }
                
                Firestore.firestore().collection(AC_TYPE).document(STORE_ID).setData(PARAMETERS, merge: true) { error in
                    
                    if error == nil {
                        self.S_NOTICE("레고팡팡 적용됨")
                        self.StoreObject[self.row].pangpangMenu = self.COUPON_TF.text!
                        self.StoreObject[self.row].pangpangRemain = Int(self.COUNT_TF.text!) ?? 0
                        
                        if let refresh = UIViewController.LoadingViewControllerDelegate {
                            refresh.loadingData()
                        }
                    } else {
                        self.S_NOTICE("오류 (!)")
                    }
                    
                    S_INDICATOR(self.view, animated: false)
                }
            }
        }
    }
    
    func GET_PANGPANG(NAME: String, AC_TYPE: String) {
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        UIViewController.AD.LISTENER = Firestore.firestore().collection(AC_TYPE).document(STORE_ID).addSnapshotListener { snapshot, error in
            // 데이터 삭제
            self.TOTAL_PRICE = 0; self.OBJ_PANGPANG.removeAll()
            
            if let response = snapshot, response.exists { // print("[\(NAME)] SUCCESS: \(response.data() as Any)")
                
                let _: [()]? = response.data()?.compactMap({ (key: String, value: Any) in
                    
                    let DICT = response.data()?[key] as? [String: Any]
                    let AP_VALUE = API_PANGPANG_HISTORY()
                    
                    self.TOTAL_PRICE += (DICT?["sale_price"] as? Int ?? 0)
                    
                    AP_VALUE.SET_TIMESTAMP(TIMESTAMP: key as Any)
                    AP_VALUE.SET_RECEIVE_TIME(RECEIVE_TIME: DICT?["receive_time"] as Any)
                    AP_VALUE.SET_REVIEW_IDX(REVIEW_IDX: DICT?["review_idx"] as Any)
                    AP_VALUE.SET_SALE_PRICE(SALE_PRICE: DICT?["sale_price"] as Any)
                    AP_VALUE.SET_USE_MENU(USE_MENU: DICT?["use_menu"] as Any)
                    AP_VALUE.SET_USE_NICK(USE_NICK: DICT?["use_nick"] as Any)
                    AP_VALUE.SET_USE_NUM(USE_NUM: DICT?["use_num"] as Any)
                    AP_VALUE.SET_USE_TIME(USE_TIME: DICT?["use_time"] as Any)
                    AP_VALUE.SET_WRITE_REVIEW(WRITE_REVIEW: DICT?["write_review"] as Any)
                    // 데이터 추가
                    self.OBJ_PANGPANG.append(AP_VALUE)
                })
            } else { print("[\(NAME)] FAILURE: \(error as Any)")
                self.S_NOTICE("데이터 없음")
            }; self.OBJ_PANGPANG.sort(by: { $0.RECEIVE_TIME > $1.RECEIVE_TIME })
            
            self.PRICE_L.text = "누적 판매금액: \(NF.string(from: self.TOTAL_PRICE as NSNumber) ?? "0")원"; self.TABLEVIEW.reloadData()
        }
    }
    
    func PUT_DELETE(NAME: String, AC_TYPE: String, POSITION: Int) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(STORE_ID).updateData([OBJ_PANGPANG[POSITION].TIMESTAMP: FieldValue.delete()]) { error in
            if error == nil { self.S_NOTICE("팡팡내역 삭제됨") }
        }
    }
}

//    var <#name#>: String = ""
//    func SET_<#name#>(<#name#>: Any) { self.<#name#> = <#name#> as? String ?? "" }

class API_PANGPANG_HISTORY {
    
    var TIMESTAMP: String = ""
    var RECEIVE_TIME: String = ""
    var REVIEW_IDX: String = ""
    var SALE_PRICE: Int = 0
    var USE_MENU: String = ""
    var USE_NICK: String = ""
    var USE_NUM: String = ""
    var USE_TIME: String = ""
    var WRITE_REVIEW: String = ""
    
    func SET_TIMESTAMP(TIMESTAMP: Any) { self.TIMESTAMP = TIMESTAMP as? String ?? "" }
    func SET_RECEIVE_TIME(RECEIVE_TIME: Any) { self.RECEIVE_TIME = RECEIVE_TIME as? String ?? "" }
    func SET_REVIEW_IDX(REVIEW_IDX: Any) { self.REVIEW_IDX = REVIEW_IDX as? String ?? "" }
    func SET_SALE_PRICE(SALE_PRICE: Any) { self.SALE_PRICE = SALE_PRICE as? Int ?? 0 }
    func SET_USE_MENU(USE_MENU: Any) { self.USE_MENU = USE_MENU as? String ?? "" }
    func SET_USE_NICK(USE_NICK: Any) { self.USE_NICK = USE_NICK as? String ?? "" }
    func SET_USE_NUM(USE_NUM: Any) { self.USE_NUM = USE_NUM as? String ?? "" }
    func SET_USE_TIME(USE_TIME: Any) { self.USE_TIME = USE_TIME as? String ?? "" }
    func SET_WRITE_REVIEW(WRITE_REVIEW: Any) { self.WRITE_REVIEW = WRITE_REVIEW as? String ?? "" }
}
