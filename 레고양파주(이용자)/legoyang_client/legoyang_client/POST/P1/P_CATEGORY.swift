//
//  P_CATEGORY.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/16.
//

import UIKit
import FirebaseFirestore

extension VC_CATEGORY {
    
    func GET_CATEGORY(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        // 데이터 삭제
        OBJ_CATEGORY.removeAll(); TABLEVIEW.reloadData()
        
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
            }; self.TABLEVIEW.reloadData()
        }
    }
}

// var <#name#>: String = ""
// func SET_<#name#>(<#name#>: Any) { self.<#name#> = <#name#> as? String ?? "" }

class API_CATEGORY {
    
    var NAME: String = ""
    var COUNT: Int = 0
    var IMG_URL: String = ""
    var PP_COUNT: Int = 0
    
    func SET_NAME(NAME: Any) { self.NAME = NAME as? String ?? "" }
    func SET_COUNT(COUNT: Any) { self.COUNT = COUNT as? Int ?? 0 }
    func SET_IMG_URL(IMG_URL: Any) { self.IMG_URL = IMG_URL as? String ?? "" }
    func SET_PP_COUNT(PP_COUNT: Any) { self.PP_COUNT = PP_COUNT as? Int ?? 0 }
}
