//
//  VC_LEGOPANGPANG.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/30.
//

import UIKit

class TC_COUPON: UITableViewCell {
    
    @IBOutlet weak var DATETIME_L: UILabel!
    @IBOutlet weak var QRCODE_B: UIButton!
    @IBOutlet weak var CAFE_B: UIButton!
    
    @IBOutlet weak var STORE_I: UIImageView!
    @IBOutlet weak var QUOTE_LEFT_I: UIImageView!
    @IBOutlet weak var STORE_L: UILabel!
    @IBOutlet weak var QUOTE_RIGHT_I: UIImageView!
    @IBOutlet weak var ADDRESS_L: UILabel!
    @IBOutlet weak var SUBJECT_L: UILabel!
    @IBOutlet weak var MENUS_L: UILabel!
    
    @IBOutlet weak var PANGPANG_I: UIImageView!
    @IBOutlet weak var PANGPANG_L: UILabel!
    @IBOutlet weak var REVIEW_TF: UITextField!
    @IBOutlet weak var REVIEW_B: UIButton!
    @IBOutlet weak var AFTERINFO_L: UILabel!
    @IBOutlet weak var SHARE_V: UIView!
    @IBOutlet weak var SHARE_B: UIButton!
}

class VC_COUPON: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var POSITION: Int = 0
    var REVIEW: String = ""
    var WRITE_REVIEW: String = "false"
    
    var OBJ_COUPON1: [API_COUPON] = []
    var OBJ_COUPON2: [API_COUPON] = []
    var OBJ_POSITION: Int = 0
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_COUPON_DEL = self
        
        setKeyboard()
        
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.scrollDirection = .horizontal; LAYOUT.minimumLineSpacing = 0; LAYOUT.minimumInteritemSpacing = 10
        LAYOUT.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        COLLECTIONVIEW.setCollectionViewLayout(LAYOUT, animated: false, completion: nil)
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        TABLEVIEW.keyboardDismissMode = .onDrag
        
        GET_COUPON(NAME: "더보기 쿠폰", AC_TYPE: "member_pangpang_history")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        COLLECTIONVIEW.delegate = self; COLLECTIONVIEW.dataSource = self
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension VC_COUPON: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC_TITLE", for: indexPath) as! CC_TITLE
        
        if indexPath.item == POSITION {
            CELL.backgroundColor = .H_00529C; CELL.TITLE_L.textColor = .white
        } else {
            CELL.backgroundColor = .H_F4F4F4; CELL.TITLE_L.textColor = .black.withAlphaComponent(0.5)
        }
        
        CELL.TITLE_L.text = ["미사용 쿠폰", "사용완료 쿠폰"][indexPath.item]
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { UIImpactFeedbackGenerator().impactOccurred()
        POSITION = indexPath.item; COLLECTIONVIEW.reloadData(); TABLEVIEW.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (["미사용 쿠폰", "사용완료 쿠폰"][indexPath.item].count * 12) + 40, height: 40)
    }
}

