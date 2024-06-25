//
//  P_SIGNUP.swift
//  legoyang
//
//  Created by 장 제현 on 2022/10/19.
//

import UIKit
import FirebaseFirestore
import FirebaseMessaging

extension VC_SIGNUP {
    
    func PUT_SIGNUP(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        let PARAMETERS: [String: Any] = [
            "benefit_point": "0",
            "fcm_id": UserDefaults.standard.string(forKey: "fcm_id") ?? "",
            "free_delivery_coupon": 0,
            "email": self.EMAIL_TF.text!,
            "grade": "1",
            "id": self.ID_TF.text!,
            "name": self.NAME_TF.text!,
            "nick": self.NICK_TF.text!,
            "os_platform": "ios",
            "password": self.PW_TF1.text!,
            "number": self.PHONE_TF.text!.replacingOccurrences(of: "-", with: ""),
            "platform": TYPE,
            "point": "0",
            "profile_img": PROFILE_IMG,
            "legonggu_topic": "true",
            "pangpang_topic": "true",
            "signup_time": "\(setKoreaTimestamp()+32400000)",
        ]
        
        let MEMBER_ID = self.PHONE_TF.text!.replacingOccurrences(of: "-", with: "")
        Firestore.firestore().collection(AC_TYPE).whereField("number", isEqualTo: MEMBER_ID).getDocuments { response, error in
            
            if let response = response {
                
                if response.count > 0 {
                    self.S_NOTICE("이미 등록된 회원")
                } else {
                    
                    Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).setData(PARAMETERS, merge: true) { error in
                        
                        if error == nil {
                            if self.TYPE == "naver" { self.S_NOTICE("NAVER로 회원가입 성공") } else if self.TYPE == "kakao" { self.S_NOTICE("KAKAO로 회원가입 성공") } else if self.TYPE == "lego" { self.S_NOTICE("회원가입 성공") }
                            UserDefaults.standard.setValue(MEMBER_ID, forKey: "member_id")
                            UserDefaults.standard.synchronize(); self.segueViewController(identifier: "LoadingViewController")
                        } else {
                            self.S_NOTICE("회원가입 실패")
                        }
                    }
                }
            }
        }
    }
}
