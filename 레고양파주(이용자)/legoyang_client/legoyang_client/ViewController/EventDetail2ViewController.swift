//
//  EventDetail2ViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/06/23.
//

import UIKit
import FirebaseFirestore

class EventDetail2ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var eventObject: eventData = eventData()
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var kakaoShareView: UIView!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var codeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboard()
        
        codeTextField.placeholder("코드를 입력해 주세요", COLOR: .lightGray)
    }
    
    @objc func codeButton(_ sender: UIButton) {
        
        if UIViewController.appDelegate.MemberId == "" {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else if UIViewController.appDelegate.MemberObject.signupTime < eventObject.startTime {
            setAlert(title: "", body: "이벤트 참여 대상이 아닙니다", style: .alert, time: 2)
        } else {
            
        }
    }
    
    func setEventInvite() {
        
        var invitee: Bool = false
        let shareDict = UIViewController.appDelegate.shareData
        let timestamp = "\(self.setKoreaTimestamp())"
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("event").document("event_invite").getDocument { resposne, error in
                
                guard let response = resposne, response.exists else { return }
                
                let dict = response.data() ?? [:]
                
                let proceeding = dict["proceeding"] as? String ?? ""
                let maximumPeopleCount = dict["maximum_people_count"] as? Int ?? 0
                let participantsCount = dict["participants_count"] as? Int ?? 0
                
                if proceeding != "true" {
                    self.setAlert(title: "", body: "현재 이벤트 진행중이 아닙니다.", style: .alert, time: 2); return
                } else if maximumPeopleCount <= participantsCount {
                    self.setAlert(title: "", body: "이벤트 제한 인원이 초과되었습니다.", style: .alert, time: 2); return
                } else {
                    
                }
            }
        }
        
        DispatchGroup.leave()
        DispatchQueue.global().async {
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}
