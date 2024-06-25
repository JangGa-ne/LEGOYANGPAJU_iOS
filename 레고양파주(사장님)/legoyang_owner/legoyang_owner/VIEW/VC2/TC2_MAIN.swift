//
//  TC2_MAIN.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/11/25.
//

import UIKit

class CC2_MAIN: UICollectionViewCell {
    
    @IBOutlet weak var STORE_I: UIImageView!
}

class TC2_MAIN: UITableViewCell {
    
    var PROTOCOL: UIViewController?
    
    var OBJ_STORE: [API_USER] = []
    var OBJ_POSITION: Int = 0
    
    @IBOutlet weak var PROFILE_I: UIImageView!
    @IBOutlet weak var NAME_L1: UILabel!
    @IBOutlet weak var NAME_L2: UILabel!
    
    @IBOutlet weak var CATEGORY_I: UIImageView!
    @IBOutlet weak var CATEGORY_L: UILabel!
    
    @IBOutlet weak var PAY_L: UILabel!
    @IBOutlet weak var VC_LEPAY_B: UIButton!
    
    @IBOutlet weak var AMOUNT_L1: UILabel!
    @IBOutlet weak var AMOUNT_L2: UILabel!
    @IBOutlet weak var LEGOUP_B: UIButton!
    
    @IBOutlet weak var COUPON_I: UIImageView!
    
    @IBOutlet weak var NO_IMAGE_L: UILabel!
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    
    @IBOutlet weak var STORE_I: UIImageView!
    @IBOutlet weak var QUOTE_LEFT_I: UIImageView!
    @IBOutlet weak var STORE_L: UILabel!
    @IBOutlet weak var QUOTE_RIGHT_I: UIImageView!
    @IBOutlet weak var ADDRESS_L: UILabel!
    @IBOutlet weak var SUBJECT_L: UILabel!
    @IBOutlet weak var CONTENTS_L: UILabel!
    @IBOutlet weak var MENUS_V: UIView!
    @IBOutlet weak var MENUS_L: UILabel!
    
    func viewDidLoad() {
        
        COLLECTIONVIEW.delegate = nil; COLLECTIONVIEW.dataSource = nil
        
        if UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].imageArray.count > 0 {
            NO_IMAGE_L.isHidden = true; COLLECTIONVIEW.isHidden = false
        } else {
            NO_IMAGE_L.isHidden = false; COLLECTIONVIEW.isHidden = true
        }
        
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.scrollDirection = .horizontal; LAYOUT.minimumLineSpacing = 10; LAYOUT.minimumInteritemSpacing = 0
        LAYOUT.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        COLLECTIONVIEW.setCollectionViewLayout(LAYOUT, animated: true)
        
        COLLECTIONVIEW.delegate = self; COLLECTIONVIEW.dataSource = self
        COLLECTIONVIEW.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BACKGROUND_V(_:))))
    }
    
    @objc func BACKGROUND_V(_ sender: UITapGestureRecognizer) {
        
        let VC = PROTOCOL!.storyboard?.instantiateViewController(withIdentifier: "VC2_STORE") as! VC2_STORE
        VC.OBJ_STORE = OBJ_STORE; VC.OBJ_POSITION = OBJ_POSITION
        PROTOCOL!.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func VC_LEPAY_B(_ sender: UIButton) {
        
        let VC = PROTOCOL?.storyboard?.instantiateViewController(withIdentifier: "VC_LEPAY") as! VC_LEPAY
        VC.PAY = PAY_L.text!
        PROTOCOL?.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func LEGOUP_B(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: "", message: "레고UP 사용시 500원이\n레pay에서 차감됩니다.", preferredStyle: .alert)
        
        ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.PROTOCOL?.GET_LEGOUP(NAME: "레고UP", AC_TYPE: "store")
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        PROTOCOL?.present(ALERT, animated: true, completion: nil)
    }
}

extension TC2_MAIN: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UIViewController.appDelegate.StoreObject.count > 0 { return UIViewController.appDelegate.StoreObject[OBJ_POSITION].imageArray.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let DATA = UIViewController.appDelegate.StoreObject[OBJ_POSITION]
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC2_MAIN1", for: indexPath) as! CC2_MAIN
        
        PROTOCOL?.NUKE(IV: CELL.STORE_I, IU: DATA.imageArray[indexPath.item], PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
}
