//
//  P_ORDER1.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/02/16.
//

import UIKit
import FirebaseFirestore

extension VC_ORDER1 {
    
    func GET_ORDER(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        // 데이터 삭제
        OBJ_ORDER_DETAIL1.removeAll(); OBJ_ORDER_DETAIL2.removeAll(); TABLEVIEW.reloadData()
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).getDocument { response, error in
            
            if let response = response {
                
                let _: [()]? = response.data()?.compactMap({ (key: String, value: Any) in
                    
                    let DICT = response.data()?[key] as? [String: Any]
                    let AP_VALUE = API_ORDER_DETAIL()
                    
                    AP_VALUE.SET_GRADE(GRADE: DICT?["grade"] as Any)
                    AP_VALUE.SET_TIMESTAMP(TIMESTAMP: key as Any)
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
                    
                    let ORDER_COMPLETE = DICT?["order_complete"] as? String ?? ""
                    let ORDER_STATE = DICT?["order_state"] as? String ?? ""
                    if let ARRAY = DICT?["order_itemarray"] as? Array<Any>, (ARRAY.count > 0) {
                        
                        let DICT = ARRAY[0] as? [String: Any]
                        Firestore.firestore().collection("legonggu_item").document(DICT?["item_name"] as? String ?? "").getDocument { reseponse, error in
                            
                            if let reseponse = reseponse {
                                
                                let DICT = reseponse.data()
                                
                                AP_VALUE.SET_ITEM_IMG(ITEM_IMG: DICT?["item_img"] as Any)
                                AP_VALUE.SET_ITEM_MAINIMG(ITEM_MAINIMG: DICT?["item_mainimg"] as Any)
                                AP_VALUE.SET_ITEM_NAME(ITEM_NAME: DICT?["item_name"] as Any)
                                // 데이터 추가
                                if ORDER_COMPLETE == "false" {
                                    self.OBJ_ORDER_DETAIL.append(AP_VALUE); self.OBJ_ORDER_DETAIL1.append(AP_VALUE)
                                } else {
                                    self.OBJ_ORDER_DETAIL2.append(AP_VALUE)
                                }
                                
                                self.OBJ_ORDER_DETAIL.sort { front, behind in Int(front.ORDER_TIME) ?? 0 > Int(behind.ORDER_TIME) ?? 0 }
                                self.OBJ_ORDER_DETAIL1.sort { front, behind in Int(front.ORDER_TIME) ?? 0 > Int(behind.ORDER_TIME) ?? 0 }
                                self.OBJ_ORDER_DETAIL2.sort { front, behind in Int(front.ORDER_TIME) ?? 0 > Int(behind.ORDER_TIME) ?? 0 }
                            }; self.TABLEVIEW.reloadData()
                        }
                    }
                })
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
        
        var count: Int = 0
        for data in DATA.ORDER_ITEMARRAY { count += (Int(data.ITEM_COUNT) ?? 0) }
        
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
                
                Firestore.firestore().collection("legonggu_item").document(self.OBJ_ORDER_DETAIL[self.OBJ_POSITION].ITEM_NAME).getDocument { response, error in
                    Firestore.firestore().collection("legonggu_item").document(self.OBJ_ORDER_DETAIL[self.OBJ_POSITION].ITEM_NAME).setData(["remain_count": (response?.data()?["remain_count"] as? Int ?? 0)+count], merge: true)
                }
                
                self.TABLEVIEW.reloadData()
            } else {
                self.S_NOTICE("오류: 고객센터에 문의바랍니다")
            }
        }
    }
}

// var <#name#>: String = ""
// func SET_<#name#>(<#name#>: Any) { self.<#name#> = <#name#> as? String ?? "" }

class API_ORDER_DETAIL {
    
