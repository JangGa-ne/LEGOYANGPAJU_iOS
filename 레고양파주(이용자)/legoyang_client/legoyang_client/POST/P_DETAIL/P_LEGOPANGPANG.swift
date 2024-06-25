//
//  P_LEGOPANGPANG.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/30.
//

import UIKit
import FirebaseFirestore

extension VC_LEGOPANGPANG {
    
    func PUT_LEGOPANGPANG(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        let USER = UIViewController.appDelegate.OBJ_USER
        let DATA = OBJ_STORE[OBJ_POSITION]
        
        let TIMESTAMP = "\(Int(floor(Date().timeIntervalSince1970 * 1000)))"
        let PARAMETERS1: [String: Any] = [
            TIMESTAMP: [
                "receive_time": TIMESTAMP,
                "review_idx": "",
                "use_menu": DATA.PP_MENU,
                "use_nick": USER.NICK,
                "use_num": USER.NUMBER,
                "use_time": "0",
                "write_review": "false"
            ]
        ]
        let PARAMETERS2: [String: Any] = [
            TIMESTAMP: [
                "receive_time": TIMESTAMP,
                "review_idx": "",
                "use_menu": DATA.PP_MENU,
                "use_store_id": DATA.ST_ID,
                "use_store_name": DATA.ST_NAME,
                "use_time": "0",
                "write_review": "false"
            ]
        ]
        
        var ERROR: Bool = false
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        Firestore.firestore().collection("pangpang_history").document(DATA.ST_ID).setData(PARAMETERS1, merge: true) { error in if error == nil { ERROR = false } else { ERROR = true }
            Firestore.firestore().collection("member_pangpang_history").document(MEMBER_ID).setData(PARAMETERS2, merge: true) { error in if error == nil { ERROR = false } else { ERROR = true }
                if !ERROR { self.S_NOTICE("레고팡팡 발급됨"); UIViewController.VC_LEGOPANGPANG_DEL = nil } else { self.S_NOTICE("오류 (!)") }; self.dismiss(animated: true, completion: nil); self.TOUCH = false
            }
        }
    }
}
