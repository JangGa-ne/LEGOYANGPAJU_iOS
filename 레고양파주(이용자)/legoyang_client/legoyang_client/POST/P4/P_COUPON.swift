//
//  P_COUPON.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/30.
//

import UIKit
import FirebaseFirestore

extension VC_COUPON {
    
    func GET_COUPON(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        // 데이터 삭제
        OBJ_COUPON1.removeAll(); OBJ_COUPON2.removeAll(); TABLEVIEW.reloadData()
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        UIViewController.appDelegate.listener = Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).addSnapshotListener { response, error in
            // 데이터 삭제
            self.OBJ_COUPON1.removeAll(); self.OBJ_COUPON2.removeAll(); self.TABLEVIEW.reloadData()
            
            if let response = response {
                
                var REVIEW_CHECK: Bool = true
                
                let _: [()]? = response.data()?.compactMap({ (key: String, value: Any) in
                    
                    let DICT = response.data()?[key] as? [String: Any]
                    let AP_VALUE = API_COUPON()
                    
                    let USE_TIME = DICT?["use_time"] as? String ?? "0"
                    let WRITE_REVIEW = DICT?["write_review"] as? String ?? "false"
                    
                    AP_VALUE.SET_RECEIVE_TIME(RECEIVE_TIME: DICT?["receive_time"] as Any)
                    AP_VALUE.SET_REVIEW_IDX(REVIEW_IDX: DICT?["review_idx"] as Any)
                    AP_VALUE.SET_USE_MENU(USE_MENU: DICT?["use_menu"] as Any)
                    AP_VALUE.SET_USE_STORE_ID(USE_STORE_ID: DICT?["use_store_id"] as Any)
                    AP_VALUE.SET_USE_STORE_NAME(USE_STORE_NAME: DICT?["use_store_name"] as Any)
                    AP_VALUE.SET_USE_TIME(USE_TIME: DICT?["use_time"] as Any)
                    AP_VALUE.SET_WRITE_REVIEW(WRITE_REVIEW: DICT?["write_review"] as Any)
                    
                    if (USE_TIME != "0") && (WRITE_REVIEW == "false") { REVIEW_CHECK = false }
                    // 추가 데이터
                    Firestore.firestore().collection("store").whereField("store_id", isEqualTo: DICT?["use_store_id"] as? String ?? "").getDocuments { response, error in
                        
                        if let response = response {
                            
                            for response in response.documents {
                                
                                let DICT = response.data()
                                
                                AP_VALUE.SET_PP_IMAGE(PP_IMAGE: DICT["pangpang_image"] as Any)
                                AP_VALUE.SET_PP_MENU(PP_MENU: DICT["pangpang_menu"] as Any)
                                AP_VALUE.SET_PP_REMAIN(PP_REMAIN: DICT["pangpang_remain"] as Any)
                                AP_VALUE.SET_ST_ADDRESS(ST_ADDRESS: DICT["store_address"] as Any)
                                AP_VALUE.SET_ST_COLOR(ST_COLOR: DICT["store_color"] as Any)
                                AP_VALUE.SET_ST_ETC(ST_ETC: DICT["store_etc"] as Any)
                                AP_VALUE.SET_ST_IMAGE(ST_IMAGE: DICT["store_img"] as Any)
                                AP_VALUE.SET_ST_IMAGES(ST_IMAGES: DICT["img_array"] as Any)
                                AP_VALUE.SET_ST_NAME(ST_NAME: DICT["store_name"] as Any)
                                AP_VALUE.SET_ST_SUB_TITLE(ST_SUB_TITLE: DICT["store_sub_title"] as Any)
                                AP_VALUE.SET_ST_TAG(ST_TAG: DICT["store_tag"] as Any)
                            }
                            // 데이터 추가
                            if USE_TIME == "0" {
                                self.OBJ_COUPON1.append(AP_VALUE)
                            } else if USE_TIME != "0" {
                                self.OBJ_COUPON2.append(AP_VALUE)
                            }
                            
                            self.OBJ_COUPON1.sort { front, behind in Int(front.RECEIVE_TIME) ?? 0 > Int(behind.RECEIVE_TIME) ?? 0 }
                            self.OBJ_COUPON2.sort { front, behind in Int(front.RECEIVE_TIME) ?? 0 > Int(behind.RECEIVE_TIME) ?? 0 }
                        }; self.TABLEVIEW.reloadData(); self.WRITE_REVIEW = "\(REVIEW_CHECK)"
                        
                        if (self.POSITION == 0), (USE_TIME != "0"), let RVC = UIViewController.VC_LEGOPANGPANG_DEL { self.S_NOTICE("레고팡팡 사용됨")
                            RVC.dismiss(animated: true, completion: nil); RVC.LOCALPUSH(TITLE: "레고양파주", BODY: "레고팡팡 쿠폰 사용완료! 가게 후기를 작성해주세요!\n바로 작성하러가기!(후기 미작성 시 다음 쿠폰을 사용할 수 없어요.)", USERINFO: ["type": "coupon"])
                            self.POSITION = 1; self.COLLECTIONVIEW.reloadData(); self.TABLEVIEW.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    func PUT_REVIEW(NAME: String, AC_TYPE: String) {
        
        let DATA = OBJ_COUPON2[OBJ_POSITION]
        let PARAMETERS: [String: Any] = [
            "\(DATA.RECEIVE_TIME)": [
                "review_idx": REVIEW,
                "write_review": "true"
            ]
        ]
        
        var ERROR: Bool = false
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        Firestore.firestore().collection("pangpang_history").document(DATA.USE_STORE_ID).setData(PARAMETERS, merge: true) { error in if error == nil { ERROR = false } else { ERROR = true } }
        Firestore.firestore().collection("member_pangpang_history").document(MEMBER_ID).setData(PARAMETERS, merge: true) { error in if error == nil { ERROR = false } else { ERROR = true } }
        DispatchQueue.main.async { if !ERROR { self.S_NOTICE("후기 등록됨") } else { self.S_NOTICE("오류 (!)") }; self.dismiss(animated: true, completion: nil) }
    }
}

// var <#name#>: String = ""
// func SET_<#name#>(<#name#>: Any) { self.<#name#> = <#name#> as? String ?? "" }

class API_COUPON {
    
    var RECEIVE_TIME: String = ""
    var REVIEW_IDX: String = ""
    var USE_MENU: String = ""
    var USE_STORE_ID: String = ""
    var USE_STORE_NAME: String = ""
    var USE_TIME: String = ""
    var WRITE_REVIEW: String = ""
    
    func SET_RECEIVE_TIME(RECEIVE_TIME: Any) { self.RECEIVE_TIME = RECEIVE_TIME as? String ?? "" }
    func SET_REVIEW_IDX(REVIEW_IDX: Any) { self.REVIEW_IDX = REVIEW_IDX as? String ?? "" }
    func SET_USE_MENU(USE_MENU: Any) { self.USE_MENU = USE_MENU as? String ?? "" }
    func SET_USE_STORE_ID(USE_STORE_ID: Any) { self.USE_STORE_ID = USE_STORE_ID as? String ?? "" }
    func SET_USE_STORE_NAME(USE_STORE_NAME: Any) { self.USE_STORE_NAME = USE_STORE_NAME as? String ?? "" }
    func SET_USE_TIME(USE_TIME: Any) { self.USE_TIME = USE_TIME as? String ?? "" }
    func SET_WRITE_REVIEW(WRITE_REVIEW: Any) { self.WRITE_REVIEW = WRITE_REVIEW as? String ?? "" }
    
    var PP_IMAGE: String = ""
    var PP_MENU: String = ""
    var PP_REMAIN: Int = 0
    var ST_ADDRESS: String = ""
    var ST_COLOR: String = ""
    var ST_ETC: String = ""
    var ST_IMAGE: String = ""
    var ST_IMAGES: [String] = []
    var ST_NAME: String = ""
    var ST_SUB_TITLE: String = ""
    var ST_TAG: [String] = []
    
    func SET_PP_IMAGE(PP_IMAGE: Any) { self.PP_IMAGE = PP_IMAGE as? String ?? "" }
    func SET_PP_MENU(PP_MENU: Any) { self.PP_MENU = PP_MENU as? String ?? "" }
    func SET_PP_REMAIN(PP_REMAIN: Any) { self.PP_REMAIN = PP_REMAIN as? Int ?? 0 }
    func SET_ST_ADDRESS(ST_ADDRESS: Any) { self.ST_ADDRESS = ST_ADDRESS as? String ?? "" }
    func SET_ST_COLOR(ST_COLOR: Any) { self.ST_COLOR = ST_COLOR as? String ?? "" }
    func SET_ST_ETC(ST_ETC: Any) { self.ST_ETC = ST_ETC as? String ?? "" }
    func SET_ST_IMAGE(ST_IMAGE: Any) { self.ST_IMAGE = ST_IMAGE as? String ?? "" }
    func SET_ST_IMAGES(ST_IMAGES: Any) { self.ST_IMAGES = ST_IMAGES as? [String] ?? [] }
    func SET_ST_NAME(ST_NAME: Any) { self.ST_NAME = ST_NAME as? String ?? "" }
    func SET_ST_SUB_TITLE(ST_SUB_TITLE: Any) { self.ST_SUB_TITLE = ST_SUB_TITLE as? String ?? "" }
    func SET_ST_TAG(ST_TAG: Any) { self.ST_TAG = ST_TAG as? [String] ?? [] }
}
