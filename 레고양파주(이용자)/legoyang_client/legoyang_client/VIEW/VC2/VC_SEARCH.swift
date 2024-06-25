//
//  VC_SEARCH.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/17.
//

import UIKit

class CC_SEARCH: UICollectionViewCell {
    
    @IBOutlet weak var STORE_I: UIImageView!
}

class TC_SEARCH: UITableViewCell {
    
    var PROTOCOL: VC_SEARCH!
    
    var OBJ_SEARCH: [API_STORE] = []
    var OBJ_POSITION: Int = 0
    
    @IBOutlet weak var NO_IMAGE_L: UILabel!
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    
    @IBOutlet weak var STORE_I: UIImageView!
    @IBOutlet weak var QUOTE_LEFT_I: UIImageView!
    @IBOutlet weak var STORE_L: UILabel!
    @IBOutlet weak var QUOTE_RIGHT_I: UIImageView!
    @IBOutlet weak var CATEGORY_L: UILabel!
    @IBOutlet weak var COUPON_SV: UIStackView!
    @IBOutlet weak var COUPON_L: UILabel!
    @IBOutlet weak var SUBJECT_L: UILabel!
    @IBOutlet weak var CONTENTS_L: UILabel!
    @IBOutlet weak var MENUS_V: UIView!
    @IBOutlet weak var MENUS_L: UILabel!
    
    func viewDidLoad() {
        
        COLLECTIONVIEW.delegate = nil; COLLECTIONVIEW.dataSource = nil
        
        if OBJ_SEARCH[OBJ_POSITION].ST_IMAGES.count > 0 {
            NO_IMAGE_L.isHidden = true; COLLECTIONVIEW.isHidden = false
        } else {
            NO_IMAGE_L.isHidden = false; COLLECTIONVIEW.isHidden = true
        }
        
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.scrollDirection = .horizontal; LAYOUT.minimumLineSpacing = 10; LAYOUT.minimumInteritemSpacing = 0
        LAYOUT.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        COLLECTIONVIEW.setCollectionViewLayout(LAYOUT, animated: false, completion: nil)
        
        COLLECTIONVIEW.delegate = self; COLLECTIONVIEW.dataSource = self
        COLLECTIONVIEW.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BACKGROUND_V(_:))))
    }
    
    @objc func BACKGROUND_V(_ sender: UITapGestureRecognizer) {
        
        let VC = PROTOCOL.storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL1") as! VC_DETAIL1
        VC.OBJ_STORE = OBJ_SEARCH; VC.OBJ_POSITION = OBJ_POSITION
        PROTOCOL.navigationController?.pushViewController(VC, animated: true)
    }
}

extension TC_SEARCH: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if OBJ_SEARCH.count > 0 { return OBJ_SEARCH[OBJ_POSITION].ST_IMAGES.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let DATA = OBJ_SEARCH[OBJ_POSITION]
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC_SEARCH_1", for: indexPath) as! CC_SEARCH
        
        PROTOCOL.NUKE(IV: CELL.STORE_I, IU: DATA.ST_IMAGES[indexPath.item], PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
}


class VC_SEARCH: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var OBJ_STORE: [API_STORE] = []
    var OBJ_SEARCH: [API_STORE] = []
    
    @IBOutlet weak var HEADER_V: UIView!
    @IBOutlet weak var NOTICE_V: UIView!
    @IBOutlet weak var NOTICE_B: UIButton!
    @IBOutlet weak var USER_I: UIImageView!
    @IBOutlet weak var USER_B: UIButton!
    @IBOutlet weak var SEARCH_TF: UITextField!
    @IBOutlet weak var SEARCH_B: UIButton!
    @IBOutlet weak var LINE_V: UIView!
    
    @IBAction func BACK_B(_ sender: UIButton) { SEARCH_TF.resignFirstResponder(); navigationController?.popViewController(animated: false) }
    
    @IBOutlet weak var BACKVIEW: UIView!
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        setKeyboard()
        
        NOTICE_V.isHidden = true
        if UserDefaults.standard.string(forKey: "member_id") ?? "" != "" {
            for DATA in UIViewController.appDelegate.OBJ_USER.NOTI_LIST { if DATA.READORNOT == "false" { NOTICE_V.isHidden = false } }
            if UIViewController.appDelegate.OBJ_USER.PROFILE_IMG != "" {
                NUKE(IV: USER_I, IU: UIViewController.appDelegate.OBJ_USER.PROFILE_IMG, RD: 10, CM: .scaleAspectFill)
            } else {
                USER_I.image = UIImage(named: "my"); USER_I.layer.cornerRadius = 10
            }; USER_I.backgroundColor = .H_F4F4F4
        } else {
            USER_I.backgroundColor = .clear
        }
        SEARCH_TF.becomeFirstResponder()
        SEARCH_TF.paddingLeft(20); SEARCH_TF.paddingRight(20)
        SEARCH_TF.placeholder("풀빌라? 야식? 카페?", COLOR: .white)
        
        BACKVIEW.isHidden = false; TABLEVIEW.isHidden = true
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
//        TABLEVIEW.keyboardDismissMode = .onDrag
        
