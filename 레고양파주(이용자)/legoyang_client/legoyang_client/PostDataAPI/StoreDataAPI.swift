//
//  StoreDataAPI.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/06.
//

import UIKit
import FirebaseFirestore

extension LoadingViewController {
    
    func loadingData2() { print("store, search - collection: store")
        
        Firestore.firestore().collection("store").getDocuments { responses, error in
            
            guard let responses = responses else { return }
            // 데이터 초기화
            UIViewController.appDelegate.StoreObject.removeAll()
            
            for response in responses.documents {
                
                let dict = response.data()
                let apiValue = StoreData()
                
                apiValue.setEnteringTime(forKey: dict["entering_time"] as Any)
                apiValue.setImageArray(forKey: dict["img_array"] as Any)
                apiValue.setLat(forKey: dict["lat"] as Any)
                apiValue.setLikeCount(forKey: dict["like_count"] as Any)
                apiValue.setLon(forKey: dict["lon"] as Any)
                apiValue.setOwnerName(forKey: dict["owner_name"] as Any)
                apiValue.setOwnerNumber(forKey: dict["owner_number"] as Any)
                apiValue.setPangpangImage(forKey: dict["pangpang_image"] as Any)
                apiValue.setPangpangMenu(forKey: dict["pangpang_menu"] as Any)
                apiValue.setPangpangRemain(forKey: dict["pangpang_remain"] as Any)
                apiValue.setStoreAddress(forKey: dict["store_address"] as Any)
                apiValue.setStoreCategory(forKey: dict["store_category"] as Any)
                apiValue.setStoreColor(forKey: dict["store_color"] as Any)
                apiValue.setStoreEtc(forKey: dict["store_etc"] as Any)
                apiValue.setStoreId(forKey: dict["store_id"] as Any)
                apiValue.setStoreImage(forKey: dict["store_img"] as Any)
                apiValue.setStoreLastOrder(forKey: dict["store_lastorder"] as Any)
                apiValue.setStoreMenu(forKey: self.setStoreMenu(forKey: dict["store_menu"] as? [Any] ?? []))
                apiValue.setStoreName(forKey: dict["store_name"] as Any)
                apiValue.setStoreRegnum(forKey: dict["store_regnum"] as Any)
                apiValue.setStoreRestday(forKey: dict["store_restday"] as Any)
                apiValue.setStoreSubTitle(forKey: dict["store_sub_title"] as Any)
                apiValue.setStoreTag(forKey: dict["store_tag"] as Any)
                apiValue.setStoreTaxEmail(forKey: dict["store_tax_email"] as Any)
                apiValue.setStoreTel(forKey: dict["store_tel"] as Any)
                apiValue.setStoreTime(forKey: dict["store_time"] as Any)
                apiValue.setUseItemTime(forKey: dict["use_item_time"] as Any)
                apiValue.setUsePangpang(forKey: dict["use_pangpang"] as Any)
                apiValue.setViewCount(forKey: dict["view_count"] as Any)
                apiValue.setWaitingStep(forKey: dict["waiting_step"] as Any)
                
                if dict["store_id"] as? String ?? "" == "01099999999" { apiValue.setUseItemTime(forKey: "9999999999999") }
                // 데이터 추가
                UIViewController.appDelegate.StoreObject.append(apiValue)
            }; UIViewController.appDelegate.StoreObject.sort(by: {front, behind in front.useItemTime > behind.useItemTime })
            
//            // 밤리단 보넷길
//            for ddd in UIViewController.appDelegate.StoreObject {
//                if ("37.6661153" < ddd.lat) && (ddd.lat < "37.67247") && ("126.7805423" < ddd.lon) && (ddd.lon < "126.7880") && (ddd.usePangpang == "true") {
//                    print(ddd.storeName)
//                }
//            }
            
            if let refresh_1 = UIViewController.StoreViewControllerDelegate {
                refresh_1.searchButton(UIButton())
            }
            if let refresh_2 = UIViewController.SearchViewControllerDelegate {
                refresh_2.searchButton(UIButton())
            }
        }
    }
    
    func setStoreMenu(forKey: [Any]) -> [StoreMenuData] {
        
        var StoreMenuObject: [StoreMenuData] = []
        
        for response in forKey {
            
            let dict = response as? [String: Any] ?? [:]
            let apiValue = StoreMenuData()
            
            apiValue.setMenuName(forKey: dict["menu_name"] as Any)
            apiValue.setMenuPrice(forKey: dict["menu_price"] as Any)
            // 데이터 추가
            StoreMenuObject.append(apiValue)
        }
        
        return StoreMenuObject
    }
}
