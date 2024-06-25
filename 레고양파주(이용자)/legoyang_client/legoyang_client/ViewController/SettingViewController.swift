//
//  SettingViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/05/02.
//

import UIKit
import FirebaseFirestore
import FirebaseMessaging

class SettingListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var porfileNumberLabel: UILabel!
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var pushSwitch: UISwitch!
    @IBOutlet weak var lineView: UIView!
}

class SettingViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    let SettingObject: [[String: Any]] = [
        [
            "title": "",
            "mainTitle": ["", "", ""],
            "subTitle": ["", "레공구 푸시 알림", "레고팡팡 푸시 알림"]
        ],
        [
            "title": "고객센터",
            "mainTitle": ["", ""],
            "subTitle": ["공지사항", "blinkcorpad@gmail.com"]
        ],
        [
            "title": "이용약관",
            "mainTitle": ["", "", ""],
            "subTitle": ["서비스 이용약관 (전자상거래 포함)", "개인정보 수집 (위치정보 포함)", "전화번호 정책"]
        ],
        [
            "title": "회사정보",
            "mainTitle": ["상호", "주소", "홈페이지", "사업자", "전화"],
            "subTitle": ["블링크코퍼레이션(주)", "경기도 고양시 일산동구 무궁화로 37, 508~9호", "https://www.blinkcorp.co.kr", "111-87-01580", "031-932-9068"]
        ],
        [
            "title": "",
            "mainTitle": [""],
            "subTitle": ["소프트웨어 업데이트"]
        ],
        [
            "title": "",
            "mainTitle": ["", ""],
            "subTitle": ["로그아웃", "회원탈퇴"]
        ]
    ]
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.SettingViewControllerDelegate = self
        
        if #available(iOS 15.0, *) { listView.sectionHeaderTopPadding = 0 }
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        listView.delegate = self; listView.dataSource = self
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if SettingObject.count > 0 { return SettingObject.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let data = SettingObject[section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListCell_T") as! SettingListCell
        
        cell.titleLabel.text = data["title"] as? String ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if SettingObject[section]["title"] as? String ?? "" == "" { return 20 } else { return 44 }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (SettingObject[section]["mainTitle"] as? [String] ?? []).count > 0 { return (SettingObject[section]["mainTitle"] as? [String] ?? []).count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = SettingObject[indexPath.section]
        
        let mainTitle = data["mainTitle"] as? [String] ?? []
        let subTitle = data["subTitle"] as? [String] ?? []
        
        if (indexPath.section == 0) && (indexPath.row == 0) {
            
            let data = UIViewController.appDelegate.MemberObject
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListCell_1", for: indexPath) as! SettingListCell
            
            if indexPath.row == 0 {
                cell.titleView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10); cell.lineView.isHidden = false
            } else if indexPath.row == (mainTitle.count-1) {
                cell.titleView.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10); cell.lineView.isHidden = true
            } else {
                cell.titleView.layer.cornerRadius = 0; cell.lineView.isHidden = false
            }
            
            if data.profileImg != "" {
                setImageNuke(imageView: cell.profileImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.profileImg, cornerRadius: 25, contentMode: .scaleAspectFill)
            } else {
                cell.profileImageView.image = UIImage(named: "logo2")
            }
            
            cell.profileNameLabel.text = "\(data.name)(\(data.nick))님"
            cell.porfileNumberLabel.text = setHyphen("phone", data.number)
            cell.gradeImageView.image = UIImage(named: "lv\(data.grade)")
            
            return cell
            
        } else {
            
            let data = UIViewController.appDelegate.MemberObject
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListCell_2", for: indexPath) as! SettingListCell
            
            if indexPath.row == 0 {
                cell.titleView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10); cell.lineView.isHidden = false
            } else if indexPath.row == (mainTitle.count-1) {
                cell.titleView.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10); cell.lineView.isHidden = true
            } else {
                cell.titleView.layer.cornerRadius = 0; cell.lineView.isHidden = false
            }
            
            cell.pushSwitch.isHidden = true
            cell.mainTitleLabel.isHidden = true
            cell.mainTitleLabel.text = mainTitle[indexPath.row]
            cell.subTitleLabel.textColor = .black
            cell.subTitleLabel.text = subTitle[indexPath.row]
            
            if indexPath.section == 0 {
                cell.pushSwitch.isHidden = false
                cell.pushSwitch.isOn = [false, Bool(data.legongguTopic), Bool(data.pangpangTopic)][indexPath.row] ?? false
                cell.pushSwitch.tag = indexPath.row; cell.pushSwitch.addTarget(self, action: #selector(pushSwitch(_:)), for: .touchUpInside)
            } else if indexPath.section == 3 {
                cell.mainTitleLabel.isHidden = false
            } else if indexPath.section == 4 {
                cell.titleView.layer.cornerRadius = 10; cell.titleView.clipsToBounds = true; cell.lineView.isHidden = true
                cell.subTitleLabel.textColor = .systemOrange
            } else if (indexPath.section == 5) && (indexPath.row == 1) {
                cell.subTitleLabel.textColor = .systemRed
            }
            
            return cell
        }
    }
    
    @objc func pushSwitch(_ sender: UISwitch) {
        
        let ref = Firestore.firestore().collection("member").document(UIViewController.appDelegate.MemberId)
        
        if sender.tag == 1 {
            
            ref.setData(["legonggu_topic": "\(sender.isOn)"], merge: true)
            
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
            
            ref.setData(["pangpang_topic": "\(sender.isOn)"], merge: true)
            
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 0) && (indexPath.item == 0) {
            segueViewController(identifier: "VC_PROFILE")
        } else if indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
            
            let linkUrls: [Int: Any] = [
                0: "https://sites.google.com/view/legoyangpaju-privacy",
                1: "https://sites.google.com/view/legoyangpaju-termsofservice",
                2: "https://sites.google.com/view/legoyangpaju-phonenumber",
            ]
            let segue = storyboard?.instantiateViewController(withIdentifier: "SafariViewController") as! SafariViewController
            segue.titleName = (SettingObject[indexPath.section]["subTitle"] as? [String] ?? [])[indexPath.row]
            segue.linkUrl = linkUrls[indexPath.row] as? String ?? ""
            navigationController?.pushViewController(segue, animated: true)
            
        } else if indexPath.section == 3 {
            
        } else if indexPath.section == 4 {
            segueViewController(identifier: "UpdateViewController")
        } else if indexPath.section == 5 {
            
            if indexPath.row == 0 {
                
                let alert = UIAlertController(title: "", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { _ in
                    self.resetData()
                }))
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                
            } else if indexPath.row == 1 {
                segueViewController(identifier: "VC_WITHDRAWAL")
            }
        }
    }
    
    func resetData() {
        
        UserDefaults.standard.setValue(true, forKey: "first")
        UserDefaults.standard.removeObject(forKey: "member_id")
        UserDefaults.standard.removeObject(forKey: "phonecheck")
        UserDefaults.standard.removeObject(forKey: "emailcheck")
        
        Messaging.messaging().unsubscribe(fromTopic: "legopangpang_ios")
        Messaging.messaging().unsubscribe(fromTopic: "around_test_ios")
        Messaging.messaging().unsubscribe(fromTopic: "inform_gonggu_ios")
        Messaging.messaging().unsubscribe(fromTopic: "gonggu_test_ios")
        
        segueViewController(identifier: "LoadingViewController")
    }
}
