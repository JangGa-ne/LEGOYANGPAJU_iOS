//
//  VC_WANT.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/25.
//

import UIKit

class TC_WANT: UITableViewCell {
    
    @IBOutlet weak var TITLE_L: UILabel!
    
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

class VC_WANT: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var OBJ_WANT: [API_STORE] = []
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        TABLEVIEW.separatorStyle = .none; if #available(iOS 15.0, *) { TABLEVIEW.sectionHeaderTopPadding = 0 }
        TABLEVIEW.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 10, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
        
        GET_WANT(NAME: "더보기 찜", AC_TYPE: "store")
    }
}

extension VC_WANT: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let DATA = UIViewController.appDelegate.OBJ_USER
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_WANT_T") as! TC_WANT
        
        if DATA.NAME != "" {
            CELL.TITLE_L.text = "\(DATA.NAME)님 :D / 총 \(DATA.MYLIKE_STORE.count)개의 찜"
        } else {
            CELL.TITLE_L.text = "\(DATA.NICK)님 :D / 총 \(DATA.MYLIKE_STORE.count)개의 찜"
        }
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if OBJ_WANT.count > 0 { return OBJ_WANT.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = OBJ_WANT[indexPath.item]
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_WANT_1", for: indexPath) as! TC_WANT
        
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
        if DATA.USE_PANGPANG == "true" { CELL.COUPON_SV.isHidden = false; CELL.COUPON_L.text = DT_CHECK("\(DATA.PP_REMAIN)") } else { CELL.COUPON_SV.isHidden = true }
        CELL.SUBJECT_L.text = DT_CHECK(DATA.ST_SUB_TITLE)
        CELL.MENUS_L.text = DATA.ST_ETC
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL1") as! VC_DETAIL1
        VC.OBJ_STORE = OBJ_WANT; VC.OBJ_POSITION = indexPath.item
        navigationController?.pushViewController(VC, animated: true)
    }
}
