//
//  P3_STORE_EDIT.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/22.
//

import UIKit
import CoreLocation
import FirebaseStorage
import FirebaseFirestore
import Alamofire

extension VC3_STORE_EDIT {
    
    func SET_GEOCORDER(NAME: String, AC_TYPE: String) {
        
        let apiUrl = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode"
        
        let HEADERS: HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID": "0obryk6541",
            "X-NCP-APIGW-API-KEY": "y0zL58oiKekeWMqAaY1IAuGPWdoOP9nBNSxp0C9p"
        ]
        
        let PARAMETERS: Parameters = [
            "query": ADDRESS
        ]
        
        let MANAGER = Alamofire.Session.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 5
        MANAGER.request(apiUrl, method: .get, parameters: PARAMETERS, headers: HEADERS).responseJSON { response in
            
            if let DICT = response.value as? [String: Any] {
                
                if let ARRAY = DICT["addresses"] as? Array<Any>, ARRAY.count > 0 {
                    
                    let DICT = ARRAY[0] as? [String: Any]
                    
                    self.LAT = DICT?["y"] as? String ?? "0.0"
                    self.LON = DICT?["x"] as? String ?? "0.0"
                }
            }
        }
    }
    
    func FirebaseStoragePutData(file: [Int: [String: Data]], store_id: String, completionHandler: @escaping (_ storage: [String], _ count: Int) -> Void) {
        
        var OBJ_STORAGE: [String] = []
        if file.count > 0 {
            
            for i in 0 ..< file.count {
                
                let _: [()] = file[i]?.compactMap { (key: String, value: Data) in
                    
                    for IMAGE in UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].imageArray {
                        Storage.storage().reference(forURL: IMAGE).delete { _ in }
                    }
                    
                    let STORAGE_REF = Storage.storage(url: "gs://legoyangpaju.appspot.com").reference()
                    let FILE_REF = STORAGE_REF.child("StoreImage/\(store_id)/\(i)")
                    let META_DATA = StorageMetadata(); META_DATA.contentType = key.mimeType()
                    FILE_REF.putData(value, metadata: META_DATA).observe(.success) { snapshot in
                        FILE_REF.downloadURL { url, error in if let loadUrl = url { OBJ_STORAGE.append("\(loadUrl)"); completionHandler(OBJ_STORAGE, OBJ_STORAGE.count) } }
                    }
                } ?? []
            }
        } else {
            completionHandler([], 0)
        }
    }
    
    func PUT_STORE(NAME: String, AC_TYPE: String) {
        
        S_INDICATOR(view, text: "적용 중...")
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        FirebaseStoragePutData(file: OBJ_SELECT, store_id: STORE_ID) { storage, count in
            
            if self.OBJ_SELECT.count == count {

                var PARAMETERS: [String: Any] = [
                    "store_color": self.COLOR,
                    "store_sub_title": self.SUBJECT_TF.text!,
                    "store_etc": self.CONTENTS_TV.text!,
                    "store_tel": self.TEL_TF.text!,
                    "store_address": self.ADDRESS_TF.text!,
                    "store_time": self.OPENTIME_TF.text!,
                    "store_lastorder": self.LASTORDER_TF.text!,
                    "store_restday": self.HOLIDAY_TF.text!,
                ]
                
                PARAMETERS["store_tag"] = UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeTag
                if self.LAT != "0.0" && self.LON != "0.0" { PARAMETERS["lat"] = self.LAT; PARAMETERS["lon"] = self.LON }
                
                if storage.count > 0 { PARAMETERS["store_img"] = storage[0]; PARAMETERS["img_array"] = storage }
                
                var MENU: [Any] = []
                if (self.MN_AMOUNT1_TF.text! != "") && (self.MN_AMOUNT1_TF.text! != "") { MENU.append(["menu_name": self.MN_NAME1_TF.text!, "menu_price": self.MN_AMOUNT1_TF.text!]) }
                if (self.MN_AMOUNT2_TF.text! != "") && (self.MN_AMOUNT2_TF.text! != "") { MENU.append(["menu_name": self.MN_NAME2_TF.text!, "menu_price": self.MN_AMOUNT2_TF.text!]) }
                if (self.MN_AMOUNT3_TF.text! != "") && (self.MN_AMOUNT3_TF.text! != "") { MENU.append(["menu_name": self.MN_NAME3_TF.text!, "menu_price": self.MN_AMOUNT3_TF.text!]) }
                if (self.MN_AMOUNT4_TF.text! != "") && (self.MN_AMOUNT4_TF.text! != "") { MENU.append(["menu_name": self.MN_NAME4_TF.text!, "menu_price": self.MN_AMOUNT4_TF.text!]) }
                PARAMETERS["store_menu"] = MENU

                Firestore.firestore().collection(AC_TYPE).document(STORE_ID).setData(PARAMETERS, merge: true) { _ in

                    S_INDICATOR(self.view, animated: false)

//                    if let BVC = UIViewController.VC3_MAIN_DEL {
//                        if storage.count > 0 { BVC.IMAGESLIDER(IV: BVC.SLIDER_I, IU: storage, PH: UIImage(), RD: 0, CM: .scaleAspectFill); BVC.POSITION_L.text = "1 / \(storage.count)" }
//                        BVC.QUOTE_LEFT_I.image = UIImage(named: QUOTE_REFT[self.COLOR] ?? "quote_left0")
//                        BVC.QUOTE_RIGHT_I.image = UIImage(named: QUOTE_RIGHT[self.COLOR] ?? "quote_right0")
//                        BVC.SUBJECT_L.text = self.SUBJECT_TF.text!
//                        BVC.CONTENTS_L.text = self.CONTENTS_TV.text!
//                        BVC.TEL_L.text = self.NUMBER("phone", self.TEL_TF.text!)
//                        BVC.ADDRESS_L.text = self.ADDRESS_TF.text!
//                        BVC.OPENTIME_L.text = self.OPENTIME_TF.text!
//                        BVC.LASTORDER_L.text = self.LASTORDER_TF.text!
//                        BVC.HOLIDAY_L.text = self.HOLIDAY_TF.text!
//                        if (self.MN_AMOUNT1_TF.text! != "") && (self.MN_AMOUNT1_TF.text! != "") { BVC.MENU_L1.text = "\(self.MN_NAME1_TF.text!) (\(NF.string(from: (Int(self.MN_AMOUNT1_TF.text!) ?? 0) as NSNumber) ?? "")원)" }
//                        if (self.MN_AMOUNT2_TF.text! != "") && (self.MN_AMOUNT2_TF.text! != "") { BVC.MENU_L2.text = "\(self.MN_NAME2_TF.text!) (\(NF.string(from: (Int(self.MN_AMOUNT2_TF.text!) ?? 0) as NSNumber) ?? "")원)" }
//                        if (self.MN_AMOUNT3_TF.text! != "") && (self.MN_AMOUNT3_TF.text! != "") { BVC.MENU_L3.text = "\(self.MN_NAME3_TF.text!) (\(NF.string(from: (Int(self.MN_AMOUNT3_TF.text!) ?? 0) as NSNumber) ?? "")원)" }
//                        if (self.MN_AMOUNT4_TF.text! != "") && (self.MN_AMOUNT4_TF.text! != "") { BVC.MENU_L4.text = "\(self.MN_NAME4_TF.text!) (\(NF.string(from: (Int(self.MN_AMOUNT4_TF.text!) ?? 0) as NSNumber) ?? "")원)" }
//                    }
                    
                    if let refresh = UIViewController.LoadingViewControllerDelegate {
                        refresh.loadingData(update: true)
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

//    var <#name#>: String = ""
//    func SET_<#name#>(<#name#>: Any) { self.<#name#> = <#name#> as? String ?? "" }

struct API_STORE {
    
    var imageArray: [String: Any] = [:]
    var ST_COLOR: String = ""
    var ST_SUBJECT: String = ""
    var ST_CONTENTS: String = ""
    var ST_TEL: String = ""
    var ST_ADDRESS: String = ""
    var ST_OPENING: String = ""
    var ST_LASTORDER: String = ""
    var ST_HOLIDAY: String = ""
    var ST_MENUS: [String: Any] = [:]
}
