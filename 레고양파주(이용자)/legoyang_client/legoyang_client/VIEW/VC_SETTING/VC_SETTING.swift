//
//  VC_SETTING.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/30.
//

import UIKit
import FirebaseFirestore
import FirebaseMessaging

class TC_SETTING: UITableViewCell {
    
    @IBOutlet weak var BACKGROUND_V: UIView!
    
    @IBOutlet weak var PROFILE_I: UIImageView!
    @IBOutlet weak var NAME_L: UILabel!
    @IBOutlet weak var PHONE_L: UILabel!
    @IBOutlet weak var GRADE_SV: UIStackView!
    @IBOutlet weak var GRADE_I: UIImageView!
    
    @IBOutlet weak var TITLE_L1: UILabel!
    @IBOutlet weak var TITLE_L2: UILabel!
    @IBOutlet weak var SWITCH_B: UISwitch!
    @IBOutlet weak var LINE_V: UIView!
}

class VC_SETTING: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var TITLES = ["", "고객센터", "이용약관", "회사정보", "", ""]
    var MENUS0 = ["", "레공구 푸시 알림", "레고팡팡 푸시 알림"]
    var MENUS1 = ["공지사항", "blinkcorpad@gmail.com"]
    var MENUS2 = ["개인정보 처리방침 (위치정보 포함)", "서비스 이용약관 (전자상거래 포함)"]
    var MENUS3 = ["블링크코퍼레이션(주)", "경기도 고양시 일산동구 무궁화로 37 508~9호", "https://www.blinkcorp.co.kr", "111-87-01580", "031-932-9068"]
    var MENUS4 = ["소프트웨어 업데이트"]
    var MENUS5 = ["로그아웃", "회원탈퇴"]
    
    var PUSH0 = [false, true, true]
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        TABLEVIEW.separatorStyle = .none; if #available(iOS 15.0, *) { TABLEVIEW.sectionHeaderTopPadding = 0 }
        TABLEVIEW.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 20, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
        
        TABLEVIEW.reloadData()
    }
}

extension VC_SETTING: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if TITLES.count > 0 { return TITLES.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_TITLE") as! TC_TITLE
        if section == 0 || section == 5 { CELL.backgroundColor = .clear } else { CELL.backgroundColor = .H_F4F4F4 }
        CELL.TITLE_L.text = TITLES[section]
        return CELL
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return [20, 44, 44, 44, 20, 20][section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        let DATA = UIViewController.appDelegate.MemberObject
        
        if (MEMBER_ID != "") && (MEMBER_ID == DATA.number) {
            return [MENUS0, MENUS1, MENUS2, MENUS3, MENUS4, MENUS5][section].count
        } else {
            return [MENUS0, MENUS1, MENUS2, MENUS3, MENUS4, []][section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) && (indexPath.item == 0) {
            
            let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
            let data = UIViewController.appDelegate.MemberObject
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_SETTING_1", for: indexPath) as! TC_SETTING
            
            CELL.BACKGROUND_V.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10)
            
            if (MEMBER_ID != "") && (MEMBER_ID == data.number) {
                NUKE(IV: CELL.PROFILE_I, IU: data.profileImg, PH: UIImage(), RD: 25, CM: .scaleAspectFill)
                CELL.NAME_L.text = "\(data.name)(\(data.nick))님 :D"
                CELL.PHONE_L.isHidden = false; CELL.PHONE_L.text = setHyphen("phone", data.number)
                CELL.GRADE_SV.isHidden = false
                CELL.GRADE_I.isHidden = false; CELL.GRADE_I.image = UIImage(named: "lv\(data.grade)")
            } else {
                CELL.NAME_L.text = "로그인 하기"
                CELL.PHONE_L.isHidden = true
                CELL.GRADE_SV.isHidden = true
                CELL.GRADE_I.isHidden = true
            }
            
            return CELL
        } else {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_SETTING_2", for: indexPath) as! TC_SETTING
            
            if indexPath.section == 4 {
                CELL.BACKGROUND_V.layer.cornerRadius = 10
            } else if indexPath.item == 0 {
                CELL.BACKGROUND_V.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10); CELL.LINE_V.isHidden = false
            } else if ((indexPath.section == 0) && (indexPath.item == MENUS0.count-1)) || ((indexPath.section == 1) && (indexPath.item == MENUS1.count-1)) || ((indexPath.section == 2) && (indexPath.item == MENUS2.count-1)) || ((indexPath.section == 3) && (indexPath.item == MENUS3.count-1)) || ((indexPath.section == 5) && (indexPath.item == MENUS5.count-1)) {
                CELL.BACKGROUND_V.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10); CELL.LINE_V.isHidden = true
            } else {
                CELL.BACKGROUND_V.layer.cornerRadius = 0; CELL.LINE_V.isHidden = false
            }
            
