//
//  VC_DETAIL1.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/19.
//

import UIKit
import ImageSlideshow
import MapKit
import FirebaseFirestore

class CC_DETAIL1: UICollectionViewCell {
    
    @IBOutlet weak var HASHTAG_L: UILabel!
}

// 스토어
class VC_DETAIL1: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var STORE_ID: String = ""
    
    var OBJ_STORE: [API_STORE] = []
    var OBJ_POSITION: Int = 0
    
    var MEMBER: [String] = []
    var STORE: Int = 0
    
    @IBOutlet weak var HEADER_V: UIView!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var LINE_V: UIView!
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    
    @IBOutlet weak var SLIDER_I: ImageSlideshow!
    @IBOutlet weak var SLIDER_H: NSLayoutConstraint!
    @IBOutlet weak var PAGE_L: UILabel!
    
    @IBOutlet weak var LIKE_I: UIImageView!
    @IBOutlet weak var LIKE_L: UILabel!
    @IBOutlet weak var LIKE_B: UIButton!
    
    @IBOutlet weak var COUPON_V: UIView!
    @IBOutlet weak var COUPON_L: UILabel!
    @IBOutlet weak var COUPON_B: UIButton!
    
    @IBOutlet weak var QUOTE_LEFT_I: UIImageView!
    @IBOutlet weak var STORE_L: UILabel!
    @IBOutlet weak var QUOTE_RIGHT_I: UIImageView!
    @IBOutlet weak var CATEGORY_L: UILabel!
    @IBOutlet weak var SHARE_B: UIButton!
    @IBOutlet weak var SUBJECT_L: UILabel!
    @IBOutlet weak var CONTENTS_L: UILabel!
    
    @IBOutlet weak var HASHTAG_V: UIView!
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    
    @IBOutlet weak var ADDRESS_L: UILabel!
    @IBOutlet weak var ADDRESS_B: UIButton!
    @IBOutlet weak var OPENTIME_L: UILabel!
    
    @IBOutlet weak var MENUS_V: UIView!
    @IBOutlet weak var MENUS_L: UILabel!
    
    @IBOutlet weak var STORE_L1: UILabel!
    @IBOutlet weak var STORE_L2: UILabel!
    @IBOutlet weak var STORE_L3: UILabel!
    @IBOutlet weak var STORE_L4: UILabel!
    @IBOutlet weak var STORE_L5: UILabel!
    @IBOutlet weak var STORE_SV6: UIStackView!
    @IBOutlet weak var STORE_L6: UILabel!
    @IBOutlet weak var STORE_B6: UIButton!
    @IBOutlet weak var STORE_SV7: UIStackView!
    @IBOutlet weak var STORE_L7: UILabel!
    
    @IBOutlet weak var MKMAPVIEW: MKMapView!
    @IBOutlet weak var DIRECTION_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_DETAIL1_DEL = self
        
        HEADER_V.backgroundColor = .white.withAlphaComponent(0.0); LINE_V.alpha = 0.0
        
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.scrollDirection = .horizontal; LAYOUT.minimumLineSpacing = 0; LAYOUT.minimumInteritemSpacing = 10
        LAYOUT.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        COLLECTIONVIEW.setCollectionViewLayout(LAYOUT, animated: false, completion: nil)
        
        MKMAPVIEW.showsScale = true; MKMAPVIEW.isRotateEnabled = true
        if #available(iOS 13.0, *) { MKMAPVIEW.overrideUserInterfaceStyle = .light }
        
        if STORE_ID != "" { GET_STORE(NAME: "디테일 가게정보", AC_TYPE: "store") } else { loadView2() }
    }
    
    func loadView2() {
        
        if OBJ_STORE.count > 0 {
            
            let DATA = OBJ_STORE[OBJ_POSITION]
            
            STORE_ID = DATA.ST_ID; MEMBER = UIViewController.appDelegate.OBJ_USER.MYLIKE_STORE; STORE = DATA.LIKE_COUNT
            
            IMAGESLIDER(IV: SLIDER_I, IU: DATA.ST_IMAGES, PH: UIImage(), RD: 0, CM: .scaleAspectFill)
            SLIDER_H.constant = UIApplication.shared.statusBarFrame.height
            if DATA.ST_IMAGES.count > 0 { PAGE_L.text = "1 / \(DATA.ST_IMAGES.count)" } else { PAGE_L.text = "-" }
            
            if UIViewController.appDelegate.OBJ_USER.MYLIKE_STORE.contains(STORE_ID) || UIViewController.appDelegate.OBJ_USER.MYLIKE_STORE.contains(DATA.ST_ID) {
                LIKE_B.isSelected = true; LIKE_I.image = UIImage(named: "like_on")
            } else {
                LIKE_B.isSelected = false; LIKE_I.image = UIImage(named: "like_off")
            }
            if DATA.USE_PANGPANG == "true" { COUPON_V.isHidden = false; COUPON_L.text = DT_CHECK("\(DATA.PP_REMAIN)") } else { COUPON_V.isHidden = true }
            
            QUOTE_LEFT_I.image = UIImage(named: quoteLeftImages[DATA.ST_COLOR] ?? "quote_left0")
            STORE_L.text = " \(DATA.ST_NAME) "
            QUOTE_RIGHT_I.image = UIImage(named: quoteRightImages[DATA.ST_COLOR] ?? "quote_right0")
            CATEGORY_L.text = DATA.ST_CATEGORY
            SUBJECT_L.text = DT_CHECK(DATA.ST_SUB_TITLE)
            CONTENTS_L.text = DT_CHECK(DATA.ST_ETC)
            ADDRESS_L.text = "주소: \(DT_CHECK(DATA.ST_ADDRESS))"
            OPENTIME_L.text = "영업시간: \(DT_CHECK(DATA.ST_TIME))"
            
            var MENUS: String = ""
            for i in 0 ..< DATA.ST_MENU.count { MENUS.append("#\(DATA.ST_MENU[i].MENU_NAME)(\(NF.string(from: (Int(DATA.ST_MENU[i].MENU_PRICE) ?? 0) as NSNumber) ?? "0")원) ") }
            if MENUS == "" { MENUS_V.isHidden = true } else { MENUS_V.isHidden = false; MENUS_L.text = MENUS }
            
            STORE_L1.text = DT_CHECK(DATA.ON_NAME)
            STORE_L2.text = DT_CHECK(DATA.ST_NAME)
            STORE_L3.text = DT_CHECK(DATA.ST_ADDRESS)
            STORE_L4.text = setHyphen("phone", DATA.ST_TEL)
            STORE_L5.text = setHyphen("company", DATA.ST_REGNUM)
            
            let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
            if (MEMBER_ID == "01031870005") || (MEMBER_ID == "01031853309") {
                STORE_SV6.isHidden = false; STORE_L6.text = DT_CHECK(DATA.ST_ID)
                STORE_SV7.isHidden = false; STORE_L7.text = DT_CHECK(DATA.ST_TAX_EMAIL)
            } else {
                STORE_SV6.isHidden = true
                STORE_SV7.isHidden = true
            }
            
            MKMAPVIEW.removeAnnotations(MKMAPVIEW.annotations)
            
            if (DATA.LAT != "") && (DATA.LON != "") && (DATA.LAT != "0.0") && (DATA.LON != "0.0") {
                
                let ANNOTATION = MKPointAnnotation()
                ANNOTATION.title = DATA.ST_NAME
                ANNOTATION.subtitle = DATA.ST_ADDRESS
                ANNOTATION.coordinate = CLLocationCoordinate2D(latitude: Double(DATA.LAT) ?? 0.0, longitude: Double(DATA.LON) ?? 0.0)
                MKMAPVIEW.addAnnotation(ANNOTATION)
                
                let COORDINATE = CLLocationCoordinate2D(latitude: Double(DATA.LAT) ?? 0.0, longitude: Double(DATA.LON) ?? 0.0)
                let SPAN = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                let REGION = MKCoordinateRegion(center: COORDINATE, span: SPAN)
                MKMAPVIEW.setRegion(REGION, animated: false)
            }
            
            
            Firestore.firestore().collection("store").document(DATA.ST_ID).setData(["view_count": DATA.VIEW_COUNT+1], merge: true)
        } else {
            
            S_NOTICE("데이터 없음"); navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCROLLVIEW.delegate = self
        
        SLIDER_I.delegate = self
        
        LIKE_B.addTarget(self, action: #selector(LIKE_B(_:)), for: .touchUpInside)
        COUPON_B.addTarget(self, action: #selector(COUPON_B(_:)), for: .touchUpInside)
        
        SHARE_B.addTarget(self, action: #selector(SHARE_B(_:)), for: .touchUpInside)
        
        COLLECTIONVIEW.delegate = self; COLLECTIONVIEW.dataSource = self
        
        ADDRESS_B.addTarget(self, action: #selector(ADDRESS_B(_:)), for: .touchUpInside)
        STORE_B6.addTarget(self, action: #selector(STORE_B6(_:)), for: .touchUpInside)
        
        DIRECTION_B.addTarget(self, action: #selector(DIRECTION_B(_:)), for: .touchUpInside)
    }
    
    @objc func LIKE_B(_ sender: UIButton) { UIImpactFeedbackGenerator().impactOccurred()
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        if (MEMBER_ID != "") && (MEMBER_ID == UIViewController.appDelegate.OBJ_USER.NUMBER) {
            if OBJ_STORE.count > 0 {
                if !sender.isSelected { sender.isSelected = true
                    LIKE_I.image = UIImage(named: "like_on")
                } else { sender.isSelected = false
                    LIKE_I.image = UIImage(named: "like_off")
                }; SET_LIKE(NAME: "찜", AC_TYPE: "like", SELECT: sender.isSelected)
            } else {
                S_NOTICE("오류 (!)")
            }
        } else {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        }
    }
    
    @objc func COUPON_B(_ sender: UIButton) {
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        if (MEMBER_ID != "") && (MEMBER_ID == UIViewController.appDelegate.OBJ_USER.NUMBER) {
            if OBJ_STORE[OBJ_POSITION].PP_REMAIN > 0 { GET_COUPON(NAME: "레고팡팡 발급", AC_TYPE: "") } else { S_NOTICE("발행 가능한 쿠폰 없음") }
        } else {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        }
    }
    
    @objc func SHARE_B(_ sender: UIButton) { UIImpactFeedbackGenerator().impactOccurred()
        
        if OBJ_STORE.count > 0 {
            
            let DATA = OBJ_STORE[OBJ_POSITION]
            
            var TAG: String = ""
            var IMAGE: String = ""
            
            for HASHTAG in DATA.ST_TAG { TAG.append("#\(HASHTAG) ") }
            if DATA.ST_IMAGE != "" { IMAGE = DATA.ST_IMAGE } else if DATA.ST_IMAGES.count > 0 { IMAGE = DATA.ST_IMAGES[0] }
            
            setShare(title: DATA.ST_NAME, description: TAG, imageUrl: IMAGE, params: "store_id=\(DATA.ST_ID)&type=store")
        } else {
            S_NOTICE("오류 (!)")
        }
    }
    
    @objc func ADDRESS_B(_ sender: UIButton) {
        S_NOTICE("클립보드에 복사됨"); UIPasteboard.general.string = OBJ_STORE[OBJ_POSITION].ST_ADDRESS
    }
    
    @objc func STORE_B6(_ sender: UIButton) {
        S_NOTICE("클립보드에 복사됨"); UIPasteboard.general.string = OBJ_STORE[OBJ_POSITION].ST_ID
    }
    
    @objc func DIRECTION_B(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ALERT.addAction(UIAlertAction(title: "\'네이버 지도\'(으)로 길찾기", style: .default, handler: { _ in
            if let APP = URL(string: "nmap://search?query=\(self.OBJ_STORE[self.OBJ_POSITION].ST_ADDRESS)&appname=A1.blink.legoyang-client".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!) {
                UIApplication.shared.open(APP, options: [:]) { success in
                    if !success {
                        if let STORE = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") {
                            UIApplication.shared.open(STORE, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }))
        ALERT.addAction(UIAlertAction(title: "\'카카오 맵\'(으)로 길찾기", style: .default, handler: { _ in
            if let APP = URL(string: "kakaomap://search?q=\(self.OBJ_STORE[self.OBJ_POSITION].ST_ADDRESS)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!) {
                UIApplication.shared.open(APP, options: [:]) { success in
                    if !success {
                        if let STORE = URL(string: "http://itunes.apple.com/app/id304608425?mt=8") {
                            UIApplication.shared.open(STORE, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(ALERT, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension VC_DETAIL1: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        if OBJ_STORE.count > 0 { if OBJ_STORE[OBJ_POSITION].ST_IMAGES.count > 0 { PAGE_L.text = "\(page+1) / \(OBJ_STORE[OBJ_POSITION].ST_IMAGES.count)" } else { PAGE_L.text = "-" } }
    }
}

extension VC_DETAIL1: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if OBJ_STORE.count > 0 {
            if OBJ_STORE[OBJ_POSITION].ST_TAG.count > 0 { HASHTAG_V.isHidden = false; return OBJ_STORE[OBJ_POSITION].ST_TAG.count } else { HASHTAG_V.isHidden = true; return 0 }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC_DETAIL1_1", for: indexPath) as! CC_DETAIL1
        
        if OBJ_STORE[OBJ_POSITION].ST_TAG[indexPath.item] == "" {
            CELL.HASHTAG_L.text = ""
        } else {
            CELL.HASHTAG_L.text = "#\(OBJ_STORE[OBJ_POSITION].ST_TAG[indexPath.item])"
        }
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: STRING_WIDTH(TEXT: "#\(OBJ_STORE[OBJ_POSITION].ST_TAG[indexPath.item])", FONT_SIZE: 12)+20, height: 20)
    }
}

extension VC_DETAIL1: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        let SLIDER_H = SLIDER_I.frame.maxY-HEADER_V.frame.height
        if OFFSET_Y > SLIDER_H { HEADER_V.backgroundColor = .white.withAlphaComponent((OFFSET_Y-SLIDER_H)/50); LINE_V.alpha = 0.05 } else { HEADER_V.backgroundColor = .white.withAlphaComponent(0.0); LINE_V.alpha = 0.0 }
    }
}
