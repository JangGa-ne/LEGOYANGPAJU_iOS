//
//  P_NOTICE.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/27.
//

import UIKit
import FirebaseFirestore

extension VC_NOTICE {
    
    func SET_NOTICE(NAME: String, AC_TYPE: String, TIMESTAMP: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).setData(["noti_list": [TIMESTAMP: ["readornot": "true"]]], merge: true)
    }
}
