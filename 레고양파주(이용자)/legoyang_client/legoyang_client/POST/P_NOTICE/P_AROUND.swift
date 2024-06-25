//
//  P_AROUND.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/02/20.
//

import UIKit
import FirebaseFirestore

extension VC_AROUND {
    
    func GET_AROUND(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        var STORE_IDS: [String] = []
        var DISTANCES: [String] = []
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).getDocument { response, error in
            
            if let response = response {
                
                let _: [()]? = response.data()?.compactMap({ (key: String, value: Any) in
                    if (response.data()?.count ?? 0) <= 10 {
                        STORE_IDS.append(key); DISTANCES.append(value as? String ?? "")
                    } else if (Double(value as? String ?? "") ?? 0.0 < 2.0) && (STORE_IDS.count <= 10) {
                        STORE_IDS.append(key); DISTANCES.append(value as? String ?? "")
                    } else if STORE_IDS.count <= 10 {
                        STORE_IDS.append(key); DISTANCES.append(value as? String ?? "")
                    }
                })
                
                for (I, STORE_ID) in STORE_IDS.enumerated() {
                    
                    Firestore.firestore().collection("store").document(STORE_ID).getDocument { response, error in
                        
                        if let response = response {
                            
                            let DICT = response.data()
                            let AP_VALUE = API_STORE()
                            
                            AP_VALUE.SET_DELIVERY_TIME(DELIVERY_TIME: DICT?["delivery_time"] as Any)
                            AP_VALUE.SET_DISTANCE(DISTANCE: DISTANCES[I] as Any)
                            AP_VALUE.SET_FCM_ID(FCM_ID: DICT?["fcm_id"] as Any)
                            AP_VALUE.SET_FOOD_TYPE(FOOD_TYPE: DICT?["food_type"] as Any)
                            AP_VALUE.SET_ITEM_STAMP(ITEM_STAMP: DICT?["item_stamp"] as Any)
                            AP_VALUE.SET_LAT(LAT: DICT?["lat"] as Any)
                            AP_VALUE.SET_LEDELIVERY_FEE(LEDELIVERY_FEE: DICT?["ledelivery_fee"] as Any)
                            AP_VALUE.SET_LEDELIVERY_TIME(LEDELIVERY_TIME: DICT?["ledelivery_time"] as Any)
                            AP_VALUE.SET_LIKE_COUNT(LIKE_COUNT: DICT?["like_count"] as Any)
                            AP_VALUE.SET_LON(LON: DICT?["lon"] as Any)
                            AP_VALUE.SET_MG_NAME(MG_NAME: DICT?["manager_name"] as Any)
                            AP_VALUE.SET_MG_PHONE(MG_PHONE: DICT?["manager_number"] as Any)
                            AP_VALUE.SET_ON_BIRTH(ON_BIRTH: DICT?["on_birth"] as Any)
                            AP_VALUE.SET_ON_NAME(ON_NAME: DICT?["owner_name"] as Any)
                            AP_VALUE.SET_ON_PHONE(ON_PHONE: DICT?["owner_number"] as Any)
                            AP_VALUE.SET_PP_IMAGE(PP_IMAGE: DICT?["pangpang_image"] as Any)
                            AP_VALUE.SET_PP_MENU(PP_MENU: DICT?["pangpang_menu"] as Any)
                            AP_VALUE.SET_PP_REMAIN(PP_REMAIN: DICT?["pangpang_remain"] as Any)
                            AP_VALUE.SET_POINT_COUNT(POINT_COUNT: DICT?["point_count"] as Any)
                            AP_VALUE.SET_ST_ADDRESS(ST_ADDRESS: DICT?["store_address"] as Any)
                            AP_VALUE.SET_ST_CASH(ST_CASH: DICT?["store_cash"] as Any)
                            AP_VALUE.SET_ST_CATEGORY(ST_CATEGORY: DICT?["store_category"] as Any)
                            AP_VALUE.SET_ST_COLOR(ST_COLOR: DICT?["store_color"] as Any)
                            AP_VALUE.SET_ST_EMAIL(ST_EMAIL: DICT?["store_email"] as Any)
                            AP_VALUE.SET_ST_ETC(ST_ETC: DICT?["store_etc"] as Any)
                            AP_VALUE.SET_ST_ID(ST_ID: DICT?["store_id"] as Any)
                            AP_VALUE.SET_ST_IMAGE(ST_IMAGE: DICT?["store_img"] as Any)
                            AP_VALUE.SET_ST_IMAGES(ST_IMAGES: DICT?["img_array"] as Any)
                            AP_VALUE.SET_ST_LASTORDER(ST_LASTORDER: DICT?["store_lastorder"] as Any)
                            AP_VALUE.SET_ST_MENU(ST_MENU: self.SET_ST_MENU(ARRAY: DICT?["store_menu"] as? [Any] ?? []))
                            AP_VALUE.SET_ST_NAME(ST_NAME: DICT?["store_name"] as Any)
                            AP_VALUE.SET_ST_OPEN(ST_OPEN: DICT?["store_openingtime"] as Any)
                            AP_VALUE.SET_ST_PW(ST_PW: DICT?["store_password"] as Any)
                            AP_VALUE.SET_ST_POINT(ST_POINT: DICT?["store_point"] as Any)
                            AP_VALUE.SET_ST_REGNUM(ST_REGNUM: DICT?["store_regnum"] as Any)
                            AP_VALUE.SET_ST_RESTDAY(ST_RESTDAY: DICT?["store_restday"] as Any)
                            AP_VALUE.SET_ST_SUB_TITLE(ST_SUB_TITLE: DICT?["store_sub_title"] as Any)
                            AP_VALUE.SET_ST_TAG(ST_TAG: DICT?["store_tag"] as Any)
                            AP_VALUE.SET_ST_TAX_EMAIL(ST_TAX_EMAIL: DICT?["store_tax_email"] as Any)
                            AP_VALUE.SET_ST_TEL(ST_TEL: DICT?["store_tel"] as Any)
                            AP_VALUE.SET_ST_TIME(ST_TIME: DICT?["store_time"] as Any)
                            AP_VALUE.SET_USE_ITEM_TIME(USE_ITEM_TIME: DICT?["use_item_time"] as Any)
                            AP_VALUE.SET_USE_PANGPANG(USE_PANGPANG: DICT?["use_pangpang"] as Any)
                            AP_VALUE.SET_VIEW_COUNT(VIEW_COUNT: DICT?["view_count"] as Any)
                            AP_VALUE.SET_WAITING_STEP(WAITING_STEP: DICT?["waiting_step"] as Any)
                            // 데이터 추가
                            
                            self.OBJ_AROUND.append(AP_VALUE)
                        }; self.TABLEVIEW.reloadData()
                    }
                }
            }
        }
    }
    
    func SET_ST_MENU(ARRAY: [Any]) -> [API_ST_MENU] {
        
        var OBJ_ST_MENU: [API_ST_MENU] = []
        
        for (_, DATA) in ARRAY.enumerated() {
            
            let DICT = DATA as? [String: Any]
            let AP_VALUE = API_ST_MENU()
            
            AP_VALUE.SET_MENU_NAME(MENU_NAME: DICT?["menu_name"] as Any)
            AP_VALUE.SET_MENU_PRICE(MENU_PRICE: DICT?["menu_price"] as Any)
            // 데이터 추가
            OBJ_ST_MENU.append(AP_VALUE)
        }
        
        return OBJ_ST_MENU
    }
}
