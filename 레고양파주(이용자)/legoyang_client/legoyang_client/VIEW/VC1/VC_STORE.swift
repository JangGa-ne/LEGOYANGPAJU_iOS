//
//  VC_STORE.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/18.
//

import UIKit

class CC_STORE: UICollectionViewCell {
   
    @IBOutlet weak var TITLE_L: UILabel!
    
    @IBOutlet weak var STORE_I: UIImageView!
}

class TC_STORE: UITableViewCell {
    
    var PROTOCOL: VC_STORE!
    
    var OBJ_STORE: [API_STORE] = []
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
        
        if OBJ_STORE[OBJ_POSITION].ST_IMAGES.count > 0 {
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
        VC.OBJ_STORE = OBJ_STORE; VC.OBJ_POSITION = OBJ_POSITION
        PROTOCOL.navigationController?.pushViewController(VC, animated: true)
    }
}

extension TC_STORE: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if OBJ_STORE.count > 0 { return OBJ_STORE[OBJ_POSITION].ST_IMAGES.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let DATA = OBJ_STORE[OBJ_POSITION]
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC_STORE_1", for: indexPath) as! CC_STORE
        
        PROTOCOL.NUKE(IV: CELL.STORE_I, IU: DATA.ST_IMAGES[indexPath.item], PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
}

class VC_STORE: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var LEGOPANGPANG: Bool = false
    var RF_CONTROL = UIRefreshControl()
    
    var OBJ_CATEGORY: [API_CATEGORY] = []
    var OBJ_POSITION: Int = 0
    
    var OBJ_LIST: [API_STORE] = []
    var OBJ_STORE: [API_STORE] = []
    var OBJ_SEARCH: [API_STORE] = []
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var SEARCH_TF: UITextField!
    @IBOutlet weak var SEARCH_B: UIButton!
    
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        setKeyboard()
        
        SEARCH_TF.placeholder("검색어를 입력해 주세요.", COLOR: .lightGray)
        
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.scrollDirection = .horizontal; LAYOUT.minimumLineSpacing = 0; LAYOUT.minimumInteritemSpacing = 10
        LAYOUT.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        COLLECTIONVIEW.setCollectionViewLayout(LAYOUT, animated: false, completion: nil)
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        TABLEVIEW.keyboardDismissMode = .onDrag
        
        GET_STORE(NAME: "가게정보", AC_TYPE: "store")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SEARCH_TF.addTarget(self, action: #selector(SEARCH_TF(_:)), for: .editingChanged)
        
        COLLECTIONVIEW.delegate = self; COLLECTIONVIEW.dataSource = self
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
        
        RF_CONTROL.backgroundColor = .clear; RF_CONTROL.tintColor = .H_00529C
        RF_CONTROL.addTarget(self, action: #selector(RF_CONTROL(_:)), for: .valueChanged)
        TABLEVIEW.refreshControl = RF_CONTROL
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
    
    @objc func RF_CONTROL(_ sender: UIRefreshControl) {
        GET_STORE(NAME: "가게정보", AC_TYPE: "store")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension VC_STORE: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if OBJ_CATEGORY.count > 0 { return OBJ_CATEGORY.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let DATA = OBJ_CATEGORY[indexPath.item]
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC_STORE_1", for: indexPath) as! CC_STORE
        
        if indexPath.item == OBJ_POSITION {
            CELL.backgroundColor = .H_00529C; CELL.TITLE_L.textColor = .white
        } else {
            CELL.backgroundColor = .H_F4F4F4; CELL.TITLE_L.textColor = .black.withAlphaComponent(0.5)
        }
        
        CELL.TITLE_L.text = DATA.NAME
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { UIImpactFeedbackGenerator().impactOccurred()
        OBJ_POSITION = indexPath.item; GET_STORE(NAME: "가게정보", AC_TYPE: "store"); COLLECTIONVIEW.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (OBJ_CATEGORY[indexPath.item].NAME.count * 12) + 40, height: 40)
    }
}

extension VC_STORE: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if OBJ_SEARCH.count > 0 { return OBJ_SEARCH.count } else if OBJ_STORE.count > 0 { return OBJ_STORE.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_STORE_1", for: indexPath) as! TC_STORE
            
            if OBJ_SEARCH.count > 0 {
                
                let DATA = OBJ_SEARCH[indexPath.item]
                
                CELL.PROTOCOL = self; CELL.OBJ_STORE = OBJ_SEARCH; CELL.OBJ_POSITION = indexPath.item; CELL.viewDidLoad()
                
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
            } else {
                
                let DATA = OBJ_STORE[indexPath.item]
                
                CELL.PROTOCOL = self; CELL.OBJ_STORE = OBJ_STORE; CELL.OBJ_POSITION = indexPath.item; CELL.viewDidLoad()
                
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
            }
            
            return CELL
        } else if indexPath.item >= 1 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_STORE_2", for: indexPath) as! TC_STORE
            
            if OBJ_SEARCH.count > 0 {
                
                let DATA = OBJ_SEARCH[indexPath.item]
                
                CELL.PROTOCOL = self; CELL.OBJ_STORE = OBJ_SEARCH; CELL.OBJ_POSITION = indexPath.item
                
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
            } else {
                
                let DATA = OBJ_STORE[indexPath.item]
                
                CELL.PROTOCOL = self; CELL.OBJ_STORE = OBJ_STORE; CELL.OBJ_POSITION = indexPath.item
                
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
            }
            
            return CELL
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL1") as! VC_DETAIL1
        if OBJ_SEARCH.count > 0 { VC.OBJ_STORE = OBJ_SEARCH } else { VC.OBJ_STORE = OBJ_STORE }; VC.OBJ_POSITION = indexPath.item
        navigationController?.pushViewController(VC, animated: true)
    }
}
