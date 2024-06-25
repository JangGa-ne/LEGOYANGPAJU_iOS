//
//  VC_OPTION1.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/03/08.
//

import UIKit

class TC_OPTION1: UITableViewCell {
    
    @IBOutlet weak var STORE_I: UIImageView!
    @IBOutlet weak var QUOTE_LEFT_I: UIImageView!
    @IBOutlet weak var STORE_L: UILabel!
    @IBOutlet weak var QUOTE_RIGHT_I: UIImageView!
    @IBOutlet weak var COUPON_SV: UIStackView!
    @IBOutlet weak var COUPON_L: UILabel!
    @IBOutlet weak var SUBJECT_L: UILabel!
    @IBOutlet weak var CONTENTS_L: UILabel!
    @IBOutlet weak var MENUS_L: UILabel!
}

class VC_OPTION1: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var OBJ_STORE: [StoreData] = []
    var OBJ_POSTION: [Int] = []
    
    var OBJ_OPTION: [StoreData] = []
    
    @IBAction func BACK_B(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        TABLEVIEW.backgroundColor = .white
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        for POSITION in OBJ_POSTION { OBJ_OPTION.append(OBJ_STORE[POSITION]); TABLEVIEW.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
}

extension VC_OPTION1: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if OBJ_OPTION.count > 0 { return OBJ_OPTION.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = OBJ_OPTION[indexPath.item]
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_OPTION1_1", for: indexPath) as! TC_OPTION1
        
        if DATA.storeImage != "" {
            NUKE(IV: CELL.STORE_I, IU: DATA.storeImage, PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
        } else if DATA.imageArray.count > 0 {
            NUKE(IV: CELL.STORE_I, IU: DATA.imageArray[0], PH: UIImage(), RD: 12.5, CM: .scaleAspectFill)
        } else {
            CELL.STORE_I.image = UIImage(named: "logo2")
        }
        CELL.QUOTE_LEFT_I.image = UIImage(named: quoteLeftImages[DATA.storeColor] ?? "quote_left0")
        CELL.STORE_L.text = " \(DATA.storeName) "
        CELL.QUOTE_RIGHT_I.image = UIImage(named: quoteRightImages[DATA.storeColor] ?? "quote_right0")
        if DATA.usePangpang == "true" { CELL.COUPON_SV.isHidden = false; CELL.COUPON_L.text = DT_CHECK("\(DATA.pangpangRemain)") } else { CELL.COUPON_SV.isHidden = true }
        CELL.SUBJECT_L.text = DT_CHECK(DATA.storeSubTitle)
        CELL.MENUS_L.text = DATA.storeEtc
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true, completion: nil)
        
        if let RVC = UIViewController.VC_MAP2_DEL {
//            let VC = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL1") as! VC_DETAIL1
//            VC.OBJ_STORE = OBJ_OPTION; VC.OBJ_POSITION = indexPath.item
//            RVC.navigationController?.pushViewController(VC, animated: true)
            let segue = RVC.storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
            segue.StoreObject = OBJ_OPTION; segue.row = indexPath.item
            RVC.navigationController?.pushViewController(segue, animated: true)
        }
    }
}
