//
//  P_DETAIL4.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/02/15.
//

import UIKit
import Bootpay
import FirebaseFirestore

extension VC_DETAIL4 {
    
    func PUT_BOOTPAY2(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        let PAYLOAD = Payload()
        PAYLOAD.applicationId = "63718f88cf9f6d002023e415"
        PAYLOAD.price = Double(PRICE1+PRICE2-PRICE3)
        PAYLOAD.authenticationId = String(NSTimeIntervalSince1970)
        PAYLOAD.pg = "payletter"
        PAYLOAD.method = METHOD_TYPE
        PAYLOAD.orderId = String(NSTimeIntervalSince1970)
        PAYLOAD.orderName = "레고양파주 결제: \(OBJ_BASKET[OBJ_POSITION].ITEM_NAME)"
        
        let USER = BootUser()
        USER.username = NAME_TF3.text!
        USER.phone = NUMBER_TF3.text!.replacingOccurrences(of: "-", with: "")
        PAYLOAD.user = USER
        
        let EXTRA = BootExtra()
        PAYLOAD.extra?.cardQuota = "0,2,3"
        PAYLOAD.extra?.displaySuccessResult = true
        PAYLOAD.extra = EXTRA
        
        let ITEM1 = BootItem()
        ITEM1.name = OBJ_BASKET[OBJ_POSITION].ITEM_NAME
        ITEM1.qty = 1
        ITEM1.id = "item_01"
        ITEM1.price = Double(PRICE1+PRICE2-PRICE3)
        PAYLOAD.items = [ITEM1]
        
        Bootpay.requestPayment(viewController: self, payload: PAYLOAD)
        .onCancel { data in
            print("-- cancel: \(data)")
        }
        .onIssued { data in
            print("-- issued: \(data)")
        }
        .onConfirm { data in
            print("-- confirm: \(data)")
            return true //재고가 있어서 결제를 최종 승인하려 할 경우
//            Bootpay.transactionConfirm()
//            return false //재고가 없어서 결제를 승인하지 않을때
        }
        .onDone { data in
            let DICT = data["data"] as? [String: Any]
            print("-- done: \(data)"); self.PUT_PAYMENT(NAME: "주문요청", AC_TYPE: "legonggu_order_detail", RECEIPT_ID: DICT?["receipt_id"] as? String ?? "")
        }
        .onError { data in
            print("-- error: \(data)")
            let DICT = data as [String: Any]
            if !((DICT["message"] as? String ?? "").contains("100")) { self.S_NOTICE(DICT["message"] as? String ?? "") }
        }
        .onClose {
            print("-- close")
        }
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_SIGNCHECK") as! VC_SIGNCHECK
        VC.TITLE = "레공구 결제하기"
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func PUT_PAYMENT(NAME: String, AC_TYPE: String, RECEIPT_ID: String = "") { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        ADDRESS = "\(ADDRESS_TF1.text!) \(ADDRESS_TF2.text!)"
        var ITEM_COUNT: Int = 0

        var ORDER_ITEMARRAY: [Any] = []
        
        for (_, DATA) in OBJ_BASKET[OBJ_POSITION].ORDER_ITEMARRAY.enumerated() {

            ORDER_ITEMARRAY.append([
                "freedelivery_coupon_use": DATA.FREEDELIVERY_COUPON_USE,
                "item_count": DATA.ITEM_COUNT,
                "item_name": DATA.ITEM_NAME,
                "item_option": DATA.ITEM_OPTION,
                "item_options": [],
                "item_price": DATA.ITEM_PRICE
            ] as [String : Any])
            
            ITEM_COUNT += (Int(DATA.ITEM_COUNT) ?? 0)
        }
        
        var ORDER_DELIVERYFEE: Int = 0
        if FREEDELIVERY_COUPON_USE { ORDER_DELIVERYFEE = 0 } else { ORDER_DELIVERYFEE = 3000 }
        
        let TIMESTAMP = Int(floor(Date().timeIntervalSince1970 * 1000))
        let PARAMETERS: [String: Any] = [
            "\(TIMESTAMP)": [
                "delivery_company": "",
                "invoice_number": "",
                "lepay_discount": "\(PRICE3)",
                "grade": UIViewController.appDelegate.MemberObject.grade,
                "order_benefit_point": PRICE_L5.text!.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: ""),
                "order_complete": "false",
                "order_deliveryfee": "\(ORDER_DELIVERYFEE)",
                "order_itemprice": "\(PRICE1)",
                "order_itemarray": ORDER_ITEMARRAY,
                "order_return": "false",
                "order_state": "배송전",
                "order_time": "\(TIMESTAMP)",
                "order_totaldiscount": "\(PRICE3)",
                "order_totalprice": "\((PRICE1+PRICE2))",
                "order_trade": "false",
                "order_wrong_image": [],
                "order_wrong_message": "",
                "order_wrong_type": "",
                "orderman_name": NAME_TF3.text!,
                "orderman_number": NUMBER_TF3.text!.replacingOccurrences(of: "-", with: ""),
                "receipt_id": RECEIPT_ID,
                "receiver_address": ADDRESS,
                "receiver_memo": MEMO_TF.text!,
                "receiver_name": NAME_TF2.text!,
                "receiver_number1": (NUMBER_TF1_1.text!+NUMBER_TF1_2.text!+NUMBER_TF1_3.text!),
                "receiver_number2": (NUMBER_TF2_1.text!.replacingOccurrences(of: "선택", with: "")+NUMBER_TF2_2.text!+NUMBER_TF2_2.text!)
            ] as [String : Any]
        ]
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        Firestore.firestore().collection("orderlist_bygonggu").document(BASKET_L.text!).updateData([MEMBER_ID: FieldValue.arrayUnion(["\(TIMESTAMP)"])]) { error in
            if error != nil { Firestore.firestore().collection("orderlist_bygonggu").document(self.BASKET_L.text!).setData([MEMBER_ID: ["\(TIMESTAMP)"]], merge: true) }
        }
        Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).setData(PARAMETERS, merge: true) { error in

            S_INDICATOR(self.view, animated: false)
            
            if error == nil { self.S_NOTICE("주문완료")
                
                Firestore.firestore().collection("legonggu_item").document(self.BASKET_L.text!).getDocument { response, error in
                    if let response = response {
                        let remainCount = response.data()?["remain_count"] as? Int ?? 0
                        Firestore.firestore().collection("legonggu_item").document(self.BASKET_L.text!).setData(["remain_count": remainCount-ITEM_COUNT], merge: true)
                    }
                }

                let UPDATE = Firestore.firestore().collection("member").document(MEMBER_ID)
                if self.SETTING_B1.isSelected {
                    UPDATE.updateData(["delivery_address": FieldValue.arrayUnion([self.ADDRESS])]) { error in
                        if error != nil { UPDATE.setData(["delivery_address": [self.ADDRESS]], merge: true) }
                    }
                }; UPDATE.setData(["point": "\(self.POINT-self.PRICE3)"], merge: true)
                
                Firestore.firestore().collection("legonggu_basket").document(MEMBER_ID).updateData([self.OBJ_BASKET[self.POSITION].ITEM_NAME: FieldValue.delete()])
                
                self.navigationController?.popViewController(animated: false, completion: {
                    if let BVC1 = UIViewController.VC_BASKET_DEL {
                        BVC1.navigationController?.popViewController(animated: false, completion: {
                            if let TBC = UIViewController.TabBarControllerDelegate { TBC.selectedIndex = 4
                                DispatchQueue.main.async {
                                    let VC1 = TBC.storyboard?.instantiateViewController(withIdentifier: "VC_ORDER1") as! VC_ORDER1
                                    TBC.navigationController?.pushViewController(VC1, animated: false, completion: {
                                        let VC2 = TBC.storyboard?.instantiateViewController(withIdentifier: "VC_ORDER2") as! VC_ORDER2
                                        VC2.KEY = "\(TIMESTAMP)"
                                        TBC.navigationController?.pushViewController(VC2, animated: true)
                                    })
                                }
                            }
                        })
                    } else if let BVC2 = UIViewController.VC_LEGONGGU2_DEL {
                        BVC2.navigationController?.popViewController(animated: false, completion: {
                            if let TBC = UIViewController.TabBarControllerDelegate { TBC.selectedIndex = 4
                                DispatchQueue.main.async {
                                    let VC1 = TBC.storyboard?.instantiateViewController(withIdentifier: "VC_ORDER1") as! VC_ORDER1
                                    TBC.navigationController?.pushViewController(VC1, animated: false, completion: {
                                        let VC2 = TBC.storyboard?.instantiateViewController(withIdentifier: "VC_ORDER2") as! VC_ORDER2
                                        VC2.KEY = "\(TIMESTAMP)"
                                        TBC.navigationController?.pushViewController(VC2, animated: true)
                                    })
                                }
                            }
                        })
                    }
                })
            } else {
                self.S_NOTICE("주문실패: 고객센터에 문의하세요")
            }
        }
    }
}
