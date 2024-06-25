//
//  P_SIGNUP.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/24.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import UniformTypeIdentifiers
import Alamofire

extension VC_SIGNUP {
    
    func SET_GEOCORDER(NAME: String, AC_TYPE: String) {
        
//        let POST_URL: String = "https://maps.google.com/maps/place/\(BS_ADDRESS_TF1.text!)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
//        let MANAGER = Alamofire.Session.default
//        MANAGER.session.configuration.timeoutIntervalForRequest = 5.0
//        MANAGER.request(POST_URL, method: .get, parameters: nil).responseString { response in
//
//            if let range = "\(response)".range(of: "markers=") {
//                let startIndex = range.upperBound
//                if let endRange = "\(response)".range(of: "&amp", range: startIndex ..< "\(response)".endIndex) {
//                    let markersString = "\(response)"[startIndex ..< endRange.lowerBound]
//                    print(markersString)
//                }
//            }
//        }
        
        let apiUrl = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode"
        
        let HEADERS: HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID": "0obryk6541",
            "X-NCP-APIGW-API-KEY": "y0zL58oiKekeWMqAaY1IAuGPWdoOP9nBNSxp0C9p"
        ]
        
        let PARAMETERS: Parameters = [
            "query": BS_ADDRESS_TF1.text!
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
    
    func FirebaseStoragePutData(completionHandler: @escaping (_ storage: [String], _ count: Int) -> Void) {
        
        var OBJ_STORAGE: [String] = []
        let STORAGE_REF = Storage.storage(url: "gs://legoyangpaju.appspot.com").reference()
        // 사진 업로드
        for (_, DATA) in IMAGE_DATA.enumerated() { FILE_DATA.removeAll()
            let FILE_REF = STORAGE_REF.child("StoreRegiDocu/\(US_ID_TF.text!+BS_NAME_TF.text!).\(detectImageType(from: DATA.value))")
            let META_DATA = StorageMetadata(); META_DATA.contentType = DATA.key.mimeType()
            FILE_REF.putData(DATA.value, metadata: META_DATA).observe(.success) { snapshot in
                FILE_REF.downloadURL { url, error in
                    FILE_REF.downloadURL { url, error in OBJ_STORAGE.append("\(url!)"); completionHandler(OBJ_STORAGE, OBJ_STORAGE.count) }
                }
            }
        }
        // 파일 업로드
        for (_, DATA) in FILE_DATA.enumerated() { IMAGE_DATA.removeAll()
            let FILE_REF = STORAGE_REF.child("StoreRegiDocu/\(US_ID_TF.text!+BS_NAME_TF.text!).\(DATA.key.pathExtension)")
            let META_DATA = StorageMetadata(); META_DATA.contentType = DATA.key.mimeType()
            FILE_REF.putFile(from: URL(string: DATA.value)!, metadata: META_DATA).observe(.success) { snapshot in
                FILE_REF.downloadURL { url, error in OBJ_STORAGE.append("\(url!)"); completionHandler(OBJ_STORAGE, OBJ_STORAGE.count) }
            }
        }
    }
    
    func PUT_SIGNUP(NAME: String, AC_TYPE: String) {
        
        if Firestore.firestore().collection(AC_TYPE).document().documentID == US_ID_TF.text! {
            self.S_NOTICE("이미 가입된 유저")
        } else {
            FirebaseStoragePutData { storage, count in
                
                var PARAMETERS: [String: Any] = [
                    "entering_time": "\(self.setKoreaTimestamp())",
                    "fcm_id": UserDefaults.standard.string(forKey: "fcm_id") ?? "",
                    "name": self.US_NAME_TF.text!,
                    "store_id": self.US_ID_TF.text!,
                    "store_password": self.US_PW_TF2.text!,
                    "store_email": self.US_EMAIL_TF.text!,
                    "store_category": self.BS_CATE_TF.text!,
                    "store_name": self.BS_NAME_TF.text!,
                    "store_address": "\(self.BS_ADDRESS_TF1.text!) \(self.BS_ADDRESS_TF2.text!)",
                    "owner_name": self.BS_CEO_TF.text!,
                    "owner_number": self.US_PHONE_TF.text!.replacingOccurrences(of: "-", with: ""),
                    "store_regnum": self.BS_NUMBER_TF.text!.replacingOccurrences(of: "-", with: ""),
                    "store_tax_email": self.BS_EMAIL_TF.text!,
                    "store_cash": "25000",
                    "use_item_time": "0",
                    "use_pangpang": "true",
                    "waiting_step": "0",
                    "manager_name": "",
                    "manager_number": "",
                    "option_ad_term": UserDefaults.standard.string(forKey: "option_ad_term") ?? "",
                    "option_privacy_term": UserDefaults.standard.string(forKey: "option_privacy_term") ?? "",
                    "os_platform": "ios",
                ]
                
                if self.LAT != "0.0" && self.LON != "0.0" { PARAMETERS["lat"] = self.LAT; PARAMETERS["lon"] = self.LON }
                
                if (self.IMAGE_DATA.count == count) || (self.FILE_DATA.count == count) {
                    
                    if storage.count > 0 { PARAMETERS["store_registration_url"] = storage[0] }
                    
                    Firestore.firestore().collection(AC_TYPE).document(self.US_ID_TF.text!).setData(PARAMETERS, merge: true) { error in
                        if error == nil {
                            self.S_NOTICE("회원가입 요청됨")
                            UserDefaults.standard.setValue(self.US_ID_TF.text!, forKey: "store_id"); self.segueViewController(identifier: "VC_LOADING")
                        } else {
                            self.S_NOTICE("오류 (!)")
                        }
                    }
                }
            }
        }
    }
}
