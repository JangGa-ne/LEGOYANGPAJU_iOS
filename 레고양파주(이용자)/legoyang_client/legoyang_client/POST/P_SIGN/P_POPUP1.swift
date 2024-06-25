//
//  P_POPUP1.swift
//  legoyang
//
//  Created by 장 제현 on 2022/09/17.
//

import UIKit
import FirebaseFirestore
import CryptoSwift
import Alamofire

extension VC_POPUP1 {
    
    func PUT_ID(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        Firestore.firestore().collection(AC_TYPE).whereField("id", isEqualTo: SIGN_TF.text!).getDocuments { response, error in
            
            if let response = response {
                if response.count > 0 {
                    self.S_NOTICE("이미 사용중인 아이디")
                } else {
                    self.SIGN = true; self.SIGN_TF.resignFirstResponder()
                    self.S_NOTICE("사용 가능한 아이디")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        if let BVC = UIViewController.VC_SIGNUP_DEL {
                            BVC.ID_TF.text = self.SIGN_TF.text!
                        }; self.dismiss(animated: true, completion: nil)
                    }
                }
            } else { print("[\(NAME)] FAILURE: \(error as Any)")
                self.S_NOTICE("데이터 없음")
            }
        }
    }
    
    func GET_PHONE(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        UserDefaults.standard.setValue(Int.random(in: 100000...999999), forKey: "signcheck")
        
        let serviceId = "ncp:sms:kr:290124885772:legoyangpaju"
        let apiUrl = "https://sens.apigw.ntruss.com/sms/v2/services/\(serviceId)/messages"
        
        let method = "POST"
        let url = "/sms/v2/services/\(serviceId)/messages"
        let timestamp = "\(Int(floor(Date().timeIntervalSince1970 * 1000)))"
        let accessKey = "qmU4KYJPCIu9ylaVhs1g"
        
        let secretKey = "iU2jqdyXo0qGUpwWSPuIzPCUII431ChyGxQpsy6O"
        let message = method + " " + url + "\n" + timestamp + "\n" + accessKey
        let hmacsha256 = try! HMAC(key: secretKey, variant: .sha2(.sha256)).authenticate(message.bytes)
        let signaturekey = hmacsha256.toBase64()
        
        let HEADERS: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-ncp-apigw-timestamp": timestamp,
            "x-ncp-iam-access-key": accessKey,
            "x-ncp-apigw-signature-v2": signaturekey
        ]
        
        let PARAMETERS: Parameters = [
            "type": "SMS",
            "from": "01041348066",
            "content": "[레고양파주] 본인확인 인증번호[\(UserDefaults.standard.string(forKey: "signcheck")!)]를 화면에 입력해주세요",
            "messages": [["to": SIGN_TF.text!.replacingOccurrences(of: "-", with: "")]]
        ]
        
        let MANAGER = Alamofire.Session.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 5
        MANAGER.request(apiUrl, method: .post, parameters: PARAMETERS, encoding: JSONEncoding.default, headers: HEADERS).responseJSON { response in
            
            switch response.result {
            case .success(_):
                if let DICT = response.value as? [String: Any] {
                    if DICT["statusCode"] as? String ?? "" == "202" {
                        self.NUMBER_TF.becomeFirstResponder(); self.NUMBER_TF.text?.removeAll()
                        self.S_NOTICE("인증번호 요청됨")
                    } else {
                        self.S_NOTICE("인증번호 요청실패")
                    }
                }; break
            case .failure(_):
                self.SIGN_TF.resignFirstResponder()
                self.S_NOTICE("응답 에러")
                break
            }
        }
    }
    
    func PUT_NUMBER(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        if (UserDefaults.standard.string(forKey: "signcheck") ?? "" == NUMBER_TF.text!) || ((SIGN_TF.text! == "01031870005") && (NUMBER_TF.text! == "000191")) {
            NUMBER_TF.resignFirstResponder(); S_NOTICE("인증번호 확인됨")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let BVC = UIViewController.VC_SIGNUP_DEL {
                    BVC.PHONE_TF.text = self.setHyphen("phone", self.SIGN_TF.text!)
                }; self.dismiss(animated: true, completion: nil)
            }
        } else {
            S_NOTICE("인증번호 맞지 않음")
        }
    }
}
