//
//  P_DETAIL2.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/26.
//

import UIKit
import Alamofire

// 배송조회
extension VC_DETAIL2 {
    
    func GET_ORDER(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        do {
            
            let DICT = try JSONSerialization.jsonObject(with: Data(UIViewController.appDelegate.MemberObject.noticeList[position].data.utf8), options: []) as? [String: Any]
            
            if let ARRAY1 = [DICT?["legonggu_data"]] as? Array<Any>, (ARRAY1.count > 0) {
                
                let DICT = ARRAY1[0] as? [String: Any]
                
                ITEM_IMG = DICT?["item_mainimg"] as? String ?? ""
                ITEM_NAME = DICT?["item_name"] as? String ?? ""
            }
            if let ARRAY2 = [DICT?["order_detail"]] as? Array<Any>, (ARRAY2.count > 0) {
                
                let DICT = ARRAY2[0] as? [String: Any]
                
                ITEM_TIME = DICT?["order_time"] as? String ?? ""
                GET_DELIVERY(NAME: "배송조회", AC_TYPE: "delivery", DL_COMPANY: DELIVERY_COMPANY[DICT?["delivery_company"] as? String ?? ""] ?? "", DL_NUMBER: DICT?["invoice_number"] as? String ?? "")
            }
        } catch {
            
        }
    }
}

extension VC_DETAIL2 {
    
    func GET_DELIVERY(NAME: String, AC_TYPE: String, DL_COMPANY: String, DL_NUMBER: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        // 데이터 삭제
        OBJ_DELIVERY.removeAll(); TABLEVIEW.reloadData()
        
        let MANAGER = Alamofire.Session.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 5
        MANAGER.request("https://apis.tracker.delivery/carriers/\(DL_COMPANY)/tracks/\(DL_NUMBER)", method: .get, parameters: nil).responseJSON { response in
            
            let DICT = response.value as? [String: Any]
            let AP_VALUE = API_DELIVERY()
            
            AP_VALUE.SET_CARRIER_ID(CARRIER_ID: (DICT?["carrier"] as? [String: Any])?["id"] as Any)
            AP_VALUE.SET_CARRIER_NAME(CARRIER_NAME: (DICT?["carrier"] as? [String: Any])?["name"] as Any)
            AP_VALUE.SET_CARRIER_TEL(CARRIER_TEL: (DICT?["carrier"] as? [String: Any])?["tel"] as Any)
            AP_VALUE.SET_FROM_NAME(FROM_NAME: (DICT?["from"] as? [String: Any])?["name"] as Any)
            AP_VALUE.SET_FROM_TIME(FROM_TIME: (DICT?["from"] as? [String: Any])?["time"] as Any)
            AP_VALUE.SET_PROGRESSES(PROGRESSES: self.SET_PROGRESSES(ARRAY: DICT?["progresses"] as? [Any] ?? []))
            AP_VALUE.SET_STATE_ID(STATE_ID: (DICT?["state"] as? [String: Any])?["id"] as Any)
            AP_VALUE.SET_STATE_TEXT(STATE_TEXT: (DICT?["state"] as? [String: Any])?["text"] as Any)
            AP_VALUE.SET_TO_NAME(TO_NAME: (DICT?["to"] as? [String: Any])?["name"] as Any)
            AP_VALUE.SET_TO_TIME(TO_TIME: (DICT?["to"] as? [String: Any])?["time"] as Any)
            // 데이터 추가
            self.OBJ_DELIVERY.append(AP_VALUE)
            
            if self.OBJ_DELIVERY.count > 0 {
                self.DELIVERY_L1.text = self.DT_CHECK(self.OBJ_DELIVERY[0].CARRIER_ID)
                self.DELIVERY_L2.text = self.DT_CHECK(self.OBJ_DELIVERY[0].CARRIER_NAME)
            }; self.TABLEVIEW.reloadData()
        }
    }
    
