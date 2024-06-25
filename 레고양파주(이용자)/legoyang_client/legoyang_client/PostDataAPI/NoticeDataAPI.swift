//
//  NoticeDataAPI.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/27.
//

import UIKit
import FirebaseFirestore

extension LoadingViewController {
    
    func loadingData4() { print("notice - collection: member")
        
        if UIViewController.appDelegate.MemberId != "" {
            
            UIViewController.appDelegate.listener = Firestore.firestore().collection("member").document(UIViewController.appDelegate.MemberId).addSnapshotListener { response, error in
                
                guard let response = response else { return }
                // 데이터 초기화
                UIViewController.appDelegate.NoticeListObject.removeAll()
                UIViewController.appDelegate.noticeCount = 0
                
                let dict = response.data() ?? [:]
                let forKey = dict["noti_list"] as? [String: Any] ?? [:]
                
                let _: [()] = forKey.compactMap { (key: String, value: Any) in
                    
                    let dict = forKey[key] as? [String: Any] ?? [:]
                    let apiValue = NoticeListData()
                    
                    if dict["readornot"] as? String ?? "false" != "true" { UIViewController.appDelegate.noticeCount += 1 }
                    
                    apiValue.setBody(forKey: dict["body"] as Any)
                    apiValue.setData(forKey: dict["data"] as Any)
                    apiValue.setReadOrNot(forKey: dict["readornot"] as Any)
                    apiValue.setReceiveTime(forKey: dict["receive_time"] as Any)
                    apiValue.setTitle(forKey: dict["title"] as Any)
                    apiValue.setType(forKey: dict["type"] as Any)
                    // 데이터 추가
                    UIViewController.appDelegate.NoticeListObject.append(apiValue)
                }; UIViewController.appDelegate.NoticeListObject.sort { front, behind in front.receiveTime > behind.receiveTime }
                
                if let refresh_1 = UIViewController.MainViewControllerDelegate {
                    if UIViewController.appDelegate.noticeCount > 0 {
                        refresh_1.noticeCountLabel.isHidden = false
                        refresh_1.noticeCountLabel.text = "\(UIViewController.appDelegate.noticeCount)"
                        refresh_1.noticeCountLabelWidth.constant = refresh_1.stringWidth(text: "\(UIViewController.appDelegate.noticeCount)", fontSize: 10)+10
                    } else {
                        refresh_1.noticeCountLabel.isHidden = true
                    }
                }
                if let refresh_2 = UIViewController.SearchViewControllerDelegate {
                    if UIViewController.appDelegate.noticeCount > 0 {
                        refresh_2.noticeCountLabel.isHidden = false
                        refresh_2.noticeCountLabel.text = "\(UIViewController.appDelegate.noticeCount)"
                        refresh_2.noticeCountLabelWidth.constant = refresh_2.stringWidth(text: "\(UIViewController.appDelegate.noticeCount)", fontSize: 10)+10
                    } else {
                        refresh_2.noticeCountLabel.isHidden = true
                    }
                }
                if let refresh_3 = UIViewController.NoticeViewControllerDelegate {
                    refresh_3.listView.reloadData()
                }
            }
        }
    }
}
