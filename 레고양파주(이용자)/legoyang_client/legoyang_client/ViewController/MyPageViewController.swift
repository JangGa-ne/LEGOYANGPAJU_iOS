//
//  MyPageViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/10.
//

import UIKit

class MyPageViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameButton: UIButton!
    @IBOutlet weak var orderListButton: UIButton!
    @IBOutlet weak var lepayPointLabel: UILabel!
    
    @IBOutlet weak var couponButton: UIButton!
    @IBOutlet weak var wantButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var basketButton: UIButton!
    
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet weak var gradeImageView: UIImageView!
    
    @IBOutlet weak var communityButton: UIButton!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var listViewHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.MyPageViewControllerDelegate = self
        
        nickNameButton.addTarget(self, action: #selector(nickNameButton(_:)), for: .touchUpInside)
        gradeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gradeTap(_:))))
        communityButton.addTarget(self, action: #selector(communityButton(_:)), for: .touchUpInside)
        
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        listView.delegate = self; listView.dataSource = self
        listViewHeight.constant = CGFloat(UIViewController.appDelegate.AppLegoObject.community.count*65)
        
        for (i, button) in [orderListButton, couponButton, wantButton, reviewButton, basketButton].enumerated() {
            button?.tag = i; button?.addTarget(self, action: #selector(segueButton(_:)), for: .touchUpInside)
        }
        
        loadingData()
    }
    
    @objc func segueButton(_ sender: UIButton) {
        
        if UIViewController.appDelegate.MemberId == "" {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else if sender.tag == 0 {
            segueViewController(identifier: "VC_ORDER1")
        } else if sender.tag == 1 {
            segueViewController(identifier: "CouponViewController")
        } else if sender.tag == 2 {
            segueViewController(identifier: "WantViewController")
        } else if sender.tag == 3 {
            communityButton(sender)
        } else if sender.tag == 4 {
            segueViewController(identifier: "BasketViewController")
        }
    }
    
    func loadingData() {
        
        if UIViewController.appDelegate.MemberId == "" {
            
            profileImageView.image = UIImage(named: "logo2")
            nickNameButton.setTitle("로그인하기", for: .normal)
            lepayPointLabel.text = "0원"
            
            gradeImageView.isHidden = true
            
        } else {
            
            let data = UIViewController.appDelegate.MemberObject
            if data.profileImg != "" {
                setImageNuke(imageView: profileImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.profileImg, cornerRadius: 25, contentMode: .scaleAspectFill)
            } else {
                profileImageView.image = UIImage(named: "logo2")
            }
            nickNameButton.setTitle("\(data.name)(\(data.nick))", for: .normal)
            lepayPointLabel.text = "\(NF.string(from: (Int(data.point) ?? 0) as NSNumber) ?? "0")원"
            
            gradeImageView.isHidden = false
            gradeImageView.image = UIImage(named: "lv\(data.grade)")
        }
    }
    
    @objc func nickNameButton(_ sender: UIButton) {
        if UIViewController.appDelegate.MemberId == "" {
            segueViewController(identifier: "LoginAAViewController")
        } else {
            segueViewController(identifier: "SettingViewController")
        }
    }
    
    @objc func gradeTap(_ sender: UITapGestureRecognizer) {
        if UIViewController.appDelegate.MemberId == "" {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else {
            segueViewController(identifier: "VC_GRADE")
        }
    }
    
    @objc func communityButton(_ sender: UIButton) {
        
        let segue = storyboard?.instantiateViewController(withIdentifier: "SafariViewController") as! SafariViewController
        segue.titleName = "커뮤니티"; segue.linkUrl = "https://m.cafe.naver.com/ca-fe/bssn1"
        navigationController?.pushViewController(segue, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
        
        UIViewController.CouponViewControllerDelegate = nil
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UIViewController.appDelegate.AppLegoObject.community.count > 0 { return UIViewController.appDelegate.AppLegoObject.community.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = UIViewController.appDelegate.AppLegoObject.community[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageListCell_1", for: indexPath) as! MyPageListCell
        
        cell.mainTitleLabel.text = data.title
        cell.subTitleLabel.text = "\(data.writer) ∙ \(data.date) ∙ 조회 \(data.view) ∙ 좋아요 \(data.like)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let segue = storyboard?.instantiateViewController(withIdentifier: "SafariViewController") as! SafariViewController
        segue.titleName = "커뮤니티"; segue.linkUrl = UIViewController.appDelegate.AppLegoObject.community[indexPath.row].url
        navigationController?.pushViewController(segue, animated: true)
    }
}





class MyPageListCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameButton: UIButton!
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var gradeButton: UIButton!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var eventView: UIView!
    
    @IBOutlet weak var couponButton: UIButton!
    @IBOutlet weak var wantButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var basketButton: UIButton!
    
    @IBOutlet weak var communityButton: UIButton!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
}

class MyPageViewController2: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.MyPageViewController2Delegate = self
        
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        listView.delegate = self; listView.dataSource = self
    }
}

extension MyPageViewController2: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if UIViewController.appDelegate.AppLegoObject.community.count > 0 { return UIViewController.appDelegate.AppLegoObject.community.count } else { return 0 }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let data = UIViewController.appDelegate.MemberObject
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageListCell_1", for: indexPath) as! MyPageListCell
            
            if UIViewController.appDelegate.MemberId != "" {
                
                if data.profileImg != "" {
                    setImageNuke(imageView: cell.profileImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.profileImg, cornerRadius: 25, contentMode: .scaleAspectFill)
                } else {
                    cell.profileImageView.image = UIImage(named: "logo2")
                }
                cell.profileNameButton.setTitle("\(data.name)(\(data.nick))님", for: .normal)
                
                cell.gradeImageView.image = UIImage(named: "lv\(data.grade)")
                cell.gradeButton.tag = 4; cell.gradeButton.addTarget(self, action: #selector(segueButton(_:)), for: .touchUpInside)
                
                cell.eventView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(segueTap(_:))))
                
            } else {
                
                cell.profileNameButton.setTitle("로그인을 해주세요!", for: .normal)
            }
            
            cell.profileNameButton.addTarget(self, action: #selector(profileNameButton(_:)), for: .touchUpInside)
            
            for (i, button) in [cell.couponButton, cell.wantButton, cell.orderButton, cell.basketButton].enumerated() {
                button?.tag = i; button?.addTarget(self, action: #selector(segueButton(_:)), for: .touchUpInside)
            }
            
            cell.communityButton.addTarget(self, action: #selector(communityButton(_:)), for: .touchUpInside)
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let data = UIViewController.appDelegate.AppLegoObject.community[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageListCell_2", for: indexPath) as! MyPageListCell
            
            cell.mainTitleLabel.text = data.title
            cell.subTitleLabel.text = "\(data.writer) ∙ \(data.date) ∙ 조회 \(data.view) ∙ 좋아요 \(data.like)"
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let data = UIViewController.appDelegate.AppLegoObject.community[indexPath.row]
            let segue = storyboard?.instantiateViewController(withIdentifier: "SafariViewController") as! SafariViewController
            segue.titleName = "레고팡팡 후기"; segue.linkUrl = data.url
            navigationController?.pushViewController(segue, animated: true)
        }
    }
    
    @objc func profileNameButton(_ sender: UIButton) {
        if UIViewController.appDelegate.MemberId == "" {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else {
            segueViewController(identifier: "SettingViewController")
        }
    }
    
    @objc func segueTap(_ sender: UITapGestureRecognizer) {
        segueViewController(identifier: "EventViewController")
    }
    
    @objc func segueButton(_ sender: UIButton) {
        
        if UIViewController.appDelegate.MemberId == "" {
            S_NOTICE("로그린 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else if sender.tag == 0 {
            segueViewController(identifier: "CouponViewController")
        } else if sender.tag == 1 {
            segueViewController(identifier: "WantViewController")
        } else if sender.tag == 2 {
            segueViewController(identifier: "VC_ORDER1")
        } else if sender.tag == 3 {
            segueViewController(identifier: "BasketViewController")
        } else if sender.tag == 4 {
            segueViewController(identifier: "VC_GRADE")
        }
    }
    
    @objc func communityButton(_ sender: UIButton) {
        let segue = storyboard?.instantiateViewController(withIdentifier: "SafariViewController") as! SafariViewController
        segue.titleName = "레고팡팡 후기"; segue.linkUrl = "https://m.cafe.naver.com/ca-fe/bssn1"
        navigationController?.pushViewController(segue, animated: true)
    }
}
