//
//  VC_MAIN.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/13.
//

import UIKit
import ImageSlideshow
import Nuke

class CC_MAIN: UICollectionViewCell {
    
    @IBOutlet weak var BACKGROUND_V: UIView!
    @IBOutlet weak var COUNT_L: UILabel!
    @IBOutlet weak var ADS_I: UIImageView!
}

class TC_MAIN: UITableViewCell {
    
    var PROTOCOL: VC_MAIN!
    var POSITION: Int = 0
    
    @IBOutlet weak var TITLE_L: UILabel!
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    
    func viewDidLoad() {
        
        COLLECTIONVIEW.delegate = nil; COLLECTIONVIEW.dataSource = nil
        
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.scrollDirection = .horizontal; LAYOUT.minimumLineSpacing = 10; LAYOUT.minimumInteritemSpacing = 0
        LAYOUT.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        COLLECTIONVIEW.setCollectionViewLayout(LAYOUT, animated: false)
        
        COLLECTIONVIEW.delegate = self; COLLECTIONVIEW.dataSource = self
    }
}

extension TC_MAIN: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if POSITION == 0 {
            if UIViewController.appDelegate.OBJ_MAIN.RATE_21_9.count > 0 { return UIViewController.appDelegate.OBJ_MAIN.RATE_21_9.count } else { return 0 }
        } else if POSITION == 1 {
            if UIViewController.appDelegate.OBJ_MAIN.RATE_3_4.count > 0 { return UIViewController.appDelegate.OBJ_MAIN.RATE_3_4.count } else { return 0 }
        } else if POSITION == 2 {
            if UIViewController.appDelegate.OBJ_PANGPANG.count > 0 { return UIViewController.appDelegate.OBJ_PANGPANG.count } else { return 0 }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let DATA = UIViewController.appDelegate.OBJ_MAIN
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC_MAIN_1", for: indexPath) as! CC_MAIN
        CELL.roundShadows(color: .black, offset: CGSize(width: 0, height: 5), opcity: 0.1, radius1: 5, radius2: 10)
        
        CELL.BACKGROUND_V.isHidden = true
        
        if POSITION == 0 { collectionView.decelerationRate = .fast
            PROTOCOL.NUKE(IV: CELL.ADS_I, IU: DATA.RATE_21_9[indexPath.item].URL, PH: UIImage(), RD: 10, CM: .scaleAspectFill)
        } else if POSITION == 1 { collectionView.decelerationRate = .normal
            PROTOCOL.NUKE(IV: CELL.ADS_I, IU: DATA.RATE_3_4[indexPath.item].URL, PH: UIImage(), RD: 10, CM: .scaleAspectFill)
        } else if POSITION == 2 { collectionView.decelerationRate = .normal; CELL.ADS_I.image = UIImage(named: "logo2")
            let DATA = UIViewController.appDelegate.OBJ_PANGPANG[indexPath.item]
            if DATA.ST_IMAGE != "" {
                PROTOCOL.NUKE(IV: CELL.ADS_I, IU: DATA.ST_IMAGE, PH: UIImage(), RD: 10, CM: .scaleAspectFill)
            } else if DATA.ST_IMAGES.count > 0 {
                PROTOCOL.NUKE(IV: CELL.ADS_I, IU: DATA.ST_IMAGES[0], PH: UIImage(), RD: 10, CM: .scaleAspectFill)
            } else {
                CELL.ADS_I.image = UIImage(named: "logo2")
            }
            CELL.BACKGROUND_V.isHidden = false; CELL.COUNT_L.text = "\(DATA.PP_REMAIN)"
        }
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let DATA = UIViewController.appDelegate.OBJ_MAIN
        
        if POSITION == 0 {
            let VC = PROTOCOL.storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL3") as! VC_DETAIL3
            VC.LINK = DATA.RATE_21_9[indexPath.item].LINK_URL
            PROTOCOL.navigationController?.pushViewController(VC, animated: true)
        } else if POSITION == 1 {
            let VC = PROTOCOL.storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL3") as! VC_DETAIL3
            VC.LINK = DATA.RATE_3_4[indexPath.item].LINK_URL
            PROTOCOL.navigationController?.pushViewController(VC, animated: true)
        } else if POSITION == 2 {
            let VC = PROTOCOL.storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL1") as! VC_DETAIL1
            VC.STORE_ID = UIViewController.appDelegate.OBJ_PANGPANG[indexPath.item].ST_ID
            PROTOCOL.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if POSITION == 0 {
            return CGSize(width: collectionView.frame.width-40, height: (collectionView.frame.width-40)*9/21)
        } else if POSITION == 1 {
            return CGSize(width: 120, height: 160)
        } else if POSITION == 2 {
            return CGSize(width: 120, height: 120)
        } else {
            return collectionView.frame.size
        }
    }
}

