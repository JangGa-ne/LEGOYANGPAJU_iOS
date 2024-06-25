//
//  S_BOOTPAY.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2023/01/01.
//

import UIKit
import Bootpay
import Alamofire

extension UIViewController {
    
    func PUT_BOOTPAY(NAME: String, AC_TYPE: String, US_PHONE: String) {
        
        UserDefaults.standard.setValue(false, forKey: "phonecheck")
        
        let PAYLOAD = Payload()
        PAYLOAD.applicationId = "63718f88cf9f6d002023e415"
        PAYLOAD.pg = "다날"
        PAYLOAD.method = "본인인증"
        PAYLOAD.orderName = "본인인증"
        PAYLOAD.orderId = String(NSTimeIntervalSince1970)
        PAYLOAD.price = 0
        
        let USER = BootUser()
        USER.phone = US_PHONE
        PAYLOAD.user = USER
                
        Bootpay.requestAuthentication(viewController: self, payload: PAYLOAD)
            .onCancel { data in
//                print("-- cancel: \(data)")
            }
            .onIssued { data in
//                print("-- issued: \(data)")
            }
            .onConfirm { data in
//                print("-- confirm: \(data)")
                return true //재고가 있어서 결제를 최종 승인하려 할 경우
//                Bootpay.transactionConfirm()
//                return false //재고가 없어서 결제를 승인하지 않을때
            }
            .onDone { data in
//                print("-- done: \(data)")
                UserDefaults.standard.setValue(true, forKey: "phonecheck"); self.S_NOTICE("본인인증 확인됨")
            }
            .onError { data in
//                print("-- error: \(data)")
                let DICT = data as [String: Any]
                self.S_NOTICE(DICT["message"] as? String ?? "")
            }
            .onClose {
//                print("-- close")
            }; segueViewController(identifier: "VC_SIGNCHECK")
    }
    
//    func GET_TOKEN(NAME: String, AC_TYPE: String, RECEIPT_ID: String) {
//
//        let apiUrl = "https://api.bootpay.co.kr/v2/request/token"
//
//        let HEADERS: HTTPHeaders = [
//            "Content-Type": "application/json"
//        ]
//
//        let PARAMETERS: Parameters = [
//            "application_id": "63718f88cf9f6d002023e416",
//            "private_key": "HGdzsICnCSG+4XHK3Q8J5UTIDkluHFBbMNH0IDqjL/U="
//        ]
//
//        let MANAGER = Alamofire.Session.default
//        MANAGER.session.configuration.timeoutIntervalForRequest = 5
//        MANAGER.request(apiUrl, method: .post, parameters: PARAMETERS, encoding: JSONEncoding.default, headers: HEADERS).responseJSON { response in
//
//            print("[\(NAME)]", response)
//
//            switch response.result {
//            case .success(_):
//                if let DICT = response.value as? [String: Any] {
//                    if DICT["access_token"] as? String ?? "" != "" {
//                        self.GET_BOOTPAY(NAME: "본인인증", AC_TYPE: "", RECEIPT_ID: RECEIPT_ID, TOKEN: DICT["access_token"] as? String ?? ""); return
//                    }
//                }; break
//            case .failure(_):
//                break
//            }
//        }
//    }
//
//    func GET_BOOTPAY(NAME: String, AC_TYPE: String, RECEIPT_ID: String, TOKEN: String) {
//
//        let apiUrl = "https://api.bootpay.co.kr/v2/certificate/\(RECEIPT_ID)"
//
//        let HEADERS: HTTPHeaders = [
//            "Content-Type": "application/json",
//            "Authorization": TOKEN
//        ]
//
//        let PARAMETERS: Parameters = [
//            "id": RECEIPT_ID
//        ]
//
//        let MANAGER = Alamofire.Session.default
//        MANAGER.session.configuration.timeoutIntervalForRequest = 5
//        MANAGER.request(apiUrl, method: .post, parameters: PARAMETERS, encoding: JSONEncoding.default, headers: HEADERS).responseJSON { response in
//
//            print("[\(NAME)]", response)
//
//            switch response.result {
//            case .success(_): print("[\(NAME)]", response)
//                if let DICT = response.value as? [String: Any] {
//                    if DICT["receipt_id"] as? String ?? "" == "" {
//                        return
//                    }
//                }; break
//            case .failure(_):
//                self.S_NOTICE("응답 에러")
//                break
//            }
//        }
//    }
}
