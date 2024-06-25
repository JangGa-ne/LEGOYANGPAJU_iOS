//
//  P_ORDER3.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/02/24.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

extension VC_ORDER3 {
    
    func FirebaseStoragePutData(file: [String: Data], name: String, completionHandler: @escaping (_ storage: [String], _ count: Int) -> Void) {
        
        var OBJ_STORAGE: [String] = []
        if file.count > 0 {
            
            for (i, DATA) in file.enumerated() {
                
                let STORAGE_REF = Storage.storage(url: "gs://legoyangpaju.appspot.com").reference()
                let FILE_REF = STORAGE_REF.child("OrderWrongImage/\(name)_\(i)")
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
    
    func SET_PROTEST(NAME: String, AC_TYPE: String) {
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        FirebaseStoragePutData(file: IMAGE_DATA, name: "\(OBJ_ORDER_DETAIL[OBJ_POSITION].TIMESTAMP)_\(MEMBER_ID)") { storage, count in
            
            if self.IMAGE_DATA.count == count {
                
                let DATA = self.OBJ_ORDER_DETAIL[self.OBJ_POSITION]
                var PARAMETERS: [String: Any] = [
                    "\(DATA.TIMESTAMP)": [
                        "order_state": self.TITLE1,
                        "order_complete": DATA.ORDER_COMPLETE,
                        "order_wrong_type": self.ORDER_WRONG_TYPE,
                        "order_wrong_message": self.CONTENTS_TV.text!,
                    ]
                ]
                
                Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).setData(PARAMETERS, merge: true) { error in
                    if error == nil {
                        self.S_NOTICE("\(self.TITLE1.replacingOccurrences(of: "요청", with: " 요청됨"))")
                        self.OBJ_ORDER_DETAIL[self.OBJ_POSITION].ORDER_STATE = self.TITLE1
                        
                        if self.TITLE1.contains("반품") {
                            
                            let POINT = Int(UIViewController.appDelegate.MemberObject.point) ?? 0
                            let COLLECT1 = Int(self.OBJ_ORDER_DETAIL[self.OBJ_POSITION].LEPAY_DISCOUNT) ?? 0
                            
                            var DELIVERY: Int = 0
                            let COLLECT2 = self.OBJ_ORDER_DETAIL[self.OBJ_POSITION].ORDER_DELIVERYFEE
                            if COLLECT2 == "0" { DELIVERY = UIViewController.appDelegate.MemberObject.freeDeliveryCoupon+1 }
                            
                            Firestore.firestore().collection("member").document(MEMBER_ID).setData(["free_delivery_coupon": DELIVERY, "point": "\(POINT+COLLECT1)"], merge: true)
                        }
                        
                        if let BVC1 = UIViewController.VC_ORDER1_DEL {
                            BVC1.GET_ORDER(NAME: "주문내역", AC_TYPE: AC_TYPE)
                        }
                        if let BVC2 = UIViewController.VC_ORDER2_DEL {
                            BVC2.OBJ_ORDER_DETAIL = self.OBJ_ORDER_DETAIL; BVC2.TABLEVIEW.reloadData()
                        }; self.navigationController?.popViewController(animated: true)
                    } else {
                        self.S_NOTICE("오류: 고객센터에 문의바랍니다")
                    }
                }
            }
        }
    }
    
    func SET_CONFIRMATION(NAME: String, AC_TYPE: String, PRICE: Int) {
        
        let DATA = OBJ_ORDER_DETAIL[OBJ_POSITION]
        let BENEFIT = Int(CGFloat(PRICE)*(CGFloat(Int(UIViewController.appDelegate.MemberObject.grade) ?? 0)*0.01))
        let PARAMETERS: [String: Any] = [
            "\(DATA.TIMESTAMP)": [
                "grade": UIViewController.appDelegate.MemberObject.grade,
                "order_state": "구매확정",
                "order_benefit_point": "\(BENEFIT)",
                "order_complete": "true"
            ]
        ]
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).setData(PARAMETERS, merge: true) { error in
            
            if error == nil {
                self.S_NOTICE("구매확정 요청됨")
                self.OBJ_ORDER_DETAIL[self.OBJ_POSITION].ORDER_STATE = "구매확정"
                
                let POINT = Int(UIViewController.appDelegate.MemberObject.point) ?? 0
                let BENEFIT_POINT = Int(UIViewController.appDelegate.MemberObject.benefitPoint) ?? 0
                Firestore.firestore().collection("member").document(MEMBER_ID).setData(["point": "\(POINT+BENEFIT)", "benefit_point": "\(BENEFIT_POINT+BENEFIT)"], merge: true)
                
                if let BVC1 = UIViewController.VC_ORDER1_DEL {
                    BVC1.GET_ORDER(NAME: "주문내역", AC_TYPE: AC_TYPE)
                }
                if let BVC2 = UIViewController.VC_ORDER2_DEL {
                    BVC2.OBJ_ORDER_DETAIL = self.OBJ_ORDER_DETAIL; BVC2.TABLEVIEW.reloadData()
                }; self.navigationController?.popViewController(animated: true)
            } else {
                
            }
        }
    }
}
