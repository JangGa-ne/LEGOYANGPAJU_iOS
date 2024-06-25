//
//  P_BASKET.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/02/06.
//

import UIKit
import FirebaseFirestore

extension VC_BASKET {
    
    func GET_BASKET(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        // 데이터 삭제
        OBJ_BASKET.removeAll(); TABLEVIEW.reloadData()
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        UIViewController.appDelegate.listener = Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).addSnapshotListener { response1, error in
            
            if let response1 = response1, response1.exists {
                // 데이터 삭제
                self.OBJ_BASKET.removeAll(); self.TABLEVIEW.reloadData()
                
                let _: [()]? = response1.data()?.compactMap({ (key: String, value: Any) in
                    
                    Firestore.firestore().collection("legonggu_item").document(key).getDocument { response2, error in
                        
                        if let response2 = response2 {
                            
                            let DICT = response2.data()
                            let AP_VALUE = API_LEGONGGU()
                            
                            AP_VALUE.SET_END_TIME(END_TIME: DICT?["end_time"] as Any)
                            AP_VALUE.SET_ITEM_BASEPRICE(ITEM_BASEPRICE: DICT?["item_baseprice"] as Any)
                            AP_VALUE.SET_ITEM_CONTENT(ITEM_CONTENT: DICT?["item_content"] as Any)
                            AP_VALUE.SET_ITEM_IMG(ITEM_IMG: DICT?["item_img"] as? [Any] ?? [])
                            AP_VALUE.SET_ITEM_MAINIMG(ITEM_MAINIMG: DICT?["item_mainimg"] as Any)
                            AP_VALUE.SET_ITEM_NAME(ITEM_NAME: key as Any)
                            AP_VALUE.SET_ITEM_PRICE(ITEM_PRICE: DICT?["item_price"] as Any)
                            AP_VALUE.SET_ITEM_SALEINFO(ITEM_SALEINFO: DICT?["item_saleinfo"] as Any)
                            AP_VALUE.SET_ORDER_ITEMARRAY(ORDER_ITEMARRAY: self.SET_ORDER_ITEMARRAY(ARRAY: response1.data()?[key] as Any))
                            AP_VALUE.SET_REMAIN_COUNT(REMAIN_COUNT: DICT?["remain_count"] as Any)
                            // 데이터 추가
                            self.OBJ_BASKET.append(AP_VALUE)
                        }; self.OBJ_BASKET.sort { front, behind in Int(front.END_TIME) ?? 0 < Int(behind.END_TIME) ?? 0 }
                        
                        for TIMER in self.TIMER { TIMER.invalidate() }; self.TABLEVIEW.reloadData(); self.TABLEVIEW.contentOffset = self.TABLEVIEW.contentOffset
                    }
                })
            }
        }
    }
    
    func SET_ORDER_ITEMARRAY(ARRAY: Any) -> [API_ORDER_ITEMARRAY] {
        
        var OBJ_ORDER_DETAIL_ITEMARRAY: [API_ORDER_ITEMARRAY] = []
        
        for (_, DATA) in (ARRAY as! NSArray).enumerated() {
            
            let DICT = DATA as? [String: Any]
            let AP_VALUE = API_ORDER_ITEMARRAY()
            
            AP_VALUE.SET_FREEDELIVERY_COUPON_USE(FREEDELIVERY_COUPON_USE: DICT?["freedelivery_coupon_use"] as Any)
            AP_VALUE.SET_ITEM_COUNT(ITEM_COUNT: DICT?["item_count"] as Any)
            AP_VALUE.SET_ITEM_NAME(ITEM_NAME: DICT?["item_name"] as Any)
            AP_VALUE.SET_ITEM_OPTION(ITEM_OPTION: DICT?["item_option"] as Any)
            AP_VALUE.SET_ITEM_OPTIONS(ITEM_OPTIONS: DICT?["item_options"] as Any)
            AP_VALUE.SET_ITEM_PRICE(ITEM_PRICE: DICT?["item_price"] as Any)
            // 데이터 추가
            OBJ_ORDER_DETAIL_ITEMARRAY.append(AP_VALUE)
        }
        
        return OBJ_ORDER_DETAIL_ITEMARRAY
    }
    
    func PUT_DELETE(NAME: String, AC_TYPE: String, POSITION: Int) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).updateData([OBJ_BASKET[POSITION].ITEM_NAME: FieldValue.delete()])
    }
}