        GET_STORE(NAME: "검색", AC_TYPE: "store")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NOTICE_B.tag = 0; NOTICE_B.addTarget(self, action: #selector(HEADER_B(_:)), for: .touchUpInside)
        USER_B.tag = 1; USER_B.addTarget(self, action: #selector(HEADER_B(_:)), for: .touchUpInside)
        
        SEARCH_TF.addTarget(self, action: #selector(SEARCH_TF(_:)), for: .editingChanged)
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
    
    @objc func HEADER_B(_ sender: UIButton) { SEARCH_TF.resignFirstResponder()
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        let DATA = UIViewController.appDelegate.OBJ_USER
        
        if sender.tag == 0 {
            segueViewController(identifier: "VC_NOTICE", animated: true)
        } else if sender.tag == 1 {
            if (MEMBER_ID != "") && (MEMBER_ID == DATA.NUMBER) { segueViewController(identifier: "SettingViewController") } else { segueViewController(identifier: "LoginAAViewController") }
        } else if sender.tag == 2 {
            segueViewController(identifier: "VC_SEARCH", animated: false)
        }
    }
    
    @objc func SEARCH_TF(_ sender: UITextField) {
        // 데이터 삭제
        OBJ_SEARCH.removeAll()
        
        for (I, DATA) in OBJ_STORE.enumerated() {
            // 데이터 추가
            if (DATA.ST_NAME.range(of: sender.text!, options: .caseInsensitive) != nil) {
                OBJ_SEARCH.append(OBJ_STORE[I])
            } else {
                for TAG in DATA.ST_TAG { if (TAG.range(of: sender.text!, options: .caseInsensitive) != nil) { OBJ_SEARCH.append(OBJ_STORE[I]); break } }
            }
        }; TABLEVIEW.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}

extension VC_SEARCH: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if OBJ_SEARCH.count > 0 { BACKVIEW.isHidden = true; TABLEVIEW.isHidden = false; return OBJ_SEARCH.count } else { BACKVIEW.isHidden = false; TABLEVIEW.isHidden = true; return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            
            let DATA = OBJ_SEARCH[indexPath.item]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_SEARCH_1", for: indexPath) as! TC_SEARCH
            CELL.PROTOCOL = self; CELL.OBJ_SEARCH = OBJ_SEARCH; CELL.OBJ_POSITION = indexPath.item; CELL.viewDidLoad()
            
            CELL.QUOTE_LEFT_I.image = UIImage(named: quoteLeftImages[DATA.ST_COLOR] ?? "quote_left0")
            CELL.STORE_L.text = " \(DATA.ST_NAME) "
            CELL.QUOTE_RIGHT_I.image = UIImage(named: quoteRightImages[DATA.ST_COLOR] ?? "quote_right0")
            CELL.CATEGORY_L.text = DATA.ST_CATEGORY
            if DATA.USE_PANGPANG == "true" { CELL.COUPON_SV.isHidden = false; CELL.COUPON_L.text = DT_CHECK("\(DATA.PP_REMAIN)") } else { CELL.COUPON_SV.isHidden = true }
            CELL.SUBJECT_L.text = DT_CHECK(DATA.ST_SUB_TITLE)
            CELL.CONTENTS_L.text = DT_CHECK(DATA.ST_ETC)
            var MENUS: String = ""
            for i in 0 ..< DATA.ST_MENU.count {
                MENUS.append("#\(DATA.ST_MENU[i].MENU_NAME)(\(NF.string(from: (Int(DATA.ST_MENU[i].MENU_PRICE) ?? 0) as NSNumber) ?? "0")원) ")
            }
            if MENUS == "" { CELL.MENUS_V.isHidden = true } else { CELL.MENUS_V.isHidden = false; CELL.MENUS_L.text = MENUS }
            
            return CELL
        } else if indexPath.item >= 1 {
            
            let DATA = OBJ_SEARCH[indexPath.item]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_SEARCH_2", for: indexPath) as! TC_SEARCH
            CELL.PROTOCOL = self; CELL.OBJ_SEARCH = OBJ_SEARCH; CELL.OBJ_POSITION = indexPath.item
            
            if DATA.ST_IMAGE != "" {
                NUKE(IV: CELL.STORE_I, IU: DATA.ST_IMAGE, PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
            } else if DATA.ST_IMAGES.count > 0 {
                NUKE(IV: CELL.STORE_I, IU: DATA.ST_IMAGES[0], PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
            } else {
                CELL.STORE_I.image = UIImage(named: "logo2")
            }
            CELL.QUOTE_LEFT_I.image = UIImage(named: quoteLeftImages[DATA.ST_COLOR] ?? "quote_left0")
            CELL.STORE_L.text = " \(DATA.ST_NAME) "
            CELL.QUOTE_RIGHT_I.image = UIImage(named: quoteRightImages[DATA.ST_COLOR] ?? "quote_right0")
            if DATA.USE_PANGPANG == "true" { CELL.COUPON_SV.isHidden = false; CELL.COUPON_L.text = DT_CHECK("\(DATA.PP_REMAIN)") } else { CELL.COUPON_SV.isHidden = true }
            CELL.SUBJECT_L.text = DT_CHECK(DATA.ST_SUB_TITLE)
            CELL.MENUS_L.text = DATA.ST_ETC
            
            return CELL
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        SEARCH_TF.resignFirstResponder()
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL1") as! VC_DETAIL1
        VC.OBJ_STORE = OBJ_SEARCH; VC.OBJ_POSITION = indexPath.item
        navigationController?.pushViewController(VC, animated: true)
    }
}
