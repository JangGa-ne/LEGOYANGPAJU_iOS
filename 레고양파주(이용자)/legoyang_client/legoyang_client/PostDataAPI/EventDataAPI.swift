//
//  EventDataAPI.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/06/07.
//

import UIKit
import FirebaseFirestore

extension EventViewController {
    
    func loadingData() { print("event - collection: event")
        
        Firestore.firestore().collection("event").getDocuments { responses, error in
            // 데이터 삭제
            self.eventObject.removeAll()
            
            guard let responses = responses else { return }
            
            for response in responses.documents {
                
                let dict = response.data()
                let apValue = eventData()
                
                apValue.setDisplayPeriod(forKey: dict["display_period"] as Any)
                apValue.setEndTime(forKey: dict["end_time"] as Any)
                apValue.setEventId(forKey: dict["event_id"] as Any)
                apValue.setEventName(forKey: dict["event_name"] as Any)
                apValue.setExplain1(forKey: dict["explain1"] as Any)
                apValue.setExplain2(forKey: dict["explain2"] as Any)
                apValue.setExplain3(forKey: dict["explain3"] as Any)
                apValue.setMaximumPeopleCount(forKey: dict["maximum_people_count"] as Any)
                apValue.setParticipantsCount(forKey: dict["participants_count"] as Any)
                apValue.setProceeding(forKey: dict["proceeding"] as Any)
                apValue.setStartTime(forKey: dict["start_time"] as Any)
                // 데이터 추가
                self.eventObject.append(apValue)
            }
            
            self.gridView.reloadData()
        }
    }
}

// func set<#name#>(forKey: Any) { self.<#name#> = forKey as? String ?? "" }

class eventData {
    
    var displayPeriod: String = ""
    var endTime: String = ""
    var eventId: String = ""
    var eventName: String = ""
    var explain1: String = ""
    var explain2: String = ""
    var explain3: String = ""
    var maximumPeopleCount: Int = 0
    var participantsCount: Int = 0
    var proceeding: String = ""
    var startTime: String = ""
    
    func setDisplayPeriod(forKey: Any) { self.displayPeriod = forKey as? String ?? "" }
    func setEndTime(forKey: Any) { self.endTime = forKey as? String ?? "" }
    func setEventId(forKey: Any) { self.eventId = forKey as? String ?? "" }
    func setEventName(forKey: Any) { self.eventName = forKey as? String ?? "" }
    func setExplain1(forKey: Any) { self.explain1 = forKey as? String ?? "" }
    func setExplain2(forKey: Any) { self.explain2 = forKey as? String ?? "" }
    func setExplain3(forKey: Any) { self.explain3 = forKey as? String ?? "" }
    func setMaximumPeopleCount(forKey: Any) { self.maximumPeopleCount = forKey as? Int ?? 0 }
    func setParticipantsCount(forKey: Any) { self.participantsCount = forKey as? Int ?? 0 }
    func setProceeding(forKey: Any) { self.proceeding = forKey as? String ?? "" }
    func setStartTime(forKey: Any) { self.startTime = forKey as? String ?? "" }
}
