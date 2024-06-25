//
//  VC0_MAIN.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/28.
//

import UIKit

class VC0_MAIN: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBOutlet weak var NAVI_V: UIView!
    @IBOutlet weak var NAVI_L: UILabel!
    @IBAction func VC_SETTING_B(_ sender: UIButton) { segueViewController(identifier: "VC_SETTING") }
    @IBOutlet weak var LINE_V: UIView!
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC0_MAIN_DEL = self
        UIViewController.MarketViewControllerDelegate = self
        
//        NAVI_V.backgroundColor = .white.withAlphaComponent(0.0); NAVI_L.alpha = 0.0; LINE_V.alpha = 0.0
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
    }
}

extension VC0_MAIN: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row]
        
        if indexPath.section == 0 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC0_MAIN1", for: indexPath) as! TC0_MAIN
            CELL.PROTOCOL = self; CELL.OBJ_POSITION = indexPath.item
            
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
            CELL.VISIT_L.text = "\(DATA.viewCount)회"
            
            CELL.PAY_L.text = "\((NF.string(from: (Int(DATA.storeCash) ?? 0) as NSNumber) ?? ""))원"
            CELL.VC_LEPAY_B.addTarget(CELL, action: #selector(CELL.VC_LEPAY_B(_:)), for: .touchUpInside)
            
            CELL.AMOUNT_L1.text = "현재 \(DATA.storeName)의 순위는?"
            CELL.AMOUNT_L2.text = "\(DATA.storeCategory) \(UIViewController.appDelegate.row+1)위"
            CELL.LEGOUP_B.addTarget(CELL, action: #selector(CELL.LEGOUP_B(_:)), for: .touchUpInside)
            
            return CELL
        } else if indexPath.section == 1 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC0_MAIN2", for: indexPath) as! TC0_MAIN
            
            CELL.COUPON_L.text = DATA.pangpangMenu
            CELL.COUNT_L.text = "\(DATA.pangpangRemain)개"
            
            return CELL
        } else {
            return UITableViewCell()
        }
    }
}
