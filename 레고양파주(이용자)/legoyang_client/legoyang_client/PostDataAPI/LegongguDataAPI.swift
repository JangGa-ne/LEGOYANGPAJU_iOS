//
//  LegongguDataAPI.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/10.
//

import UIKit
import FirebaseFirestore

extension LoadingViewController {
    
    func loadingData3() { print("legonggu - collection: legonggu_item")
        
        Firestore.firestore().collection("legonggu_item").getDocuments { responses, error in
            
            guard let responses = responses else { return }
            // 데이터 초기화
            UIViewController.appDelegate.LegongguObject.removeAll()
            
            for response in responses.documents {
                
                let dict = response.data()
                let apiValue = LegongguData()
                
                apiValue.setEndTime(forKey: dict["end_time"] as Any)
                apiValue.setItemBasePrice(forKey: dict["item_baseprice"] as Any)
                apiValue.setItemContent(forKey: dict["item_content"] as Any)
                apiValue.setItemImage(forKey: dict["item_img"] as Any)
                apiValue.setItemMainImage(forKey: dict["item_mainimg"] as Any)
                apiValue.setItemName(forKey: dict["item_name"] as Any)
                apiValue.setItemPrice(forKey: dict["item_price"] as Any)
                apiValue.setItemSaleInfo(forKey: dict["item_saleinfo"] as Any)
                apiValue.setRemainCount(forKey: dict["remain_count"] as Any)
                
                if Int(dict["end_time"] as? String ?? "") ?? 0 > (self.setKoreaTimestamp()/1000) {
                    // 데이터 추가
                    UIViewController.appDelegate.LegongguObject.append(apiValue)
                }
            }; UIViewController.appDelegate.LegongguObject.sort { front, behind in front.endTime > behind.endTime }
            
            for (i, data) in UIViewController.appDelegate.MainLegongguObject.enumerated() {
                if (data.itemName == UIViewController.appDelegate.LegongguObject[i].itemName) {
                    data.remainCount = UIViewController.appDelegate.LegongguObject[i].remainCount; break
                }
            }
            if let refresh_1 = UIViewController.LegongguViewControllerDelegate {
                refresh_1.gridView.reloadData(); refresh_1.refreshControl.endRefreshing()
            }
        }
    }
}

extension LegongguDetailViewController {
    
    func loadingData2() { print("legonggu detail - collection: legonggu_options")
        
        Firestore.firestore().collection("legonggu_options").document(LegongguObject[row].itemName).getDocument { response, error in
            
            guard let response = response else { return }
            // 데이터 초기화
            self.LegongguOptionObject.removeAll()
            
            let _: [()] = response.data()?.compactMap({ (key: String, value: Any) in
                
                let dict = response.data() ?? [:]
                let apiValue = LegongguOptionData()
                
                apiValue.setOptionName(forKey: key as Any)
                apiValue.setLegongguOptionDetail(forKey: self.setLegongguOptionDetail(forKey: dict[key] as? [Any] ?? []))
                // 데이터 추가
                self.LegongguOptionObject.append(apiValue)
            }) ?? [()]
        }
    }
    
    func setLegongguOptionDetail(forKey: [Any]) -> [LegongguOptionDetailData] {
        
        var LegongguOptionDetailObject: [LegongguOptionDetailData] = []
        
        for response in forKey {
            
            let dict = response as? [String: Any] ?? [:]
            let apiValue = LegongguOptionDetailData()
            
            apiValue.setOptionName(forKey: dict["option_name"] as Any)
            apiValue.setOptionPrice(forKey: dict["option_price"] as Any)
            apiValue.setOptionType(forKey: dict["option_type"] as Any)
            // 데이터 추가
            LegongguOptionDetailObject.append(apiValue)
        }
        
        return LegongguOptionDetailObject
    }
}

// func set<#name#>(forKey: Any) { self.<#name#> = forKey as? String ?? "" }

class LegongguOptionData {
    
    var optionName: String = ""
    var LegongguOptionDetail: [LegongguOptionDetailData] = []
    
    func setOptionName(forKey: Any) { self.optionName = forKey as? String ?? "" }
    func setLegongguOptionDetail(forKey: [Any]) { self.LegongguOptionDetail = forKey as? [LegongguOptionDetailData] ?? [] }
}
    
class LegongguOptionDetailData {
    
    var optionName: String = ""
    var optionPrice: String = ""
    var optionType: String = ""
    
    func setOptionName(forKey: Any) { self.optionName = forKey as? String ?? "" }
    func setOptionPrice(forKey: Any) { self.optionPrice = forKey as? String ?? "" }
    func setOptionType(forKey: Any) { self.optionType = forKey as? String ?? "" }
}

class OptionCheckData {
    
    var optionButtons: [UIButton] = []
    var optionCheck: Bool = false
    var optionName: String = ""
    var optionPrice: Int = 0
    
    func setOptionButtons(forKey: Any) { self.optionButtons = forKey as? [UIButton] ?? [] }
    func setOptionCheck(forKey: Any) { self.optionCheck = forKey as? Bool ?? false }
    func setOptionName(forKey: Any) { self.optionName = forKey as? String ?? "" }
    func setOptionPrice(forKey: Any) { self.optionPrice = forKey as? Int ?? 0 }
}