    var GRADE: String = ""
    var TIMESTAMP: String = ""
    var DELIVERY_COMPANY: String = ""
    var INVOICE_NUMBER: String = ""
    var LEPAY_DISCOUNT: String = ""
    var ORDER_BENEFIT_POINT: String = ""
    var ORDER_COMPLETE: String = ""
    var ORDER_DELIVERYFEE: String = ""
    var ORDER_DETAIL: String = ""
    var ORDER_ITEMARRAY: [API_ORDER_ITEMARRAY] = []
    var ORDER_ITEMPRICE: String = ""
    var ORDER_RETURN: String = ""
    var ORDER_STATE: String = ""
    var ORDER_TIME: String = ""
    var ORDER_TOTALDISCOUNT: String = ""
    var ORDER_TOTALPRICE: String = ""
    var ORDER_TRADE: String = ""
    var ORDER_WRONG_MESSAGE: String = ""
    var ORDER_WRONG_IMAGE: [String] = []
    var ORDER_WRONG_TYPE: String = ""
    var ORDERMAN_NAME: String = ""
    var ORDERMAN_NUMBER: String = ""
    var RECEIVER_ADDRESS: String = ""
    var RECEIVER_MEMO: String = ""
    var RECEIVER_NAME: String = ""
    var RECEIVER_NUMBER1: String = ""
    var RECEIVER_NUMBER2: String = ""
    var USER_NUMBER: String = ""
    var ITEM_IMG: [String] = []
    var ITEM_MAINIMG: String = ""
    var ITEM_NAME: String = ""
    
    func SET_GRADE(GRADE: Any) { self.GRADE = GRADE as? String ?? "" }
    func SET_TIMESTAMP(TIMESTAMP: Any) { self.TIMESTAMP = TIMESTAMP as? String ?? "" }
    func SET_DELIVERY_COMPANY(DELIVERY_COMPANY: Any) { self.DELIVERY_COMPANY = DELIVERY_COMPANY as? String ?? "" }
    func SET_INVOICE_NUMBER(INVOICE_NUMBER: Any) { self.INVOICE_NUMBER = INVOICE_NUMBER as? String ?? "" }
    func SET_LEPAY_DISCOUNT(LEPAY_DISCOUNT: Any) { self.LEPAY_DISCOUNT = LEPAY_DISCOUNT as? String ?? "" }
    func SET_ORDER_BENEFIT_POINT(ORDER_BENEFIT_POINT: Any) { self.ORDER_BENEFIT_POINT = ORDER_BENEFIT_POINT as? String ?? "" }
    func SET_ORDER_COMPLETE(ORDER_COMPLETE: Any) { self.ORDER_COMPLETE = ORDER_COMPLETE as? String ?? "" }
    func SET_ORDER_DELIVERYFEE(ORDER_DELIVERYFEE: Any) { self.ORDER_DELIVERYFEE = ORDER_DELIVERYFEE as? String ?? "" }
    func SET_ORDER_DETAIL(ORDER_DETAIL: Any) { self.ORDER_DETAIL = ORDER_DETAIL as? String ?? "" }
    func SET_ORDER_ITEMARRAY(ORDER_ITEMARRAY: Any) { self.ORDER_ITEMARRAY = ORDER_ITEMARRAY as? [API_ORDER_ITEMARRAY] ?? [] }
    func SET_ORDER_ITEMPRICE(ORDER_ITEMPRICE: Any) { self.ORDER_ITEMPRICE = ORDER_ITEMPRICE as? String ?? "" }
    func SET_ORDER_RETURN(ORDER_RETURN: Any) { self.ORDER_RETURN = ORDER_RETURN as? String ?? "" }
    func SET_ORDER_STATE(ORDER_STATE: Any) { self.ORDER_STATE = ORDER_STATE as? String ?? "" }
    func SET_ORDER_TIME(ORDER_TIME: Any) { self.ORDER_TIME = ORDER_TIME as? String ?? "" }
    func SET_ORDER_TOTALDISCOUNT(ORDER_TOTALDISCOUNT: Any) { self.ORDER_TOTALDISCOUNT = ORDER_TOTALDISCOUNT as? String ?? "" }
    func SET_ORDER_TOTALPRICE(ORDER_TOTALPRICE: Any) { self.ORDER_TOTALPRICE = ORDER_TOTALPRICE as? String ?? "" }
    func SET_ORDER_TRADE(ORDER_TRADE: Any) { self.ORDER_TRADE = ORDER_TRADE as? String ?? "" }
    func SET_ORDER_WRONG_MESSAGE(ORDER_WRONG_MESSAGE: Any) { self.ORDER_WRONG_MESSAGE = ORDER_WRONG_MESSAGE as? String ?? "" }
    func SET_ORDER_WRONG_IMAGE(ORDER_WRONG_IMAGE: Any) { self.ORDER_WRONG_IMAGE = ORDER_WRONG_IMAGE as? [String] ?? [] }
    func SET_ORDER_WRONG_TYPE(ORDER_WRONG_TYPE: Any) { self.ORDER_WRONG_TYPE = ORDER_WRONG_TYPE as? String ?? "" }
    func SET_ORDERMAN_NAME(ORDERMAN_NAME: Any) { self.ORDERMAN_NAME = ORDERMAN_NAME as? String ?? "" }
    func SET_ORDERMAN_NUMBER(ORDERMAN_NUMBER: Any) { self.ORDERMAN_NUMBER = ORDERMAN_NUMBER as? String ?? "" }
    func SET_RECEIVER_ADDRESS(RECEIVER_ADDRESS: Any) { self.RECEIVER_ADDRESS = RECEIVER_ADDRESS as? String ?? "" }
    func SET_RECEIVER_MEMO(RECEIVER_MEMO: Any) { self.RECEIVER_MEMO = RECEIVER_MEMO as? String ?? "" }
    func SET_RECEIVER_NAME(RECEIVER_NAME: Any) { self.RECEIVER_NAME = RECEIVER_NAME as? String ?? "" }
    func SET_RECEIVER_NUMBER1(RECEIVER_NUMBER1: Any) { self.RECEIVER_NUMBER1 = RECEIVER_NUMBER1 as? String ?? "" }
    func SET_RECEIVER_NUMBER2(RECEIVER_NUMBER2: Any) { self.RECEIVER_NUMBER2 = RECEIVER_NUMBER2 as? String ?? "" }
    func SET_USER_NUMBER(USER_NUMBER: Any) { self.USER_NUMBER = USER_NUMBER as? String ?? "" }
    func SET_ITEM_IMG(ITEM_IMG: Any) { self.ITEM_IMG = ITEM_IMG as? [String] ?? [] }
    func SET_ITEM_MAINIMG(ITEM_MAINIMG: Any) { self.ITEM_MAINIMG = ITEM_MAINIMG as? String ?? "" }
    func SET_ITEM_NAME(ITEM_NAME: Any) { self.ITEM_NAME = ITEM_NAME as? String ?? "" }
}

