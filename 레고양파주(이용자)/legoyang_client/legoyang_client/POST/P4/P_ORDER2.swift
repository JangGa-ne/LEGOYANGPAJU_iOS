//
//  P_ORDER2.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/02/23.
//

import UIKit
import FirebaseFirestore

extension VC_ORDER2 {
    
    func GET_ORDER_DETAIL(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        // 데이터 삭제
        OBJ_ORDER_DETAIL.removeAll(); TABLEVIEW.reloadData()
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).getDocument { response, error in
            
            if let response = response {
                
                let DICT = response.data()?[self.KEY] as? [String: Any]
                let AP_VALUE = API_ORDER_DETAIL()
                
                AP_VALUE.SET_GRADE(GRADE: DICT?["grade"] as Any)
                AP_VALUE.SET_TIMESTAMP(TIMESTAMP: self.KEY as Any)
                AP_VALUE.SET_DELIVERY_COMPANY(DELIVERY_COMPANY: DICT?["delivery_company"] as Any)
                AP_VALUE.SET_INVOICE_NUMBER(INVOICE_NUMBER: DICT?["invoice_number"] as Any)
                AP_VALUE.SET_LEPAY_DISCOUNT(LEPAY_DISCOUNT: DICT?["lepay_discount"] as Any)
                AP_VALUE.SET_ORDER_BENEFIT_POINT(ORDER_BENEFIT_POINT: DICT?["order_benefit_point"] as Any)
                AP_VALUE.SET_ORDER_COMPLETE(ORDER_COMPLETE: DICT?["order_complete"] as Any)
                AP_VALUE.SET_ORDER_DELIVERYFEE(ORDER_DELIVERYFEE: DICT?["order_deliveryfee"] as Any)
                AP_VALUE.SET_ORDER_DETAIL(ORDER_DETAIL: DICT?["order_detail"] as Any)
                AP_VALUE.SET_ORDER_ITEMARRAY(ORDER_ITEMARRAY: self.SET_ORDER_ITEMARRAY(ARRAY: DICT?["order_itemarray"] as? [Any] ?? []))
                AP_VALUE.SET_ORDER_ITEMPRICE(ORDER_ITEMPRICE: DICT?["order_itemprice"] as Any)
                AP_VALUE.SET_ORDER_RETURN(ORDER_RETURN: DICT?["order_return"] as Any)
                AP_VALUE.SET_ORDER_STATE(ORDER_STATE: DICT?["order_state"] as Any)
                AP_VALUE.SET_ORDER_TIME(ORDER_TIME: DICT?["order_time"] as Any)
                AP_VALUE.SET_ORDER_TOTALDISCOUNT(ORDER_TOTALDISCOUNT: DICT?["order_totaldiscount"] as Any)
                AP_VALUE.SET_ORDER_TOTALPRICE(ORDER_TOTALPRICE: DICT?["order_totalprice"] as Any)
                AP_VALUE.SET_ORDER_TRADE(ORDER_TRADE: DICT?["order_trade"] as Any)
                AP_VALUE.SET_ORDER_WRONG_MESSAGE(ORDER_WRONG_MESSAGE: DICT?["order_wrong_message"] as Any)
                AP_VALUE.SET_ORDER_WRONG_IMAGE(ORDER_WRONG_IMAGE: DICT?["order_wrong_image"] as Any)
                AP_VALUE.SET_ORDER_WRONG_TYPE(ORDER_WRONG_TYPE: DICT?["order_wrong_type"] as Any)
                AP_VALUE.SET_ORDERMAN_NAME(ORDERMAN_NAME: DICT?["orderman_name"] as Any)
                AP_VALUE.SET_ORDERMAN_NUMBER(ORDERMAN_NUMBER: DICT?["orderman_number"] as Any)
                AP_VALUE.SET_RECEIVER_ADDRESS(RECEIVER_ADDRESS: DICT?["receiver_address"] as Any)
                AP_VALUE.SET_RECEIVER_MEMO(RECEIVER_MEMO: DICT?["receiver_memo"] as Any)
                AP_VALUE.SET_RECEIVER_NAME(RECEIVER_NAME: DICT?["receiver_name"] as Any)
                AP_VALUE.SET_RECEIVER_NUMBER1(RECEIVER_NUMBER1: DICT?["receiver_number1"] as Any)
                AP_VALUE.SET_RECEIVER_NUMBER2(RECEIVER_NUMBER2: DICT?["receiver_number2"] as Any)
                AP_VALUE.SET_USER_NUMBER(USER_NUMBER: DICT?["user_number"] as Any)
                
                if let ARRAY = DICT?["order_itemarray"] as? Array<Any>, (ARRAY.count > 0) {
                    
                    let DICT = ARRAY[0] as? [String: Any]
                    Firestore.firestore().collection("legonggu_item").document(DICT?["item_name"] as? String ?? "").getDocument { reseponse, error in
                        
                        if let reseponse = reseponse {
                            
                            let DICT = reseponse.data()
                            
                            AP_VALUE.SET_ITEM_IMG(ITEM_IMG: DICT?["item_img"] as Any)
                            AP_VALUE.SET_ITEM_MAINIMG(ITEM_MAINIMG: DICT?["item_mainimg"] as Any)
                            AP_VALUE.SET_ITEM_NAME(ITEM_NAME: DICT?["item_name"] as Any)
                            // 데이터 추가
                            self.OBJ_ORDER_DETAIL.append(AP_VALUE)
                        }; self.TABLEVIEW.reloadData()
                    }
                }
            }
        }
    }
    
    func SET_ORDER_ITEMARRAY(ARRAY: [Any]) -> [API_ORDER_ITEMARRAY] {
        
        var OBJ_ORDER_DETAIL_ITEMARRAY: [API_ORDER_ITEMARRAY] = []
        
        for (_, DATA) in ARRAY.enumerated() {
            
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
    
    func SET_CANCEL(NAME: String, AC_TYPE: String) {
        
        let DATA = OBJ_ORDER_DETAIL[OBJ_POSITION]
        let PARAMETERS: [String: Any] = [
            "\(DATA.TIMESTAMP)": [
                "order_state": "주문취소"
            ]
        ]
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).setData(PARAMETERS, merge: true) { error in
            
            if error == nil {
                self.S_NOTICE("주문취소 요청됨"); self.OBJ_ORDER_DETAIL[self.OBJ_POSITION].ORDER_STATE = "주문취소"
                
                let POINT = Int(UIViewController.appDelegate.MemberObject.point) ?? 0
                let COLLECT1 = Int(self.OBJ_ORDER_DETAIL[self.OBJ_POSITION].LEPAY_DISCOUNT) ?? 0
                
                var DELIVERY: Int = 0
                let COLLECT2 = self.OBJ_ORDER_DETAIL[self.OBJ_POSITION].ORDER_DELIVERYFEE
                if COLLECT2 == "0" { DELIVERY = UIViewController.appDelegate.MemberObject.freeDeliveryCoupon+1 }
                
                Firestore.firestore().collection("member").document(MEMBER_ID).setData(["free_delivery_coupon": DELIVERY, "point": "\(POINT+COLLECT1)"], merge: true)
                
                if let BVC1 = UIViewController.VC_ORDER1_DEL {
                    BVC1.OBJ_ORDER_DETAIL = self.OBJ_ORDER_DETAIL; BVC1.TABLEVIEW.reloadData()
                }; self.TABLEVIEW.reloadData(); self.navigationController?.popViewController(animated: true)
            } else {
                self.S_NOTICE("오류: 고객센터에 문의바랍니다")
            }
        }
    }
}
