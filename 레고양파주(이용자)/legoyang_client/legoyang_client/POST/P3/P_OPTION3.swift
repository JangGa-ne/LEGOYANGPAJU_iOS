//
//  P_OPTION3.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/02/12.
//

import UIKit
import FirebaseFirestore

extension VC_OPTION3 {
    
    func PUT_BASKET(NAME: String, AC_TYPE: String, BASKET: Int = 0) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        var PARAMETERS: [String: Any] = [:]
        var OPTIONS: [Any] = []
        for (_, DATA) in OBJ_BASKETS.enumerated() {
            OPTIONS.append([
                "freedelivery_coupon_use": "\(FREE_DELIVERY)",
                "item_count": "\(DATA["count"] as? Int ?? 0)",
                "item_name": OBJ_LEGONGGU[OBJ_POSITION].ITEM_NAME,
                "item_option": DATA["option_name"] as? String ?? "",
                "item_options": [""],
                "item_price": "\(DATA["option_price"] as? Int ?? 0)"
            ])
        }; PARAMETERS[OBJ_LEGONGGU[OBJ_POSITION].ITEM_NAME] = OPTIONS
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
//        Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).getDocument { response, error in
//
//            var BASKET_CHECK: Bool = false
//
//            if let response = response {
//
//                let _: [()]? = response.data()?.compactMap({ (key: String, value: Any) in
//                    if (BASKET == 0) && (key == self.OBJ_LEGONGGU[self.OBJ_POSITION].ITEM_NAME) { self.S_NOTICE("이미 장바구니에 있음"); BASKET_CHECK = true; return }
//                })
//            }
//
//            if !BASKET_CHECK {
//
                Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).setData(PARAMETERS, merge: true) { error in
                    
                    if BASKET == 0 {
                        
                        if error == nil {
                            
//                            if self.FREE_DELIVERY {
//                                let FREE_DELIVERY = UIViewController.appDelegate.MemberObject.FREE_DELIVERY_COUPON-1
//                                Firestore.firestore().collection("member").document(MEMBER_ID).setData(["free_delivery_coupon": FREE_DELIVERY], merge: true)
//                            }
                            
                            let ALERT = UIAlertController(title: "장바구니 보기", message: "상품이 장바구니에 담겼습니다.\n지금 확인하시겠습니까?", preferredStyle: .alert)
                            ALERT.addAction(UIAlertAction(title: "예", style: .default, handler: { _ in
                                self.dismiss(animated: true, completion: nil); if let RVC = UIViewController.VC_LEGONGGU2_DEL { RVC.segueViewController(identifier: "VC_BASKET") }
                            }))
                            ALERT.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: nil))
                            self.present(ALERT, animated: true, completion: nil)
                        }
                    } else if BASKET == 1 {
                        
                        if error == nil { self.dismiss(animated: true, completion: nil)
                            
                            if let RVC = UIViewController.VC_LEGONGGU2_DEL {
                                
                                var OBJ_BASKET: [API_LEGONGGU] = []
                                let OBJ_POSITION: Int = 0
                                
                                OBJ_BASKET = [self.OBJ_LEGONGGU[self.OBJ_POSITION]]; OBJ_BASKET[OBJ_POSITION].ORDER_ITEMARRAY.removeAll()
                                
                                for (_, DATA) in self.OBJ_BASKETS.enumerated() {
                                    
                                    let AP_VALUE = API_ORDER_ITEMARRAY()
                                    
                                    AP_VALUE.SET_FREEDELIVERY_COUPON_USE(FREEDELIVERY_COUPON_USE: "\(self.FREE_DELIVERY)")
                                    AP_VALUE.SET_ITEM_COUNT(ITEM_COUNT: "\(DATA["count"] as? Int ?? 0)")
                                    AP_VALUE.SET_ITEM_NAME(ITEM_NAME: self.OBJ_LEGONGGU[self.OBJ_POSITION].ITEM_NAME)
                                    AP_VALUE.SET_ITEM_OPTION(ITEM_OPTION: DATA["option_name"] as? String ?? "")
                                    AP_VALUE.SET_ITEM_OPTIONS(ITEM_OPTIONS: [])
                                    AP_VALUE.SET_ITEM_PRICE(ITEM_PRICE: "\(DATA["option_price"] as? Int ?? 0)")
                                    
                                    OBJ_BASKET[OBJ_POSITION].ORDER_ITEMARRAY.append(AP_VALUE)
                                }
                                
                                DispatchQueue.main.async {
                                    
                                    let VC = RVC.storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL4") as! VC_DETAIL4
                                    VC.OBJ_BASKET = OBJ_BASKET; VC.OBJ_POSITION = OBJ_POSITION
                                    RVC.navigationController?.pushViewController(VC, animated: true)
                                }
                            }
                        }
                    }
                }
//            }
//        }
    }
}
