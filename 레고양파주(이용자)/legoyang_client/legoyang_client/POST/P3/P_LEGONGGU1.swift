//
//  P_LEGONGGU1.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/13.
//

import UIKit
import FirebaseFirestore

extension VC_LEGONGGU1 {
    
    func GET_LEGONGGU(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        // 데이터 삭제
        OBJ_LEGONGGU.removeAll(); TABLEVIEW.reloadData()
        
        Firestore.firestore().collection(AC_TYPE).getDocuments { response, error in
            
            if let response = response {
                
                for response in response.documents {
                    
                    let DICT = response.data()
                    let AP_VALUE = API_LEGONGGU()
                    
                    AP_VALUE.SET_END_TIME(END_TIME: DICT["end_time"] as Any)
                    AP_VALUE.SET_ITEM_BASEPRICE(ITEM_BASEPRICE: DICT["item_baseprice"] as Any)
                    AP_VALUE.SET_ITEM_CONTENT(ITEM_CONTENT: DICT["item_content"] as Any)
                    AP_VALUE.SET_ITEM_IMG(ITEM_IMG: DICT["item_img"] as? [Any] ?? [])
                    AP_VALUE.SET_ITEM_MAINIMG(ITEM_MAINIMG: DICT["item_mainimg"] as Any)
                    AP_VALUE.SET_ITEM_NAME(ITEM_NAME: DICT["item_name"] as Any)
                    AP_VALUE.SET_ITEM_PRICE(ITEM_PRICE: DICT["item_price"] as Any)
                    AP_VALUE.SET_ITEM_SALEINFO(ITEM_SALEINFO: DICT["item_saleinfo"] as Any)
                    AP_VALUE.SET_REMAIN_COUNT(REMAIN_COUNT: DICT["remain_count"] as Any)
                    // 데이터 추가
                    self.OBJ_LEGONGGU.append(AP_VALUE)
                }
            } else {
                
            }; self.TABLEVIEW.reloadData()
        }
    }
}

// var <#name#>: String = ""
// func SET_<#name#>(<#name#>: Any) { self.<#name#> = <#name#> as? String ?? "" }

class API_LEGONGGU {
    
    var END_TIME: String = ""
    var ITEM_BASEPRICE: String = ""
    var ITEM_CONTENT: String = ""
    var ITEM_IMG: [String] = []
    var ITEM_MAINIMG: String = ""
    var ITEM_NAME: String = ""
    var ITEM_PRICE: String = ""
    var ITEM_SALEINFO: String = ""
    var ORDER_ITEMARRAY: [API_ORDER_ITEMARRAY] = []
    var REMAIN_COUNT: Int = 0
    
    func SET_END_TIME(END_TIME: Any) { self.END_TIME = END_TIME as? String ?? "" }
    func SET_ITEM_BASEPRICE(ITEM_BASEPRICE: Any) { self.ITEM_BASEPRICE = ITEM_BASEPRICE as? String ?? "" }
    func SET_ITEM_CONTENT(ITEM_CONTENT: Any) { self.ITEM_CONTENT = ITEM_CONTENT as? String ?? "" }
    func SET_ITEM_IMG(ITEM_IMG: [Any]) { self.ITEM_IMG = ITEM_IMG as? [String] ?? [] }
    func SET_ITEM_MAINIMG(ITEM_MAINIMG: Any) { self.ITEM_MAINIMG = ITEM_MAINIMG as? String ?? "" }
    func SET_ITEM_NAME(ITEM_NAME: Any) { self.ITEM_NAME = ITEM_NAME as? String ?? "" }
    func SET_ITEM_PRICE(ITEM_PRICE: Any) { self.ITEM_PRICE = ITEM_PRICE as? String ?? "" }
    func SET_ITEM_SALEINFO(ITEM_SALEINFO: Any) { self.ITEM_SALEINFO = ITEM_SALEINFO as? String ?? "" }
    func SET_ORDER_ITEMARRAY(ORDER_ITEMARRAY: Any) { self.ORDER_ITEMARRAY = ORDER_ITEMARRAY as? [API_ORDER_ITEMARRAY] ?? [] }
    func SET_REMAIN_COUNT(REMAIN_COUNT: Any) { self.REMAIN_COUNT = REMAIN_COUNT as? Int ?? 0 }
}
