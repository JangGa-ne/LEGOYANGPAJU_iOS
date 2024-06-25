//
//  OrderDataAPI.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/18.
//

import UIKit
import Bootpay
import FirebaseFirestore

extension OrderViewController {
    
    func bootpay() {
        
        let payload = Payload()
        payload.applicationId = "63718f88cf9f6d002023e415"
        payload.price = Double(itemPrice+deliveryPrice-lepaypointPrice)
        payload.authenticationId = String(NSTimeIntervalSince1970)
        payload.pg = "payletter"
        payload.method = paymentType
        payload.orderId = String(NSTimeIntervalSince1970)
        payload.orderName = "레고양파주 결제: \(basketLabel.text!)"
        
        let bootUser = BootUser()
        bootUser.username = ordererNameTextfield.text!
        bootUser.phone = ordererNumberTextfield.text!.replacingOccurrences(of: "-", with: "")
        payload.user = bootUser
        
        let bootExtra = BootExtra()
        bootExtra.cardQuota = "0,2,3"
        bootExtra.displaySuccessResult = true
        payload.extra = bootExtra
        
        let item = BootItem()
        item.name = basketLabel.text!
        item.qty = 1
        item.id = "item_01"
        item.price = Double(itemPrice+deliveryPrice-lepaypointPrice)
        payload.items = [item]
        
        Bootpay.requestPayment(viewController: self, payload: payload)
        .onCancel { data in
            print("-- cancel: \(data)")
        }
        .onIssued { data in
            print("-- issued: \(data)")
        }
        .onConfirm { data in
            print("-- confirm: \(data)")
            return true
        }
        .onDone { data in
            print("-- done: \(data)")
            
            let dict = data["data"] as? [String: Any] ?? [:]
            let receiptId = dict["receipt_id"] as? String ?? ""
            
            self.order(receiptId: receiptId)
        }
        .onError { data in
            print("-- error: \(data)")
            
            let dict = data["data"] as? [String: Any] ?? [:]
            let message = dict["message"] as? String ?? ""
            
            if !(message.contains("100")) { self.setAlert(title: "", body: message, style: .alert, time: 2) }
        }
        .onClose {
            print("-- close")
        }
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_SIGNCHECK") as! VC_SIGNCHECK
        VC.TITLE = "레공구 결제하기"
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func order(receiptId: String) {
        
        S_INDICATOR(self.view, text: "주문결제 요청중...", animated: true)
        
        var itemCount: Int = 0
        var baskets: [Any] = []
        
        for data in BasketObject {
            
            itemCount += (Int(data.itemCount) ?? 0)
            
            baskets.append([
                "freedelivery_coupon_use": data.freeDeliveryCouponUse,
                "item_count": data.itemCount,
                "item_name": data.itemName,
                "item_option": data.itemOption,
                "item_options": data.itemOptions,
                "item_price": data.itemPrice
            ])
        }
        
        let timestamp = setKoreaTimestamp()
        let params: [String: Any] = [
            "\(timestamp)": [
                "delivery_company": "",
                "invoice_number": "",
                "lepay_discount": "\(lepaypointPrice)",
                "grade": UIViewController.appDelegate.MemberObject.grade,
                "order_benefit_point": benefitPointLabel.text!.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: ""),
                "order_complete": "false",
                "order_deliveryfee": "\(deliveryPrice)",
                "order_itemprice": "\(itemPrice)",
                "order_itemarray": baskets,
                "order_return": "false",
                "order_state": "배송전",
                "order_time": "\(timestamp)",
                "order_totaldiscount": "\(lepaypointPrice)",
                "order_totalprice": "\(itemPrice+deliveryPrice)",
                "order_trade": "false",
                "order_wrong_image": [],
                "order_wrong_message": "",
                "order_wrong_type": "",
                "orderman_name": ordererNameTextfield.text!,
                "orderman_number": ordererNumberTextfield.text!.replacingOccurrences(of: "-", with: ""),
                "receipt_id": receiptId,
                "receiver_address": address,
                "receiver_memo": memoTextfield.text!,
                "receiver_name": recieverNameTextfield.text!,
                "receiver_number1": (recieverNumberTextfield_1_1.text!+recieverNumberTextfield_1_2.text!+recieverNumberTextfield_1_3.text!),
                "receiver_number2": (recieverNumberTextfield_2_1.text!+recieverNumberTextfield_2_2.text!+recieverNumberTextfield_2_3.text!)
            ]
        ]
        
        Firestore.firestore().collection("legonggu_order_detail").document(UIViewController.appDelegate.MemberId).setData(params, merge: true) { error in
            
            if error == nil {
                
                Firestore.firestore().collection("orderlist_bygonggu").document(self.basketLabel.text!).updateData([UIViewController.appDelegate.MemberId: FieldValue.arrayUnion(["\(timestamp)"])]) { error in
                    if error != nil { Firestore.firestore().collection("orderlist_bygonggu").document(self.basketLabel.text!).setData([UIViewController.appDelegate.MemberId: ["\(timestamp)"]], merge: true) }
                }
                
                // 레공구 아이템 카운트
                Firestore.firestore().collection("legonggu_item").document(self.basketLabel.text!).getDocument { response, error in
                    Firestore.firestore().collection("legonggu_item").document(self.basketLabel.text!).setData(["remain_count": (response?.data()?["remain_count"] as? Int ?? 0)-itemCount], merge: true)
                }
                // 멤버 배송지 등록
                if self.addressButton_2.isSelected && self.addressAppendButton.isSelected {
                    UIViewController.appDelegate.MemberObject.deliveryAddress.append("\(self.addressTextfield_1.text!) \(self.addressTextfield_2.text!)")
                }
                // 배송지 등록 및 포인트
                Firestore.firestore().collection("member").document(UIViewController.appDelegate.MemberId).setData(["delivery_address": UIViewController.appDelegate.MemberObject.deliveryAddress, "point": "\(self.lepayPoint-self.lepaypointPrice)"], merge: true)
                UIViewController.appDelegate.MemberObject.point = "\(self.lepayPoint-self.lepaypointPrice)"
                // 장바구니 삭제
                Firestore.firestore().collection("legonggu_basket").document(UIViewController.appDelegate.MemberId).updateData([self.basketLabel.text!: FieldValue.delete()])
                
                if let refresh = UIViewController.LoadingViewControllerDelegate {
                    refresh.loadingData3()
                }
                if let delegete_1 = UIViewController.LegongguViewControllerDelegate {
                    if delegete_1.detail { delegete_1.navigationController?.popViewController(animated: false) }
                }
                if let delegate_2 = UIViewController.LegongguDetailViewControllerDelegate {
                    delegate_2.navigationController?.popViewController(animated: false)
                }
                if let delegate_3 = UIViewController.BasketViewControllerDelegate {
                    delegate_3.navigationController?.popViewController(animated: false)
                }
                if let delegate_4 = UIViewController.TabBarControllerDelegate {
                    delegate_4.selectedIndex = 4
                    DispatchQueue.main.async {
                        let segue_1 = delegate_4.storyboard?.instantiateViewController(withIdentifier: "VC_ORDER1") as! VC_ORDER1
                        delegate_4.navigationController?.pushViewController(segue_1, animated: false, completion: {
                            let segue_2 = delegate_4.storyboard?.instantiateViewController(withIdentifier: "VC_ORDER2") as! VC_ORDER2
                            segue_2.KEY = "\(timestamp)"
                            delegate_4.navigationController?.pushViewController(segue_2, animated: true)
                        })
                    }
                }
            } else {
                
                S_INDICATOR(self.view, animated: false)
                
                self.setAlert(title: nil, body: "오류: 고객센터에 문의하세요", style: .actionSheet, time: 2)
            }
        }
    }
}
