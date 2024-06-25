//
//  S_BACKGROUND.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/02/18.
//

import UIKit
import FirebaseFirestore

extension AppDelegate {
    
    func GET_SHARE(NAME: String, AC_TYPE: String, ID: String) {
        
        Firestore.firestore().collection(AC_TYPE).document(ID).getDocument { response, error in
            
            if let response = response {
                
                if AC_TYPE == "store" {
                    
                    var OBJ_STORE: [API_STORE] = []
                    
                    let DICT = response.data()
                    let AP_VALUE = API_STORE()
                    
                    AP_VALUE.SET_DELIVERY_TIME(DELIVERY_TIME: DICT?["delivery_time"] as Any)
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
                    OBJ_STORE.append(AP_VALUE)
                    
                    if OBJ_STORE.count > 0 {
                        if UIViewController.VC_DETAIL1_DEL != nil { UIViewController.VC_DETAIL1_DEL?.navigationController?.popViewController(animated: true) }
                        let VC = UIViewController.TabBarControllerDelegate? .storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL1") as! VC_DETAIL1
                        VC.OBJ_STORE = OBJ_STORE; VC.OBJ_POSITION = 0
                        UIViewController.TabBarControllerDelegate? .navigationController?.pushViewController(VC, animated: true)
                    } else {
                        self.VC.S_NOTICE("데이터 없음")
                    }
                } else if AC_TYPE == "legonggu_item" {
                    
                    var OBJ_LEGONGGU: [API_LEGONGGU] = []
                    
                    let DICT = response.data()
                    let AP_VALUE = API_LEGONGGU()
                    
                    AP_VALUE.SET_END_TIME(END_TIME: DICT?["end_time"] as Any)
                    AP_VALUE.SET_ITEM_BASEPRICE(ITEM_BASEPRICE: DICT?["item_baseprice"] as Any)
                    AP_VALUE.SET_ITEM_CONTENT(ITEM_CONTENT: DICT?["item_content"] as Any)
                    AP_VALUE.SET_ITEM_IMG(ITEM_IMG: DICT?["item_img"] as? [Any] ?? [])
                    AP_VALUE.SET_ITEM_MAINIMG(ITEM_MAINIMG: DICT?["item_mainimg"] as Any)
                    AP_VALUE.SET_ITEM_NAME(ITEM_NAME: DICT?["item_name"] as Any)
                    AP_VALUE.SET_ITEM_PRICE(ITEM_PRICE: DICT?["item_price"] as Any)
                    AP_VALUE.SET_ITEM_SALEINFO(ITEM_SALEINFO: DICT?["item_saleinfo"] as Any)
                    AP_VALUE.SET_REMAIN_COUNT(REMAIN_COUNT: DICT?["remain_count"] as Any)
                    // 데이터 추가
                    OBJ_LEGONGGU.append(AP_VALUE)
                    
                    if OBJ_LEGONGGU.count > 0 {
                        if UIViewController.VC_LEGONGGU2_DEL != nil { UIViewController.VC_LEGONGGU2_DEL?.navigationController?.popViewController(animated: true) }
                        let VC = UIViewController.TabBarControllerDelegate? .storyboard?.instantiateViewController(withIdentifier: "VC_LEGONGGU2") as! VC_LEGONGGU2
                        VC.OBJ_LEGONGGU = OBJ_LEGONGGU; VC.OBJ_POSITION = 0
                        UIViewController.TabBarControllerDelegate? .navigationController?.pushViewController(VC, animated: true)
                    } else {
                        self.VC.S_NOTICE("데이터 없음")
                    }
                }
            } else {
                self.VC.S_NOTICE("데이터 없음")
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
