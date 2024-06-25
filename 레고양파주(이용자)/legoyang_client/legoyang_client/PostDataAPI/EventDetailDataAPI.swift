//
//  EventDetailDataAPI.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/06/13.
//

import UIKit
import FirebaseFirestore

extension EventDetailViewController {
    
    func loadingData() { print("event detail - collection: event, event_reward")
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("event").document("event_reward").getDocument { response, error in
                
                guard let response = response, response.exists else { return }
                
                let dict = response.data() ?? [:]
                
                let explain1 = dict["explain1"] as? String ?? ""
                let explain2 = dict["explain2"] as? String ?? ""
                let explain3 = dict["explain3"] as? String ?? ""
                let displayPeriod = dict["display_period"] as? String ?? ""
                
                self.eventId = dict["event_id"] as? String ?? ""
                
                self.inviterMainTitleLabel.text = explain1
                self.inviterSubTitleLabel.text = explain3.replacingOccurrences(of: "\n", with: "\\n")
                self.inviterSubContentLabel.text = displayPeriod
                
                self.inviteeMainTitleLabel.text = explain1
                self.inviteeSubTitleLabel.text = explain2.replacingOccurrences(of: "\n", with: "\\n")
                self.inviteeSubContentLabel.text = displayPeriod
                
                DispatchGroup.leave()
            }
        }
        
        DispatchGroup.notify(queue: .main) {
            
            Firestore.firestore().collection("event_reward").document(UIViewController.appDelegate.MemberId).getDocument { response, error in
                
                self.eventInviterObject = eventInviterData()
                
                guard let response = response else { return }
                
                let dict = response.data() ?? [:]
                let apValue = eventInviterData()
                
                apValue.setCouponType(forKey: dict["coupon_type"] as Any)
                apValue.setFinishTime(forKey: dict["finish_time"] as Any)
                apValue.setInviteTo(forKey: self.setInviterTo(array: dict["invite_to"] as? [Any] ?? []))
                apValue.setInviterCode(forKey: dict["inviter_code"] as Any)
                apValue.setInviterFrom(forKey: dict["inviter_from"] as Any)
                apValue.setProgressStep(forKey: dict["progress_step"] as Any)
                apValue.setReviewUrl(forKey: dict["review_url"] as Any)
                apValue.setStartTime(forKey: dict["start_time"] as Any)
                apValue.setWriteCount(forKey: dict["write_count"] as Any)
                // 데이터 추가
                self.eventInviterObject = apValue
                
                if let refresh_1 = UIViewController.MyEventViewControllerDelegate {
                    refresh_1.eventInviterObject = apValue
                    refresh_1.eventCountLabel.text = "\(apValue.inviteTo.count)"
                    refresh_1.listView.reloadData()
                }
                
                self.loadingData2()
            }
        }
    }
    
    func setInviterTo(array: [Any]) -> [inviteToData] {
        
        var inviteToObject: [inviteToData] = []
        
        for data in array {
            
            let dict = data as? [String: Any] ?? [:]
            let apValue = inviteToData()
            
            apValue.setCouponType(forKey: dict["coupon_type"] as Any)
            apValue.setFinishTime(forKey: dict["finish_time"] as Any)
            apValue.setInviteeId(forKey: dict["invitee_id"] as Any)
            apValue.setInviteeNick(forKey: dict["invitee_nick"] as Any)
            apValue.setProgressStep(forKey: dict["progress_step"] as Any)
            apValue.setStartTime(forKey: dict["start_time"] as Any)
            apValue.setWriteCount(forKey: dict["write_count"] as Any)
            // 데이터 추가
            inviteToObject.append(apValue)
        }
        
        return inviteToObject
    }
}

// func set<#name#>(forKey: Any) { self.<#name#> = forKey as? String ?? "" }

class eventInviterData {
    
    var couponType: String = ""
    var finishTime: String = ""
    var inviteTo: [inviteToData] = []
    var inviterCode: String = ""
    var inviterFrom: String = ""
    var progressStep: String = ""
    var reviewUrl: [String] = []
    var startTime: String = ""
    var writeCount: Int = 0
    
    func setCouponType(forKey: Any) { self.couponType = forKey as? String ?? "" }
    func setFinishTime(forKey: Any) { self.finishTime = forKey as? String ?? "" }
    func setInviteTo(forKey: Any) { self.inviteTo = forKey as? [inviteToData] ?? [] }
    func setInviterCode(forKey: Any) { self.inviterCode = forKey as? String ?? "" }
    func setInviterFrom(forKey: Any) { self.inviterFrom = forKey as? String ?? "" }
    func setProgressStep(forKey: Any) { self.progressStep = forKey as? String ?? "" }
    func setReviewUrl(forKey: Any) { self.reviewUrl = forKey as? [String] ?? [] }
    func setStartTime(forKey: Any) { self.startTime = forKey as? String ?? "" }
    func setWriteCount(forKey: Any) { self.writeCount = forKey as? Int ?? 0 }
}

class inviteToData {
    
    var couponType: String = ""
    var finishTime: String = ""
    var inviteeId: String = ""
    var inviteeNick: String = ""
    var progressStep: String = ""
    var startTime: String = ""
    var writeCount: Int = 0
    
    func setCouponType(forKey: Any) { self.couponType = forKey as? String ?? "" }
    func setFinishTime(forKey: Any) { self.finishTime = forKey as? String ?? "" }
    func setInviteeId(forKey: Any) { self.inviteeId = forKey as? String ?? "" }
    func setInviteeNick(forKey: Any) { self.inviteeNick = forKey as? String ?? "" }
    func setProgressStep(forKey: Any) { self.progressStep = forKey as? String ?? "" }
    func setStartTime(forKey: Any) { self.startTime = forKey as? String ?? "" }
    func setWriteCount(forKey: Any) { self.writeCount = forKey as? Int ?? 0 }
}

