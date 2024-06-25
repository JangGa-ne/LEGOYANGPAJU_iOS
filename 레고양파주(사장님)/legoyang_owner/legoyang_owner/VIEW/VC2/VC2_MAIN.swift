//
//  VC2_MAIN.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/11/25.
//

import UIKit
import Nuke

class VC2_MAIN: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var NAVI_V: UIView!
    @IBOutlet weak var NAVI_L: UILabel!
    @IBAction func VC_SETTING_B(_ sender: UIButton) { segueViewController(identifier: "VC_SETTING") }
    @IBOutlet weak var LINE_V: UIView!
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC2_MAIN_DEL = self
        UIViewController.StoreViewControllerDelegate = self
        
//        NAVI_V.backgroundColor = .white.withAlphaComponent(0.0); NAVI_L.alpha = 0.0; LINE_V.alpha = 0.0
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
        
        refreshControl.backgroundColor = .clear; refreshControl.tintColor = .H_00529C
        refreshControl.addTarget(self, action: #selector(refreshControl(_:)), for: .valueChanged)
        TABLEVIEW.refreshControl = refreshControl
    }
    
    @objc func refreshControl(_ sender: UIRefreshControl) {
        
        if let refresh = UIViewController.LoadingViewControllerDelegate {
            refresh.loadingData2(update: true, storeCategory: UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeCategory)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
    }
}

extension VC2_MAIN: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if UIViewController.appDelegate.StoreObject.count > 0 { return 1 } else { return 0 }
        } else if section == 1 {
            if UIViewController.appDelegate.StoreObject.count > 0 { return UIViewController.appDelegate.StoreObject.count } else { S_NOTICE("데이터 없음"); return 0 }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let DATA = UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC2_MAIN1", for: indexPath) as! TC2_MAIN
            CELL.PROTOCOL = self; CELL.OBJ_STORE = UIViewController.AD.OBJ_USER; CELL.OBJ_POSITION = indexPath.item
            
            if DATA.storeImage != "" {
                NUKE(IV: CELL.PROFILE_I, IU: DATA.storeImage, PH: UIImage(), RD: 30, CM: .scaleAspectFill)
            } else if DATA.imageArray.count > 0 {
                NUKE(IV: CELL.PROFILE_I, IU: DATA.imageArray[0], PH: UIImage(), RD: 30, CM: .scaleAspectFill)
            } else {
                CELL.PROFILE_I.image = UIImage(named: "logo2")
            }
            CELL.NAME_L1.text = "\(DATA.ownerName) 사장님"
            CELL.NAME_L2.text = DATA.storeName
            CELL.CATEGORY_I.image = UIImage(named: CATEGORY_IMAGES[DATA.storeCategory] ?? "")
            CELL.CATEGORY_L.text = DATA.storeCategory
            
            CELL.PAY_L.text = "\((NF.string(from: (Int(DATA.storeCash) ?? 0) as NSNumber) ?? ""))원"
            CELL.VC_LEPAY_B.addTarget(CELL, action: #selector(CELL.VC_LEPAY_B(_:)), for: .touchUpInside)
            
            CELL.AMOUNT_L1.text = "현재 \(DATA.storeName)의 순위는?"
            CELL.AMOUNT_L2.text = "\(DATA.storeCategory) \(UIViewController.appDelegate.row+1)위"
            CELL.LEGOUP_B.addTarget(CELL, action: #selector(CELL.LEGOUP_B(_:)), for: .touchUpInside)
            
            return CELL
        } else if indexPath.section == 1 {
            
            let DATA = UIViewController.appDelegate.StoreObject[indexPath.item]
            
            if indexPath.item == 0 {
                
                let CELL = tableView.dequeueReusableCell(withIdentifier: "TC2_MAIN2", for: indexPath) as! TC2_MAIN
                CELL.PROTOCOL = self; CELL.OBJ_STORE = UIViewController.AD.OBJ_STORE; CELL.OBJ_POSITION = indexPath.item; CELL.viewDidLoad()
                
                if DATA.usePangpang == "true" { CELL.COUPON_I.isHidden = false } else { CELL.COUPON_I.isHidden = true }
                
                CELL.QUOTE_LEFT_I.image = UIImage(named: QUOTE_REFT[DATA.storeColor] ?? "quote_left0")
                CELL.STORE_L.text = " \(DATA.storeName) "
                CELL.QUOTE_RIGHT_I.image = UIImage(named: QUOTE_RIGHT[DATA.storeColor] ?? "quote_right0")
                CELL.CATEGORY_L.text = DATA.storeCategory
                CELL.SUBJECT_L.text = DATA.storeSubTitle
                CELL.CONTENTS_L.text = DATA.storeEtc
                var menu: String = ""
                for data in DATA.storeMenu {
                    if data.menuPrice.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567890").inverted) != nil {
                        menu.append("#\(data.menuName)(\(data.menuPrice)) ")
                    } else {
                        menu.append("#\(data.menuName)(\(NF.string(from: (Int(data.menuPrice) ?? 0) as NSNumber) ?? "0")원) ")
                    }
                }; if DATA.storeMenu.count > 0 { CELL.MENUS_V.isHidden = false; CELL.MENUS_L.text = menu } else { CELL.MENUS_V.isHidden = true }
                
                return CELL
            } else {
                
                let CELL = tableView.dequeueReusableCell(withIdentifier: "TC2_MAIN3", for: indexPath) as! TC2_MAIN
                CELL.PROTOCOL = self; CELL.OBJ_STORE = UIViewController.AD.OBJ_STORE; CELL.OBJ_POSITION = indexPath.item
                
                if DATA.storeImage != "" {
                    NUKE(IV: CELL.STORE_I, IU: DATA.storeImage, PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
                } else if DATA.imageArray.count > 0 {
                    NUKE(IV: CELL.STORE_I, IU: DATA.imageArray[0], PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
                } else {
                    CELL.STORE_I.image = UIImage(named: "logo3")
                }
                CELL.QUOTE_LEFT_I.image = UIImage(named: QUOTE_REFT[DATA.storeColor] ?? "quote_left0")
                CELL.STORE_L.text = " \(DATA.storeName) "
                CELL.QUOTE_RIGHT_I.image = UIImage(named: QUOTE_RIGHT[DATA.storeColor] ?? "quote_right0")
                CELL.ADDRESS_L.text = DATA.storeAddress
                CELL.SUBJECT_L.text = DATA.storeSubTitle
                CELL.MENUS_L.text = DATA.storeEtc
                
                return CELL
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let VC = storyboard?.instantiateViewController(withIdentifier: "VC2_STORE") as! VC2_STORE
            VC.OBJ_STORE = UIViewController.AD.OBJ_STORE; VC.OBJ_POSITION = indexPath.item
            navigationController?.pushViewController(VC, animated: true)
        }
    }
}

//extension VC2_MAIN: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let OFFSET_Y = scrollView.contentOffset.y
//        if OFFSET_Y > 0 { NAVI_V.backgroundColor = .white.withAlphaComponent((OFFSET_Y+50)/50); NAVI_L.alpha = (OFFSET_Y+50)/50; LINE_V.alpha = 0.05 } else { NAVI_V.backgroundColor = .white.withAlphaComponent(0.0); NAVI_L.alpha = 0.0; LINE_V.alpha = 0.0 }
//    }
//}