extension TC_MAIN: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView == COLLECTIONVIEW && POSITION == 0 {
        
            let SPACING = COLLECTIONVIEW.frame.width-40 + 10
            let INDEX = scrollView.contentOffset.x / SPACING
            var IDX: CGFloat = 0.0
            
            if velocity.x > 0 { IDX = ceil(INDEX) } else if velocity.x < 0 { IDX = floor(INDEX) } else { IDX = round(INDEX) }
            
            targetContentOffset.pointee = CGPoint(x: IDX * SPACING, y: 0)
        } else {
            targetContentOffset.pointee = targetContentOffset.pointee
        }
    }
}

class VC_MAIN: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var PAGE: Int = 0
    
    @IBOutlet weak var HEADER_V: UIView!
    @IBOutlet weak var NOTICE_V: UIView!
    @IBOutlet weak var NOTICE_B: UIButton!
    @IBOutlet weak var USER_I: UIImageView!
    @IBOutlet weak var USER_B: UIButton!
    @IBOutlet weak var SEARCH_TF: UITextField!
    @IBOutlet weak var SEARCH_B: UIButton!
    @IBOutlet weak var LINE_V: UIView!
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    @IBOutlet weak var SCROLL_H: UIView!
    
    @IBOutlet weak var SLIDER_I: ImageSlideshow!
    @IBOutlet weak var SLIDER_H: NSLayoutConstraint!
    @IBOutlet weak var PLAY_I: UIImageView!
    @IBOutlet weak var PAGE_L: UILabel!
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    @IBOutlet weak var TABLEVIEW_H: NSLayoutConstraint!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_MAIN_DEL = self
        
        setKeyboard()
        
//        HEADER_V.backgroundColor = .H_00529C.withAlphaComponent(0.0); LINE_V.alpha = 0.0
        NOTICE_V.isHidden = true
        SEARCH_TF.paddingLeft(20); SEARCH_TF.paddingRight(20)
        SEARCH_TF.placeholder("풀빌라? 야식? 카페?", COLOR: .white)
        
        if #available(iOS 13.0, *) { SLIDER_I.activityIndicator = DefaultActivityIndicator(style: .large, color: .black.withAlphaComponent(0.5)) }
