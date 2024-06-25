//
//  P_FIND.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2023/01/03.
//

import UIKit
import FirebaseFirestore
import SwiftSMTP

extension VC_FIND {
    
    func PUT_EMAIL(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        UserDefaults.standard.setValue(Int.random(in: 100000...999999), forKey: "signcheck")
        
        let EMAIL_SMTP = SMTP(hostname: "smtp.gmail.com", email: "blinkcorpad@gmail.com", password: "rzmqrnfejazdupti")
        let EMAIL_FROM = Mail.User(name: "블링크코퍼레이션", email: "blinkcorpad@gmail.com")
        let EMAIL_TO = Mail.User(name: NAME_TF2.text!, email: SIGN_TF2.text!)
        let EMAIL_CONTENT = Mail(from: EMAIL_FROM, to: [EMAIL_TO], subject: "블링크코퍼레이션", text: "[레고양파주] 인증번호[\(UserDefaults.standard.string(forKey: "signcheck")!)]를 화면에 입력해주세요")
        
        EMAIL_SMTP.send(EMAIL_CONTENT); self.S_NOTICE("인증번호 요청됨"); UserDefaults.standard.setValue(self.SIGN_TF2.text!+(UserDefaults.standard.string(forKey: "signcheck")!), forKey: "emailcheck")
        
        NUMBER_TF2.becomeFirstResponder()
    }
    
    func GET_USER(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        if SIGN_TYPE == "phone" {
            
            Firestore.firestore().collection(AC_TYPE).whereField("name", isEqualTo: NAME_TF1.text!).whereField("number", isEqualTo: SIGN_TF1.text!).getDocuments { snapshot, error in
                
                S_INDICATOR(self.view, animated: false)
                
                if let response = snapshot {
                    
                    if response.documents.count > 0 {
                        
                        var PLATFORM: String = "lego"
                        
                        for response in response.documents { UserDefaults.standard.setValue(response.documentID, forKey: "document")
                            PLATFORM = response.data()["platform"] as? String ?? "lego"
                            self.ID_L.text = "아이디는 \'\(response.data()["id"] as? String ?? "")\'입니다."
                        }; S_INDICATOR(self.view, animated: false)
                        
                        if PLATFORM == "naver" {
                            self.S_NOTICE("NAVER로 가입된 이력 있음")
                        } else if PLATFORM == "kakao" {
                            self.S_NOTICE("KAKAO로 가입된 이력 있음")
                        } else {
                            self.PUT_BOOTPAY1(NAME: "휴대전화 본인인증", AC_TYPE: "bootpay", US_PHONE: self.SIGN_TF1.text!)
                        }; return
                    }
                }; self.S_NOTICE("등록된 회원정보 없음"); self.NAME_TF1.text?.removeAll(); self.SIGN_TF1.text?.removeAll()
            }
        } else if SIGN_TYPE == "email" {
            
            Firestore.firestore().collection(AC_TYPE).whereField("name", isEqualTo: NAME_TF2.text!).whereField("email", isEqualTo: SIGN_TF2.text!).getDocuments { snapshot, error in
                
                S_INDICATOR(self.view, animated: false)
                
                if let response = snapshot {
                    
                    if response.documents.count > 0 {
                        
                        var PLATFORM: String = "lego"
                        
                        for response in response.documents { UserDefaults.standard.setValue(response.documentID, forKey: "document")
                            PLATFORM = response.data()["platform"] as? String ?? "lego"
                            self.ID_L.text = "회원님의 아이디는 \'\(response.data()["id"] as? String ?? "")\'입니다."
                        }; S_INDICATOR(self.view, animated: false)
                        
                        if PLATFORM == "naver" {
                            self.S_NOTICE("NAVER로 가입된 이력 있음")
                        } else if PLATFORM == "kakao" {
                            self.S_NOTICE("KAKAO로 가입된 이력 있음")
                        } else {
                            self.PUT_EMAIL(NAME: "이메일 본인인증", AC_TYPE: "smtp")
                        }; return
                    }
                }; self.S_NOTICE("등록된 회원정보 없음"); self.NAME_TF2.text?.removeAll(); self.SIGN_TF2.text?.removeAll(); self.NUMBER_TF2.text?.removeAll()
            }
        }
    }
    
    func SET_PASSWORD(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "document") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).setData(["password": PW_TF2.text!], merge: true) { error in
            if error == nil { self.S_NOTICE("비밀번호 변경됨"); self.navigationController?.popViewController(animated: true) } else { self.S_NOTICE("오류 (!)") }
        }
    }
}