extension VC_COUPON: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if POSITION == 0 {
            if OBJ_COUPON1.count > 0 { return OBJ_COUPON1.count } else { return 0 }
        } else if POSITION == 1 {
            if OBJ_COUPON2.count > 0 { return OBJ_COUPON2.count } else { return 0 }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_COUPON_1", for: indexPath) as! TC_COUPON
        
        if POSITION == 0 {
            
            let DATA = OBJ_COUPON1[indexPath.item]
            
            CELL.DATETIME_L.text = FM_TIMESTAMP(Int(DATA.RECEIVE_TIME) ?? 0, "yy.MM.dd E. HH:mm:ss")
            CELL.QRCODE_B.isHidden = false
            CELL.QRCODE_B.tag = indexPath.item; CELL.QRCODE_B.addTarget(self, action: #selector(QRCODE_B(_:)), for: .touchUpInside)
            CELL.CAFE_B.isHidden = true
            
            if DATA.ST_IMAGE != "" {
                NUKE(IV: CELL.STORE_I, IU: DATA.ST_IMAGE, PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
            } else if DATA.ST_IMAGES.count > 0 {
                NUKE(IV: CELL.STORE_I, IU: DATA.ST_IMAGES[0], PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
            }
            CELL.QUOTE_LEFT_I.image = UIImage(named: quoteLeftImages[DATA.ST_COLOR] ?? "quote_left0")
            CELL.STORE_L.text = " \(DATA.ST_NAME) "
            CELL.QUOTE_RIGHT_I.image = UIImage(named: quoteRightImages[DATA.ST_COLOR] ?? "quote_right0")
            CELL.ADDRESS_L.text = DATA.ST_ADDRESS
            CELL.SUBJECT_L.text = DT_CHECK(DATA.ST_SUB_TITLE)
            CELL.MENUS_L.text = DATA.ST_ETC
            
            NUKE(IV: CELL.PANGPANG_I, IU: DATA.PP_IMAGE, RD: 10, CM: .scaleAspectFill)
            CELL.PANGPANG_L.text = "\(DATA.PP_MENU) 무료쿠폰"
            CELL.REVIEW_TF.isHidden = true
            CELL.REVIEW_B.isHidden = true
            CELL.AFTERINFO_L.isHidden = false; CELL.AFTERINFO_L.text = "쿠폰 사용가능 기간 : 금일 23:59:59까지"
            CELL.SHARE_V.isHidden = false
            CELL.SHARE_B.tag = indexPath.item; CELL.SHARE_B.addTarget(self, action: #selector(SHARE_B(_:)), for: .touchUpInside)
        } else if POSITION == 1 {
            
            let DATA = OBJ_COUPON2[indexPath.item]
            
            CELL.DATETIME_L.text = FM_TIMESTAMP(Int(DATA.RECEIVE_TIME) ?? 0, "yy.MM.dd E. HH:mm:ss")
            CELL.QRCODE_B.isHidden = true
            if DATA.WRITE_REVIEW == "false" { CELL.CAFE_B.isHidden = false } else if DATA.WRITE_REVIEW == "true" { CELL.CAFE_B.isHidden = true }
            CELL.CAFE_B.addTarget(self, action: #selector(CAFE_B(_:)), for: .touchUpInside)
            
            if DATA.ST_IMAGE != "" {
                NUKE(IV: CELL.STORE_I, IU: DATA.ST_IMAGE, PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
            } else if DATA.ST_IMAGES.count > 0 {
                NUKE(IV: CELL.STORE_I, IU: DATA.ST_IMAGES[0], PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
            } else {
                CELL.STORE_I.image = UIImage()
            }
            CELL.QUOTE_LEFT_I.image = UIImage(named: quoteLeftImages[DATA.ST_COLOR] ?? "quote_left0")
            CELL.STORE_L.text = " \(DATA.ST_NAME) "
            CELL.QUOTE_RIGHT_I.image = UIImage(named: quoteRightImages[DATA.ST_COLOR] ?? "quote_right0")
            CELL.ADDRESS_L.text = DATA.ST_ADDRESS
            CELL.SUBJECT_L.text = DT_CHECK(DATA.ST_SUB_TITLE)
            CELL.MENUS_L.text = DATA.ST_ETC
            
            NUKE(IV: CELL.PANGPANG_I, IU: DATA.PP_IMAGE, RD: 10, CM: .scaleAspectFill)
            CELL.PANGPANG_L.text = "\(DATA.PP_MENU) 무료쿠폰"
            if DATA.WRITE_REVIEW == "false" {
                CELL.REVIEW_TF.isHidden = false; CELL.REVIEW_TF.placeholder("작성한 후기의 url를 넣어주세요.", COLOR: .lightGray); CELL.REVIEW_TF.addTarget(self, action: #selector(REVIEW_TF(_:)), for: .editingChanged)
                CELL.REVIEW_B.isHidden = false; CELL.REVIEW_B.tag = indexPath.item; CELL.REVIEW_B.addTarget(self, action: #selector(REVIEW_B(_:)), for: .touchUpInside)
                CELL.AFTERINFO_L.isHidden = true
            } else if DATA.WRITE_REVIEW == "true" {
                CELL.REVIEW_TF.isHidden = true
                CELL.REVIEW_B.isHidden = true
                CELL.AFTERINFO_L.isHidden = false; CELL.AFTERINFO_L.text = "후기 작성완료"
            }
            CELL.SHARE_V.isHidden = false
            CELL.SHARE_B.tag = indexPath.item; CELL.SHARE_B.addTarget(self, action: #selector(SHARE_B(_:)), for: .touchUpInside)
        }
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if POSITION == 0 {
            
            if OBJ_COUPON1[indexPath.item].PP_REMAIN > 0 {
                
                let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
                if (MEMBER_ID == "01031870005") || (MEMBER_ID == "01031853309") || (MEMBER_ID == "01090576393") || (MEMBER_ID == "01034231219") || (MEMBER_ID == "01090760335") || (MEMBER_ID == "01031262497") || (WRITE_REVIEW == "true") {
                    let VC = storyboard?.instantiateViewController(withIdentifier: "VC_LEGOPANGPANG") as! VC_LEGOPANGPANG
                    VC.modalPresentationStyle = .overCurrentContext; VC.transitioningDelegate = self
                    VC.DOWN_UP = true; VC.OBJ_COUPON = OBJ_COUPON1; VC.OBJ_POSITION = indexPath.item
                    present(VC, animated: true, completion: nil)
                } else {
                    S_NOTICE("후기 작성 미완료")
                }
            } else {
                S_NOTICE("쿠폰 사용 마감")
            }
        }
    }
    
    @objc func QRCODE_B(_ sender: UIButton) {
        
        if OBJ_COUPON1[sender.tag].PP_REMAIN > 0 {
            
            let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
            if (MEMBER_ID == "01031870005") || (MEMBER_ID == "01031853309") || (MEMBER_ID == "01090576393") || (MEMBER_ID == "01034231219") || (MEMBER_ID == "01090760335") || (MEMBER_ID == "01031262497") || (WRITE_REVIEW == "true") {
                let VC = storyboard?.instantiateViewController(withIdentifier: "VC_LEGOPANGPANG") as! VC_LEGOPANGPANG
                VC.modalPresentationStyle = .overCurrentContext; VC.transitioningDelegate = self
                VC.DOWN_UP = true; VC.OBJ_COUPON = OBJ_COUPON1; VC.OBJ_POSITION = sender.tag
                present(VC, animated: true, completion: nil)
            } else {
                S_NOTICE("후기 작성 미완료")
            }
        } else {
            S_NOTICE("쿠폰 사용 마감")
        }
    }
    
    @objc func CAFE_B(_ sender: UIButton) {
//        UIApplication.shared.open(URL(string: "https://m.cafe.naver.com/ca-fe/web/cafes/20237461/menus/90/articles/write")!, options: [:], completionHandler: nil)
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL3") as! VC_DETAIL3
        VC.TITLE = "후기 작성하기"; VC.LINK = "https://m.cafe.naver.com/ca-fe/web/cafes/20237461/menus/90/articles/write"
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func REVIEW_TF(_ sender: UITextField) {
        REVIEW = sender.text!
    }
    
    @objc func REVIEW_B(_ sender: UIButton) {
        
        if REVIEW == "" {
            S_NOTICE("후기 작성 (!)")
        } else {
            OBJ_POSITION = sender.tag; PUT_REVIEW(NAME: "후기작성", AC_TYPE: "review")
        }
    }
    
    @objc func SHARE_B(_ sender: UIButton) { UIImpactFeedbackGenerator().impactOccurred()
        
        var OBJ_COUPON: [API_COUPON] = []; if POSITION == 0 { OBJ_COUPON = OBJ_COUPON1 } else if POSITION == 1 { OBJ_COUPON = OBJ_COUPON2 }
        
        var TAG: String = ""
        var IMAGE: String = ""
        
        let DATA = OBJ_COUPON[sender.tag]
        
        for HASHTAG in DATA.ST_TAG { TAG.append("#\(HASHTAG) ") }
        if DATA.ST_IMAGE != "" { IMAGE = DATA.ST_IMAGE } else if DATA.ST_IMAGES.count > 0 { IMAGE = DATA.ST_IMAGES[0] }
        
        setShare(title: DATA.USE_STORE_NAME, description: TAG, imageUrl: IMAGE, params: "store_id=\(DATA.USE_STORE_ID)&type=store")
    }
}