            if indexPath.section == 3 { CELL.TITLE_L1.isHidden = false } else { CELL.TITLE_L1.isHidden = true }
            CELL.TITLE_L1.text = ["상호", "주소", "홈페이지", "사업자등록", "전화"][indexPath.item]
            if indexPath.section == 4 && indexPath.item == 0 {
                CELL.TITLE_L2.textColor = .H_FF6F00
            } else if indexPath.section == 5 && indexPath.item == 1 {
                CELL.TITLE_L2.textColor = .systemRed
            } else {
                CELL.TITLE_L2.textColor = .black
            }
            CELL.TITLE_L2.text = [MENUS0, MENUS1, MENUS2, MENUS3, MENUS4, MENUS5][indexPath.section][indexPath.item]
            if indexPath.section == 0 {
                CELL.SWITCH_B.isHidden = false
                if UIViewController.appDelegate.MemberId == "" { CELL.SWITCH_B.isOn = false } else { CELL.SWITCH_B.isOn = PUSH0[indexPath.item] }
                CELL.SWITCH_B.tag = indexPath.item; CELL.SWITCH_B.addTarget(self, action: #selector(SWITCH_B(_:)), for: .touchUpInside)
            } else {
                CELL.SWITCH_B.isHidden = true
            }
            
            return CELL
        }
    }
    
    @objc func SWITCH_B(_ sender: UISwitch) {
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        if MEMBER_ID != "" {
            if sender.tag == 1 {
                Firestore.firestore().collection("member").document(MEMBER_ID).setData(["legonggu_topic": "\(sender.isOn)"], merge: true)
                if sender.isOn {
                    Messaging.messaging().unsubscribe(fromTopic: "inform_gonggu_ios") { error in
                        if error == nil {
                            Messaging.messaging().subscribe(toTopic: "inform_gonggu_ios")
                            UIViewController.appDelegate.MemberObject.legongguTopic = "true"
                        }
                    }
                    if UIViewController.appDelegate.MemberId == "01031853309" {
                        Messaging.messaging().unsubscribe(fromTopic: "gonggu_test_ios") { error in
                            if error == nil { Messaging.messaging().subscribe(toTopic: "gonggu_test_ios") }
                        }
                    }
                } else {
                    Messaging.messaging().unsubscribe(fromTopic: "inform_gonggu_ios")
                    Messaging.messaging().unsubscribe(fromTopic: "gonggu_test_ios")
                    UIViewController.appDelegate.MemberObject.legongguTopic = "false"
                }
            } else if sender.tag == 2 {
                Firestore.firestore().collection("member").document(MEMBER_ID).setData(["pangpang_topic": "\(sender.isOn)"], merge: true)
                if sender.isOn {
                    Messaging.messaging().unsubscribe(fromTopic: "legopangpang_ios") { error in
                        if error == nil {
                            Messaging.messaging().subscribe(toTopic: "legopangpang_ios")
                            UIViewController.appDelegate.MemberObject.pangpangTopic = "true"
                        }
                    }
                    if UIViewController.appDelegate.MemberId == "01031853309" {
                        Messaging.messaging().unsubscribe(fromTopic: "around_test_ios") { error in
                            if error == nil { Messaging.messaging().subscribe(toTopic: "around_test_ios") }
                        }
                    }
                } else {
                    Messaging.messaging().unsubscribe(fromTopic: "legopangpang_ios")
                    Messaging.messaging().unsubscribe(fromTopic: "around_test_ios")
                    UIViewController.appDelegate.MemberObject.pangpangTopic = "false"
                }
            }
        } else {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController"); sender.isOn = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 { return 60 } else { return UITableView.automaticDimension }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        let data = UIViewController.appDelegate.MemberObject
        
        if indexPath.section == 0 {
            if (indexPath.item == 0) && !((MEMBER_ID != "") && (MEMBER_ID == data.number)) { segueViewController(identifier: "LoginAAViewController") } else { segueViewController(identifier: "VC_PROFILE") }
        } else if indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
            let VC = storyboard?.instantiateViewController(withIdentifier: "VC_HTML") as! VC_HTML
            VC.TITLE = MENUS2[indexPath.item]; VC.POSITION = indexPath.item+1
            navigationController?.pushViewController(VC, animated: true)
        } else if indexPath.section == 3 {
            
        } else if indexPath.section == 4 {
            segueViewController(identifier: "UpdateViewController")
        } else if indexPath.section == 5 {
            if indexPath.item == 0 {
                let ALERT = UIAlertController(title: "", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
                ALERT.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { _ in
                    
                    // 데이터 초기화
                    UserDefaults.standard.setValue(true, forKey: "first")
                    UserDefaults.standard.removeObject(forKey: "fcm_id")
                    UserDefaults.standard.removeObject(forKey: "member_id")
                    UserDefaults.standard.removeObject(forKey: "phonecheck")
                    UserDefaults.standard.removeObject(forKey: "emailcheck")
                    Messaging.messaging().unsubscribe(fromTopic: "legopangpang_ios")
                    Messaging.messaging().unsubscribe(fromTopic: "around_test_ios")
                    Messaging.messaging().unsubscribe(fromTopic: "inform_gonggu_ios")
                    Messaging.messaging().unsubscribe(fromTopic: "gonggu_test_ios")
                    
                    self.segueViewController(identifier: "LoadingViewController")
                }))
                ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                present(ALERT, animated: true, completion: nil)
            } else if indexPath.item == 1 {
                segueViewController(identifier: "VC_WITHDRAWAL")
            }
        }
    }
}

