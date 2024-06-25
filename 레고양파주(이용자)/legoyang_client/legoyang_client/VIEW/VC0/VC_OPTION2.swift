//
//  VC_OPTION2.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/02/08.
//

import UIKit

class CC_OPTION2: UICollectionViewCell {
    
    @IBOutlet weak var STORE_I: UIImageView!
}

class VC_OPTION2: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var OBJ_STORE: [StoreData] = []
    var OBJ_POSITION: Int = 0
    
    @IBAction func BACK_B(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var BACKGROUND_V: UIView!
    
    @IBOutlet weak var QUOTE_LEFT_I: UIImageView!
    @IBOutlet weak var STORE_L: UILabel!
    @IBOutlet weak var QUOTE_RIGHT_I: UIImageView!
    @IBOutlet weak var CATEGORY_L: UILabel!
    @IBOutlet weak var COUPON_SV: UIStackView!
    @IBOutlet weak var COUPON_L: UILabel!
    @IBOutlet weak var SUBJECT_L: UILabel!
    
    @IBOutlet weak var NO_IMAGE_L: UILabel!
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    
    @IBOutlet weak var CONTENTS_L: UILabel!
    @IBOutlet weak var ADDRESS_L: UILabel!
    @IBOutlet weak var ADDRESS_B: UIButton!
    @IBOutlet weak var OPENTIME_L: UILabel!
    @IBOutlet weak var MENUS_V: UIView!
    @IBOutlet weak var MENUS_L: UILabel!
    
    override func loadView() {
        super.loadView()
        
        let DATA = OBJ_STORE[OBJ_POSITION]
        
        QUOTE_LEFT_I.image = UIImage(named: quoteLeftImages[DATA.storeColor] ?? "quote_left0")
        STORE_L.text = " \(DATA.storeName) "
        QUOTE_RIGHT_I.image = UIImage(named: quoteRightImages[DATA.storeColor] ?? "quote_right0")
        CATEGORY_L.text = DATA.storeCategory
        if DATA.usePangpang == "true" { COUPON_SV.isHidden = false; COUPON_L.text = DT_CHECK("\(DATA.pangpangRemain)") } else { COUPON_SV.isHidden = true }
        SUBJECT_L.text = DT_CHECK(DATA.storeSubTitle)
        CONTENTS_L.text = DT_CHECK(DATA.storeEtc)
        ADDRESS_L.text = "주소: \(DATA.storeAddress)"
        OPENTIME_L.text = "영업시간: \(DATA.storeTime)"
        
        var MENUS: String = ""
        for i in 0 ..< DATA.storeMenu.count {
            MENUS.append("#\(DATA.storeMenu[i].menuName)(\(NF.string(from: (Int(DATA.storeMenu[i].menuPrice) ?? 0) as NSNumber) ?? "0")원) ")
        }
        if MENUS == "" { MENUS_V.isHidden = true } else { MENUS_V.isHidden = false; MENUS_L.text = MENUS }
        
        if OBJ_STORE[OBJ_POSITION].imageArray.count > 0 {
            NO_IMAGE_L.isHidden = true; COLLECTIONVIEW.isHidden = false
        } else {
            NO_IMAGE_L.isHidden = false; COLLECTIONVIEW.isHidden = true
        }
        
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.scrollDirection = .horizontal; LAYOUT.minimumLineSpacing = 10; LAYOUT.minimumInteritemSpacing = 0
        LAYOUT.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        COLLECTIONVIEW.setCollectionViewLayout(LAYOUT, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BACKGROUND_V.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BACKGROUND_V(_:))))
        
        COLLECTIONVIEW.delegate = self; COLLECTIONVIEW.dataSource = self; COLLECTIONVIEW.reloadData()
        COLLECTIONVIEW.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BACKGROUND_V(_:))))
        
        ADDRESS_B.addTarget(self, action: #selector(ADDRESS_B(_:)), for: .touchUpInside)
    }
    
    @objc func BACKGROUND_V(_ sender: UITapGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
        
        if let RVC = UIViewController.VC_MAP2_DEL {
            let segue = RVC.storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
            segue.StoreObject = OBJ_STORE; segue.row = OBJ_POSITION
            RVC.navigationController?.pushViewController(segue, animated: true)
        }
    }
    
    @objc func ADDRESS_B(_ sender: UIButton) {
        S_NOTICE("클립보드에 복사됨"); UIPasteboard.general.string = OBJ_STORE[OBJ_POSITION].storeAddress
    }
}

extension VC_OPTION2: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if OBJ_STORE.count > 0 { return OBJ_STORE[OBJ_POSITION].imageArray.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let DATA = OBJ_STORE[OBJ_POSITION]
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC_OPTION2_1", for: indexPath) as! CC_OPTION2
        
        NUKE(IV: CELL.STORE_I, IU: DATA.imageArray[indexPath.item], RD: 10, CM: .scaleAspectFill)
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
