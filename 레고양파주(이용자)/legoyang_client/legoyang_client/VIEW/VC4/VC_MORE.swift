//
//  VC_MORE.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/20.
//

import UIKit

class TC_MORE: UITableViewCell {
    
    @IBOutlet weak var TITLE_L: UILabel!
    @IBOutlet weak var INFO_L: UILabel!
}

class VC_MORE: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBOutlet weak var NOTICE_B: UIButton!
    @IBOutlet weak var SETTING_B: UIButton!
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    
    @IBOutlet weak var BACKGROUND_V: UIView!
    @IBOutlet weak var PROFILE_I: UIImageView!
    @IBOutlet weak var PROFILE_B: UIButton!
    @IBOutlet weak var ORDER_V: UIView!
    @IBOutlet weak var ORDER_B: UIButton!
    @IBOutlet weak var REPAY_V: UIView!
    @IBOutlet weak var REPAY_L: UILabel!
    
    @IBOutlet weak var COUPON_B: UIButton!
    @IBOutlet weak var WANT_B: UIButton!
    @IBOutlet weak var REVIEW_B: UIButton!
    @IBOutlet weak var BASKET_B: UIButton!
    
    @IBOutlet weak var GRADE_I: UIImageView!
    @IBOutlet weak var GRADE_B: UIButton!
    
    @IBOutlet weak var MORE_B: UIButton!
    @IBOutlet weak var TABLEVIEW: UITableView!
    @IBOutlet weak var TABLEVIEW_H: NSLayoutConstraint!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_MORE_DEL = self
        
        BACKGROUND_V.roundShadows(color: .black, offset: CGSize(width: 0, height: 5), opcity: 0.1, radius1: 5, radius2: 12.5)
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        TABLEVIEW_H.constant = CGFloat(UIViewController.appDelegate.OBJ_MAIN.COMMUNITY.count*65)
        
        loadView2()
    }
    
    func loadView2() {
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        let DATA = UIViewController.appDelegate.OBJ_USER
        
        if (MEMBER_ID != "") && (MEMBER_ID == DATA.NUMBER) {
            NUKE(IV: PROFILE_I, IU: DATA.PROFILE_IMG, PH: UIImage(), RD: 25, CM: .scaleAspectFill)
            if DATA.NAME != "" {
                PROFILE_B.setTitle("\(DATA.NAME)님 :D", for: .normal)
            } else {
                PROFILE_B.setTitle("\(DATA.NICK)님 :D", for: .normal)
            }
            ORDER_V.isHidden = false
            REPAY_L.text = "\((NF.string(from: (Int(DATA.POINT) ?? 0) as NSNumber) ?? "0"))원"
            GRADE_I.image = UIImage(named: "lv\(DATA.GRADE)")
        } else {
            PROFILE_B.setTitle("로그인 하기", for: .normal)
            ORDER_V.isHidden = true
            REPAY_L.text = "0원"
        }
        
        TABLEVIEW.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NOTICE_B.tag = 0; NOTICE_B.addTarget(self, action: #selector(HEADER_B(_:)), for: .touchUpInside)
        SETTING_B.tag = 1; SETTING_B.addTarget(self, action: #selector(HEADER_B(_:)), for: .touchUpInside)
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        let DATA = UIViewController.appDelegate.OBJ_USER
        
        if !((MEMBER_ID != "") && (MEMBER_ID == DATA.NUMBER)) { PROFILE_B.tag = 2 } else { PROFILE_B.tag = 1 }
        PROFILE_B.addTarget(self, action: #selector(HEADER_B(_:)), for: .touchUpInside)
        ORDER_B.addTarget(self, action: #selector(ORDER_B(_:)), for: .touchUpInside)
        
        COUPON_B.tag = 0; COUPON_B.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        WANT_B.tag = 1; WANT_B.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        REVIEW_B.tag = 2; REVIEW_B.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        BASKET_B.tag = 3; BASKET_B.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        GRADE_B.tag = 4; GRADE_B.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        
        MORE_B.addTarget(self, action: #selector(MORE_B(_:)), for: .touchUpInside)
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
    
    @objc func HEADER_B(_ sender: UIButton) {
        if sender.tag == 0 {
            segueViewController(identifier: "VC_NOTICE")
        } else if sender.tag == 1 {
            segueViewController(identifier: "SettingViewController")
        } else if sender.tag == 2 {
            segueViewController(identifier: "LoginAAViewController")
        }
    }
    
    @objc func ORDER_B(_ sender: UIButton) {
        segueViewController(identifier: "VC_ORDER1")
    }
    
    @objc func BUTTON(_ sender: UIButton) {
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        let DATA = UIViewController.appDelegate.OBJ_USER

        if (MEMBER_ID != "") && (MEMBER_ID == DATA.NUMBER) {
            if sender.tag == 0 {
                segueViewController(identifier: "VC_COUPON")
            } else if sender.tag == 1 {
                segueViewController(identifier: "VC_WANT")
            } else if sender.tag == 2 {
                let VC = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL3") as! VC_DETAIL3
                VC.TITLE = "더보기 - 리뷰"; VC.LINK = "https://m.cafe.naver.com/ca-fe/bssn1"
                navigationController?.pushViewController(VC, animated: true)
            } else if sender.tag == 3 {
                segueViewController(identifier: "VC_BASKET")
            } else if sender.tag == 4 {
                segueViewController(identifier: "VC_GRADE")
            }
        } else {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        }
    }
    
    @objc func MORE_B(_ sender: UIButton) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL3") as! VC_DETAIL3
        VC.TITLE = "커뮤니티"; VC.LINK = "https://m.cafe.naver.com/ca-fe/bssn1"
        navigationController?.pushViewController(VC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}

extension VC_MORE: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UIViewController.appDelegate.OBJ_MAIN.COMMUNITY.count > 0 { return UIViewController.appDelegate.OBJ_MAIN.COMMUNITY.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = UIViewController.appDelegate.OBJ_MAIN.COMMUNITY[indexPath.item]
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_MORE_1", for: indexPath) as! TC_MORE
        
        CELL.TITLE_L.text = DATA.TITLE
        CELL.INFO_L.text = "\(DATA.WRITER) ∙ \(DATA.DATE) ∙ 조회 \(DATA.VIEW) ∙ 좋아요 \(DATA.LIKE)"
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL3") as! VC_DETAIL3
        VC.TITLE = "커뮤니티"; VC.LINK = UIViewController.appDelegate.OBJ_MAIN.COMMUNITY[indexPath.item].URL
        navigationController?.pushViewController(VC, animated: true)
    }
}
