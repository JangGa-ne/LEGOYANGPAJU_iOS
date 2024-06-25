//
//  P_MAP1.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/02/08.
//

import UIKit
import FirebaseFirestore

extension VC_MAP1 {
    
    func GET_CATEGORY(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        // 데이터 삭제
        OBJ_CATEGORY.removeAll(); self.TABLEVIEW.reloadData()
        
        Firestore.firestore().collection(AC_TYPE).getDocuments { document, error in
            
            if let document = document {
                
                for response in document.documents {
                    
                    let DICT = response.data()
                    let AP_VALUE = API_CATEGORY()
                    
                    AP_VALUE.SET_NAME(NAME: response.documentID)
                    AP_VALUE.SET_COUNT(COUNT: DICT["count"] as Any)
                    AP_VALUE.SET_IMG_URL(IMG_URL: DICT["img_url"] as Any)
                    AP_VALUE.SET_PP_COUNT(PP_COUNT: DICT["pangpang_count"] as Any)
                    // 데이터 추가
                    self.OBJ_CATEGORY.append(AP_VALUE)
                }; self.OBJ_CATEGORY.sort { front, behind in front.COUNT > behind.COUNT }
            }
            
            for (I, DATA) in self.OBJ_CATEGORY.enumerated() { if DATA.NAME == "맛집" { self.OBJ_POSITION = I; break } }; self.TABLEVIEW.reloadData()
        }
    }
}
