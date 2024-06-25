//
//  P_LEGONGGU2.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/16.
//

import UIKit
import FirebaseFirestore

extension VC_LEGONGGU2 {
    
    func GET_OPTION(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        // 데이터 삭제
        OBJ_OPTION.removeAll()
        
        Firestore.firestore().collection(AC_TYPE).document(OBJ_LEGONGGU[OBJ_POSITION].ITEM_NAME).getDocument { response, error in
            
            if let response = response {
                
                let _: [()]? = response.data()?.compactMap({ (key: String, value: Any) in
                    
                    let AP_VALUE = API_OPTION()
                    
                    AP_VALUE.SET_OBJ_TYPE(OBJ_TYPE: self.SET_TYPE(ARRAY: response.data()?[key] as? [Any] ?? []))
                    // 데이터 추가
                    self.OBJ_OPTION.append(AP_VALUE)
                })
            }
        }
    }
    
    func SET_TYPE(ARRAY: [Any]) -> [API_TYPE] {
        
        var OBJ_TYPE: [API_TYPE] = []
        
        for (_, DATA) in ARRAY.enumerated() {
            
            let DICT = DATA as? [String: Any]
            let AP_VALUE = API_TYPE()
            
            AP_VALUE.SET_OPTION_NAME(OPTION_NAME: DICT?["option_name"] as Any)
            AP_VALUE.SET_OPTION_PRICE(OPTION_PRICE: DICT?["option_price"] as Any)
            AP_VALUE.SET_OPTION_TYPE(OPTION_TYPE: DICT?["option_type"] as Any)
            // 데이터 추가
            OBJ_TYPE.append(AP_VALUE)
        }
        
        return OBJ_TYPE
    }
}

// var <#name#>: String = ""
// func SET_<#name#>(<#name#>: Any) { self.<#name#> = <#name#> as? String ?? "" }

class API_OPTION {
    
    var OBJ_TYPE: [API_TYPE] = []
    
    func SET_OBJ_TYPE(OBJ_TYPE: [Any]) { self.OBJ_TYPE = OBJ_TYPE as? [API_TYPE] ?? [] }
}

class API_TYPE {
    
    var OPTION_NAME: String = ""
    var OPTION_PRICE: String = ""
    var OPTION_TYPE: String = ""
    
    func SET_OPTION_NAME(OPTION_NAME: Any) { self.OPTION_NAME = OPTION_NAME as? String ?? "" }
    func SET_OPTION_PRICE(OPTION_PRICE: Any) { self.OPTION_PRICE = OPTION_PRICE as? String ?? "" }
    func SET_OPTION_TYPE(OPTION_TYPE: Any) { self.OPTION_TYPE = OPTION_TYPE as? String ?? "" }
}
