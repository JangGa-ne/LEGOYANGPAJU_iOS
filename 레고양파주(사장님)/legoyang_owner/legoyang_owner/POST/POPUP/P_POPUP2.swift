//
//  P_POPUP2.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/11.
//

import UIKit
import FirebaseFirestore

extension VC_POPUP2 {
    
    func PUT_QUOTE_COLOR(NAME: String, AC_TYPE: String) {
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(STORE_ID).setData(["store_color": COLOR_DATA], merge: true)
        
        if let BVC1 = UIViewController.VC3_MAIN_DEL {
            BVC1.QUOTE_LEFT_I.image = UIImage(named: QUOTE_REFT[COLOR_DATA] ?? "quote_left0")
            BVC1.QUOTE_RIGHT_I.image = UIImage(named: QUOTE_RIGHT[COLOR_DATA] ?? "quote_right0")
        }; dismiss(animated: true, completion: nil)
    }
}
