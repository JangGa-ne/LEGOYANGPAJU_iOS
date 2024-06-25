//
//  BasketDataAPI.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/17.
//

import UIKit
import FirebaseFirestore

extension BasketViewController {
    
    func loadingData() { print("basket - colletion: legonggu_basket, legonggu_item")
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("legonggu_basket").document(UIViewController.appDelegate.MemberId).getDocument { response, error in
                
                guard let response = response else { return }
                // 데이터 초기화
                self.BasketObject.removeAll()
                
                let _: [()] = response.data()?.compactMap({ (key: String, value: Any) in
                    
                    for data in UIViewController.appDelegate.LegongguObject {
                        if data.itemName == key {
                            self.BasketObject.append(data)
                        }
                    }
                }) ?? [()]
                
                DispatchGroup.leave()
            }
        }
        
        DispatchGroup.notify(queue: .main) {
            
            for data in self.BasketObject {
                
                Firestore.firestore().collection("legonggu_basket").document(UIViewController.appDelegate.MemberId).getDocument { response, error in
                    
                    guard let response = response else { return }
                    
                    let _: [()] = response.data()?.compactMap({ (key: String, value: Any) in
                        
                        if data.itemName == key {
                            
                            var BasketObject: [ItemArrayData] = []
                            
                            for response in response.data()?[key] as? [Any] ?? [] {
                                
                                let dict = response as? [String: Any] ?? [:]
                                let apiValue = ItemArrayData()
                                
                                apiValue.setFreeDeliveryCouponUse(forKey: dict["free_delivery_coupon_use"] as Any)
                                apiValue.setItemCount(forKey: dict["item_count"] as Any)
                                apiValue.setItemName(forKey: dict["item_name"] as Any)
                                apiValue.setItemOption(forKey: dict["item_option"] as Any)
                                apiValue.setItemOptions(forKey: dict["item_options"] as Any)
                                apiValue.setItemPrice(forKey: dict["item_price"] as Any)
                                // 데이터 추가
                                BasketObject.append(apiValue)
                            }
                            
                            data.basket = BasketObject
                        }
                    }) ?? [()]
                }
            }
            
            self.listView.reloadData()
        }
    }
}

// func set<#name#>(forKey: Any) { self.<#name#> = forKey as? String ?? "" }

class ItemArrayData {
    
    var freeDeliveryCouponUse: String = ""
    var itemCount: String = ""
    var itemName: String = ""
    var itemOption: String = ""
    var itemOptions: [String] = []
    var itemPrice: String = ""
    
    func setFreeDeliveryCouponUse(forKey: Any) { self.freeDeliveryCouponUse = forKey as? String ?? "" }
    func setItemCount(forKey: Any) { self.itemCount = forKey as? String ?? "" }
    func setItemName(forKey: Any) { self.itemName = forKey as? String ?? "" }
    func setItemOption(forKey: Any) { self.itemOption = forKey as? String ?? "" }
    func setItemOptions(forKey: Any) { self.itemOptions = forKey as? [String] ?? [] }
    func setItemPrice(forKey: Any) { self.itemPrice = forKey as? String ?? "" }
}