//        SLIDER_H.constant = UIApplication.shared.statusBarFrame.height
        PLAY_I.alpha = 0.0
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        
        loadView2()
    }
    
    func loadView2() {
        
        let DATA = UIViewController.appDelegate.OBJ_MAIN
            
        if DATA.MAIN_CONTENTS.count > 0 {

            var IMAGES: [String] = []
            for IMAGE in DATA.MAIN_CONTENTS { IMAGES.append(IMAGE.URL); if DATA.MAIN_CONTENTS[0].TYPE == "y" { PLAY_I.alpha = 1.0 } else { PLAY_I.alpha = 0.0 } }
            
            IMAGESLIDER(IV: SLIDER_I, IU: IMAGES, PH: UIImage(), RD: 0, CM: .scaleAspectFill)
            SLIDER_I.slideshowInterval = 10
            PAGE_L.text = "1 / \(DATA.MAIN_CONTENTS.count)"
        } else {
            PAGE_L.text = "-"
        }
        
        let RATE_1 = Int(((UIScreen.main.bounds.width-40)*9/21)+50)
        let RATE_2 = 160+50
        let RATE_3 = 120+50
        TABLEVIEW_H.constant = CGFloat(RATE_1+RATE_2+RATE_3-20)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NOTICE_B.tag = 0; NOTICE_B.addTarget(self, action: #selector(HEADER_B(_:)), for: .touchUpInside)
        USER_B.tag = 1; USER_B.addTarget(self, action: #selector(HEADER_B(_:)), for: .touchUpInside)
        SEARCH_B.tag = 2; SEARCH_B.addTarget(self, action: #selector(HEADER_B(_:)), for: .touchUpInside)
        
        SCROLLVIEW.delegate = self
        
        SLIDER_I.delegate = self
        SLIDER_I.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SLIDER_I(_:))))
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
    
    @objc func HEADER_B(_ sender: UIButton) {
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        let data = UIViewController.appDelegate.MemberObject
        
        if sender.tag == 0 {
            segueViewController(identifier: "VC_NOTICE", animated: true)
        } else if sender.tag == 1 {
            if (MEMBER_ID != "") && (MEMBER_ID == data.number) { segueViewController(identifier: "SettingViewController") } else { segueViewController(identifier: "LoginAAViewController") }
        } else if sender.tag == 2 {
            segueViewController(identifier: "VC_SEARCH", animated: false)
        }
    }
    
    @objc func SLIDER_I(_ sender: UITapGestureRecognizer) {
        
        let DATA = UIViewController.appDelegate.OBJ_MAIN.MAIN_CONTENTS[PAGE]
        
        if DATA.TYPE == "p" {
            let VC = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL3") as! VC_DETAIL3
            VC.LINK = DATA.LINK_URL
            navigationController?.pushViewController(VC, animated: true)
        } else if DATA.TYPE == "y" {
            if let URL = URL(string: DATA.LINK_URL) { UIApplication.shared.open(URL, options: [:]) }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}

extension VC_MAIN: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        
        let DATA = UIViewController.appDelegate.OBJ_MAIN
        
        if DATA.MAIN_CONTENTS.count > 0 {
            UIView.animate(withDuration: 0) { if DATA.MAIN_CONTENTS[page].TYPE == "y" { self.PLAY_I.alpha = 1.0 } else { self.PLAY_I.alpha = 0.0 } }
            PAGE = page; PAGE_L.text = "\(page+1) / \(DATA.MAIN_CONTENTS.count)"
        } else {
            self.PAGE_L.text = "-"
        }
    }
}

extension VC_MAIN: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_MAIN_1", for: indexPath) as! TC_MAIN
        CELL.PROTOCOL = self; CELL.POSITION = indexPath.item; CELL.viewDidLoad()
        
        CELL.TITLE_L.text = DT_CHECK(UIViewController.appDelegate.OBJ_MAIN.RATE_TITLE[indexPath.item])
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return ((UIScreen.main.bounds.width-40)*9/21)+50
        } else if indexPath.item == 1 {
            return 160+50
        } else if indexPath.item == 2 {
            return 120+50
        } else {
            return UITableView.automaticDimension
        }
    }
}

//extension VC_MAIN: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let OFFSET_Y = scrollView.contentOffset.y
//        let SLIDER_H = SLIDER_I.frame.maxY-HEADER_V.frame.height
//        if OFFSET_Y > SLIDER_H { HEADER_V.backgroundColor = .H_00529C.withAlphaComponent((OFFSET_Y-SLIDER_H)/50); LINE_V.alpha = 0.05 } else { HEADER_V.backgroundColor = .H_00529C.withAlphaComponent(0.0); LINE_V.alpha = 0.0 }
//    }
//}