class API_ORDER_ITEMARRAY {
    
    var FREEDELIVERY_COUPON_USE: String = ""
    var ITEM_COUNT: String = ""
    var ITEM_NAME: String = ""
    var ITEM_OPTION: String = ""
    var ITEM_OPTIONS: [String] = []
    var ITEM_PRICE: String = ""
    
    func SET_FREEDELIVERY_COUPON_USE(FREEDELIVERY_COUPON_USE: Any) { self.FREEDELIVERY_COUPON_USE = FREEDELIVERY_COUPON_USE as? String ?? "" }
    func SET_ITEM_COUNT(ITEM_COUNT: Any) { self.ITEM_COUNT = ITEM_COUNT as? String ?? "" }
    func SET_ITEM_NAME(ITEM_NAME: Any) { self.ITEM_NAME = ITEM_NAME as? String ?? "" }
    func SET_ITEM_OPTION(ITEM_OPTION: Any) { self.ITEM_OPTION = ITEM_OPTION as? String ?? "" }
    func SET_ITEM_OPTIONS(ITEM_OPTIONS: Any) { self.ITEM_OPTIONS = ITEM_OPTIONS as? [String] ?? [] }
    func SET_ITEM_PRICE(ITEM_PRICE: Any) { self.ITEM_PRICE = ITEM_PRICE as? String ?? "" }
}
