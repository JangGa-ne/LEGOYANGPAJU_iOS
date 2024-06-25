//
//  VC3_MAIN.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/11/25.
//

import UIKit
import ImageSlideshow

class StoreEditGridCell: UICollectionViewCell {
    
    @IBOutlet weak var hashtagLabel: UILabel!
}

class VC3_MAIN: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var POSITION: Int = 0
    
    @IBOutlet weak var NAVI_V: UIView!
    @IBOutlet weak var NAVI_L: UILabel!
    @IBAction func VC_SETTING_B(_ sender: UIButton) { segueViewController(identifier: "VC_SETTING") }
    @IBOutlet weak var LINE_V: UIView!
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    @IBOutlet weak var SLIDER_I: ImageSlideshow!
    @IBOutlet weak var POSITION_L: UILabel!
    
    @IBOutlet weak var QUOTE_COLOR_B: UIButton!
    @IBOutlet weak var QUOTE_LEFT_I: UIImageView!
    @IBOutlet weak var NAME_L: UILabel!
    @IBOutlet weak var QUOTE_RIGHT_I: UIImageView!
    @IBOutlet weak var gridBackgroundView: UIView!
    @IBOutlet weak var gridView: UICollectionView!
    @IBOutlet weak var SUBJECT_L: UILabel!
    @IBOutlet weak var CONTENTS_L: UILabel!
    @IBOutlet weak var TEL_L: UILabel!
    @IBOutlet weak var ADDRESS_L: UILabel!
    @IBOutlet weak var OPENTIME_L: UILabel!
    @IBOutlet weak var LASTORDER_L: UILabel!
    @IBOutlet weak var HOLIDAY_L: UILabel!
    @IBOutlet weak var MENU_L1: UILabel!
    @IBOutlet weak var MENU_L2: UILabel!
    @IBOutlet weak var MENU_L3: UILabel!
    @IBOutlet weak var MENU_L4: UILabel!
    
    @IBOutlet weak var VC3_STORE_EDIT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC3_MAIN_DEL = self
        UIViewController.StoreEditViewControllerDelegate = self
        
        NAVI_V.backgroundColor = .white.withAlphaComponent(0.0); NAVI_L.alpha = 0.0; LINE_V.alpha = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCROLLVIEW.delegate = self
        SLIDER_I.delegate = nil
        
        let DATA = UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row]
        
        IMAGESLIDER(IV: SLIDER_I, IU: DATA.imageArray, PH: UIImage(), RD: 0, CM: .scaleAspectFill)
        SLIDER_I.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(LONG_B(_:)))); SLIDER_I.delegate = self
        if DATA.imageArray.count > 0 { POSITION_L.text = "1 / \(DATA.imageArray.count)" }
        
        QUOTE_LEFT_I.image = UIImage(named: QUOTE_REFT[DATA.storeColor] ?? "quote_left0")
        NAME_L.text = " \(DATA.storeName) "
        QUOTE_RIGHT_I.image = UIImage(named: QUOTE_RIGHT[DATA.storeColor] ?? "quote_right0")
        
        if DATA.storeTag.count > 0 { gridBackgroundView.isHidden = false } else { gridBackgroundView.isHidden = true }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        gridView.setCollectionViewLayout(layout, animated: false, completion: nil)
        
        gridView.delegate = self; gridView.dataSource = self
        
        SUBJECT_L.text = DATA.storeSubTitle
        CONTENTS_L.text = DATA.storeEtc
        TEL_L.text = NUMBER("phone", DATA.storeTel)
        ADDRESS_L.text = DATA.storeAddress
        OPENTIME_L.text = DATA.storeTime
        LASTORDER_L.text = DATA.storeLastOrder
        HOLIDAY_L.text = DATA.storeRestday
        for (i, data) in DATA.storeMenu.enumerated() {
            if data.menuPrice.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567890").inverted) != nil {
                [MENU_L1, MENU_L2, MENU_L3, MENU_L4][i]?.text = "#\(data.menuName)(\(data.menuPrice)) "
            } else {
                [MENU_L1, MENU_L2, MENU_L3, MENU_L4][i]?.text = "#\(data.menuName)(\(NF.string(from: (Int(data.menuPrice) ?? 0) as NSNumber) ?? "0")원) "
            }
        }
        
        VC3_STORE_EDIT_B.addTarget(self, action: #selector(VC3_STORE_EDIT_B(_:)), for: .touchUpInside)
    }
    
    @objc func LONG_B(_ sender: UILongPressGestureRecognizer) { UIImpactFeedbackGenerator().impactOccurred()
        
        if UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].imageArray.count > 0 {
            let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            ALERT.addAction(UIAlertAction(title: "대표 이미지로 설정", style: .default, handler: { _ in
                self.PUT_IMAGE(NAME: "대표이미지", AC_TYPE: "store", TYPE: 0, POSITION: self.POSITION)
            }))
            ALERT.addAction(UIAlertAction(title: "첫번째 이미지로 설정", style: .default, handler: { _ in
                self.PUT_IMAGE(NAME: "첫번째이미지", AC_TYPE: "store", TYPE: 1, POSITION: self.POSITION)
            }))
            ALERT.addAction(UIAlertAction(title: "해당 이미지 삭제", style: .destructive, handler: { _ in
                self.PUT_IMAGE(NAME: "이미지삭제", AC_TYPE: "store", TYPE: 2, POSITION: self.POSITION)
            }))
            ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            present(ALERT, animated: true, completion: nil)
        } else {
            ALERT(TITLE: "", BODY: "먼저 \'내 사업장 수정\'에서 이미지를 등록해 주세요.", STYLE: .alert)
        }
    }
    
    @objc func VC3_STORE_EDIT_B(_ sender: UIButton) {
        segueViewController(identifier: "VC3_STORE_EDIT")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
    }
}

extension VC3_MAIN: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        POSITION_L.text = "\(page+1) / \(UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].imageArray.count)"; POSITION = page
    }
}

extension VC3_MAIN: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeTag.count > 0 { return UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeTag.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreEditGridCell_1", for: indexPath) as! StoreEditGridCell
        
        cell.hashtagLabel.text = "#\(data.storeTag[indexPath.row])"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: stringWidth(text: UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeTag[indexPath.row], fontSize: 12)+25, height: 25)
    }
}

extension VC3_MAIN: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        let SLIDER_H = SLIDER_I.frame.maxY-NAVI_V.frame.height
        if OFFSET_Y > SLIDER_H { NAVI_V.backgroundColor = .white.withAlphaComponent((OFFSET_Y-SLIDER_H)/50); NAVI_L.alpha = ((OFFSET_Y-SLIDER_H)/50); LINE_V.alpha = 0.05 } else { NAVI_V.backgroundColor = .white.withAlphaComponent(0.0); NAVI_L.alpha = 0.0; LINE_V.alpha = 0.0 }
    }
}