    func SET_PROGRESSES(ARRAY: [Any]) -> [API_PROGRESSES] {
        
        var OBJ_PROGRESSES: [API_PROGRESSES] = []
        
        for (_, DATA) in ARRAY.enumerated() {
            
            let DICT = DATA as? [String: Any]
            let AP_VALUE = API_PROGRESSES()
            
            AP_VALUE.SET_DESCRIPTION(DESCRIPTION: DICT?["description"] as Any)
            AP_VALUE.SET_LOCATION_NAME(LOCATION_NAME: (DICT?["location"] as? [String: Any])?["name"] as Any)
            AP_VALUE.SET_STATUS_ID(STATUS_ID: (DICT?["status"] as? [String: Any])?["id"] as Any)
            AP_VALUE.SET_STATUS_TEXT(STATUS_TEXT: (DICT?["status"] as? [String: Any])?["text"] as Any)
            AP_VALUE.SET_TIME(TIME: DICT?["time"] as Any)
            // 데이터 추가
            OBJ_PROGRESSES.append(AP_VALUE)
        }; OBJ_PROGRESSES.sort { front, behind in front.TIME > behind.TIME }
        
        return OBJ_PROGRESSES
    }
}

// var <#name#>: String = ""
// func SET_<#name#>(<#name#>: Any) { self.<#name#> = <#name#> as? String ?? "" }

class API_DELIVERY {
    
    var CARRIER_ID: String = ""
    var CARRIER_NAME: String = ""
    var CARRIER_TEL: String = ""
    var FROM_NAME: String = ""
    var FROM_TIME: String = ""
    var PROGRESSES: [API_PROGRESSES] = []
    var STATE_ID: String = ""
    var STATE_TEXT: String = ""
    var TO_NAME: String = ""
    var TO_TIME: String = ""
    
    func SET_CARRIER_ID(CARRIER_ID: Any) { self.CARRIER_ID = CARRIER_ID as? String ?? "" }
    func SET_CARRIER_NAME(CARRIER_NAME: Any) { self.CARRIER_NAME = CARRIER_NAME as? String ?? "" }
    func SET_CARRIER_TEL(CARRIER_TEL: Any) { self.CARRIER_TEL = CARRIER_TEL as? String ?? "" }
    func SET_FROM_NAME(FROM_NAME: Any) { self.FROM_NAME = FROM_NAME as? String ?? "" }
    func SET_FROM_TIME(FROM_TIME: Any) { self.FROM_TIME = FROM_TIME as? String ?? "" }
    func SET_PROGRESSES(PROGRESSES: Any) { self.PROGRESSES = PROGRESSES as? [API_PROGRESSES] ?? [] }
    func SET_STATE_ID(STATE_ID: Any) { self.STATE_ID = STATE_ID as? String ?? "" }
    func SET_STATE_TEXT(STATE_TEXT: Any) { self.STATE_TEXT = STATE_TEXT as? String ?? "" }
    func SET_TO_NAME(TO_NAME: Any) { self.TO_NAME = TO_NAME as? String ?? "" }
    func SET_TO_TIME(TO_TIME: Any) { self.TO_TIME = TO_TIME as? String ?? "" }
}

class API_PROGRESSES {
    
    var DESCRIPTION: String = ""
    var LOCATION_NAME: String = ""
    var STATUS_ID: String = ""
    var STATUS_TEXT: String = ""
    var TIME: String = ""
    
    func SET_DESCRIPTION(DESCRIPTION: Any) { self.DESCRIPTION = DESCRIPTION as? String ?? "" }
    func SET_LOCATION_NAME(LOCATION_NAME: Any) { self.LOCATION_NAME = LOCATION_NAME as? String ?? "" }
    func SET_STATUS_ID(STATUS_ID: Any) { self.STATUS_ID = STATUS_ID as? String ?? "" }
    func SET_STATUS_TEXT(STATUS_TEXT: Any) { self.STATUS_TEXT = STATUS_TEXT as? String ?? "" }
    func SET_TIME(TIME: Any) { self.TIME = TIME as? String ?? "" }
}
