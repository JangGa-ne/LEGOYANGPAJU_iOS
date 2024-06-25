//
//  VC_AROUND.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/25.
//

import UIKit

class TC_AROUND: UITableViewCell {
    
    @IBOutlet weak var TITLE_L: UILabel!
    
    @IBOutlet weak var STORE_I: UIImageView!
    @IBOutlet weak var QUOTE_LEFT_I: UIImageView!
    @IBOutlet weak var STORE_L: UILabel!
    @IBOutlet weak var QUOTE_RIGHT_I: UIImageView!
    @IBOutlet weak var ADDRESS_L: UILabel!
    @IBOutlet weak var SUBJECT_L: UILabel!
    @IBOutlet weak var CONTENTS_L: UILabel!
    @IBOutlet weak var MENUS_L: UILabel!
    
    @IBOutlet weak var COUPON_L: UILabel!
    @IBOutlet weak var DISTANCE_L: UILabel!
}

class VC_AROUND: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var OBJ_AROUND: [API_STORE] = []
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_AROUND_DEL = self
        UIViewController.appDelegate.PUSH = 0
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 10, right: 0)
        
        GET_AROUND(NAME: "레고팡팡스토어", AC_TYPE: "member_around_store")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension VC_AROUND: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if OBJ_AROUND.count > 0 { return OBJ_AROUND.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = OBJ_AROUND[indexPath.item]
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_AROUND_1", for: indexPath) as! TC_AROUND
        
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
        CELL.ADDRESS_L.text = DATA.ST_ADDRESS
        CELL.SUBJECT_L.text = DT_CHECK(DATA.ST_SUB_TITLE)
        CELL.MENUS_L.text = DATA.ST_ETC
        
        CELL.COUPON_L.text = DT_CHECK("\(DATA.PP_REMAIN)")
        CELL.DISTANCE_L.text = "\(DT_CHECK(DATA.DISTANCE))km"
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL1") as! VC_DETAIL1
        VC.OBJ_STORE = OBJ_AROUND; VC.OBJ_POSITION = indexPath.item
        navigationController?.pushViewController(VC, animated: true)
    }
}
