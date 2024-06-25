//
//  P_FINDPW.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2023/01/03.
//

import UIKit
import FirebaseFirestore
import SwiftSMTP

extension VC_FINDPW {
    
    func PUT_EMAIL(NAME: String, AC_TYPE: String) {
        
        UserDefaults.standard.setValue(Int.random(in: 100000...999999), forKey: "signcheck")
        
        let EMAIL_SMTP = SMTP(hostname: "smtp.gmail.com", email: "blinkcorpad@gmail.com", password: "rzmqrnfejazdupti")
        let EMAIL_FROM = Mail.User(name: "블링크코퍼레이션", email: "blinkcorpad@gmail.com")
        let EMAIL_TO = Mail.User(name: NAME_TF2.text!, email: SIGN_TF2.text!)
        let EMAIL_CONTENT = Mail(from: EMAIL_FROM, to: [EMAIL_TO], subject: "블링크코퍼레이션", text: "[레고양파주] 인증번호[\(UserDefaults.standard.string(forKey: "signcheck")!)]를 화면에 입력해주세요")
        
        EMAIL_SMTP.send(EMAIL_CONTENT); self.S_NOTICE("인증번호 요청됨"); UserDefaults.standard.setValue(self.SIGN_TF2.text!+(UserDefaults.standard.string(forKey: "signcheck")!), forKey: "emailcheck")
        
        NUMBER_TF2.becomeFirstResponder()
    }
    
    func GET_USER(NAME: String, AC_TYPE: String) {
        
        if TYPE == "phone" {
            Firestore.firestore().collection(AC_TYPE).whereField("owner_name", isEqualTo: NAME_TF1.text!).whereField("owner_number", isEqualTo: SIGN_TF1.text!).getDocuments { snapshot, error in
                if let response = snapshot {
                    if response.documents.count > 0 {
                        for response in response.documents { UserDefaults.standard.setValue(response.documentID, forKey: "document") }
                        self.FIND_SV.isHidden = true; self.PW_SV.isHidden = false; self.SUBMIT_SV.isHidden = false; S_INDICATOR(self.view, animated: false); return
                    }
                }; self.S_NOTICE("등록된 회원정보 없음"); S_INDICATOR(self.view, animated: false); self.NAME_TF1.text?.removeAll(); self.SIGN_TF1.text?.removeAll()
            }
        } else if TYPE == "email" {
            Firestore.firestore().collection(AC_TYPE).whereField("owner_name", isEqualTo: NAME_TF2.text!).whereField("store_email", isEqualTo: SIGN_TF2.text!).getDocuments { snapshot, error in
                if let response = snapshot {
                    if response.documents.count > 0 {
                        for response in response.documents { UserDefaults.standard.setValue(response.documentID, forKey: "document") }
                        self.FIND_SV.isHidden = true; self.PW_SV.isHidden = false; self.SUBMIT_SV.isHidden = false; S_INDICATOR(self.view, animated: false); return
                    }
                }; self.S_NOTICE("등록된 회원정보 없음"); S_INDICATOR(self.view, animated: false); self.NAME_TF2.text?.removeAll(); self.SIGN_TF2.text?.removeAll(); self.NUMBER_TF2.text?.removeAll()
            }
        }
    }
    
    func SET_PASSWORD(NAME: String, AC_TYPE: String) {
        
        let STORE_ID = UserDefaults.standard.string(forKey: "document") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(STORE_ID).setData(["store_password": PW_TF2.text!], merge: true) { error in
            if error == nil { self.S_NOTICE("비밀번호 변경됨"); self.navigationController?.popViewController(animated: true) } else { self.S_NOTICE("오류 (!)") }
        }
    }
}
