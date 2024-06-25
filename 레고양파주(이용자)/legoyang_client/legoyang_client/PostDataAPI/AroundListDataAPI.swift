//
//  AroundListDataAPI.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/18.
//

import UIKit
import FirebaseFirestore

extension AroundListViewController {
    
    func loadingData() { print("aroundList - collection: member_around_store")
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("member_around_store").document(UIViewController.appDelegate.MemberId).getDocument { response, error in
                
                guard let response = response else { return }
                // 데이터 초기화
                self.AroundObject.removeAll(); self.StoreObject.removeAll()
                
                let _: [()] = response.data()?.compactMap({ (key: String, value: Any) in
                    
                    let apiValue = AroundData()
                    
                    apiValue.setStoreId(forKey: key as Any)
                    apiValue.setRange(forKey: value as Any)
                    // 데이터 추가
                    self.AroundObject.append(apiValue)
                }) ?? [()]
                
                self.AroundObject.sort { front, behind in front.range < behind.range }
                
                DispatchGroup.leave()
            }
        }
        
        DispatchGroup.notify(queue: .main) {
            
            for AroundData in self.AroundObject {
                for StoreData in UIViewController.appDelegate.StoreObject {
                    if (AroundData.storeId == StoreData.storeId) && ("모두" == self.category) {
                        if self.StoreObject.count < 10 { self.StoreObject.append(StoreData) } else { break }
                    } else if (AroundData.storeId == StoreData.storeId) && (StoreData.storeCategory == self.category) {
                        if self.StoreObject.count < 10 { self.StoreObject.append(StoreData) } else { break }
                    }
                }
            }
            
            self.listView.reloadData()
        }
    }
}

// func set<#name#>(forKey: Any) { self.<#name#> = forKey as? String ?? "" }

class AroundData {
    
    var storeId: String = ""
    var range: String = ""
    
    func setStoreId(forKey: Any) { self.storeId = forKey as? String ?? "" }
    func setRange(forKey: Any) { self.range = forKey as? String ?? "" }
}
