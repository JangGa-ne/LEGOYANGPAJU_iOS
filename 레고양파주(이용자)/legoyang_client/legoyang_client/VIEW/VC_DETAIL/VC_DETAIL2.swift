//
//  VC_DETAIL2.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/26.
//

import UIKit

class TC_DETAIL2: UITableViewCell {
    
    @IBOutlet weak var BUY_I: UIImageView!
    @IBOutlet weak var BUY_L: UILabel!
    @IBOutlet weak var TIME_L: UILabel!
    
    @IBOutlet weak var STATE_L1: UILabel!
    @IBOutlet weak var STATE_L2: UILabel!
    
    @IBOutlet weak var TOP_V: UIView!
    @IBOutlet weak var BOTTOM_V: UIView!
    
    @IBOutlet weak var STATUS_L1: UILabel!
    @IBOutlet weak var STATUS_L2: UILabel!
    @IBOutlet weak var STATUS_L3: UILabel!
    @IBOutlet weak var DATETIME_L: UILabel!
}

// 배송조회
class VC_DETAIL2: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var position: Int = 0
    
    var ITEM_IMG: String = ""
    var ITEM_NAME: String = ""
    var ITEM_TIME: String = ""
    var DL_COMPANY: String = ""
    var DL_NUMBER: String = ""
    
    var OBJ_NOTICE: [API_NOTI_LIST] = []
    var OBJ_POSITION: Int = 0
    
    var OBJ_DELIVERY: [API_DELIVERY] = []
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    @IBOutlet weak var DELIVERY_L1: UILabel!
    @IBOutlet weak var DELIVERY_B1: UIButton!
    @IBOutlet weak var DELIVERY_L2: UILabel!
    
    override func loadView() {
        super.loadView()
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 90, right: 0)
        
        if (ITEM_IMG == "") && (ITEM_NAME == "") && (ITEM_TIME == "") { GET_ORDER(NAME: "주문정보조회", AC_TYPE: "notice") }
        if (DL_COMPANY != "") && (DL_NUMBER != "") { GET_DELIVERY(NAME: "배송조회", AC_TYPE: "delivery", DL_COMPANY: DELIVERY_COMPANY[DL_COMPANY] ?? "", DL_NUMBER: DL_NUMBER) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
        
        DELIVERY_B1.addTarget(self, action: #selector(DELIVERY_B1(_:)), for: .touchUpInside)
    }
    
    @objc func DELIVERY_B1(_ sender: UIButton) {
        if DELIVERY_L1.text! == "-" {
            S_NOTICE("운송장번호 (!)")
        } else {
            S_NOTICE("클립보드에 복사됨"); UIPasteboard.general.string = DELIVERY_L1.text!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension VC_DETAIL2: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if OBJ_DELIVERY.count > 0 { if OBJ_DELIVERY[0].PROGRESSES.count > 0 { return OBJ_DELIVERY[0].PROGRESSES.count } else { return 0 } } else { return 0 }
        } else if section == 2 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_DETAIL2_1", for: indexPath) as! TC_DETAIL2
            
            if ITEM_IMG != "" { NUKE(IV: CELL.BUY_I, IU: ITEM_IMG, PH: UIImage(), RD: 10, CM: .scaleAspectFill) }
            CELL.BUY_L.text = ITEM_NAME
            CELL.TIME_L.text = FM_TIMESTAMP(Int(ITEM_TIME) ?? 0, "yy.MM.dd. E. 구매")
            
            CELL.STATE_L1.text = "배송 정보를 가져오는 중입니다."
            if OBJ_DELIVERY.count > 0 {
                if OBJ_DELIVERY[0].PROGRESSES.count > 0 {
                    let DATA = OBJ_DELIVERY[0].PROGRESSES[0]
                    CELL.STATE_L1.text = "\(FM_CUSTOM(DATA.TIME, "yy.MM.dd")) / \(DATA.STATUS_TEXT)"
                    CELL.STATE_L2.text = DATA.DESCRIPTION
                }
            } else {
                CELL.STATE_L1.text = "배송 추적을 할 수 없습니다."
            }
            
            return CELL
        } else if indexPath.section == 1 {
            
            let DATA = OBJ_DELIVERY[0].PROGRESSES[indexPath.item]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_DETAIL2_2", for: indexPath) as! TC_DETAIL2
            
            if indexPath.item == 0 {
                CELL.TOP_V.isHidden = true; CELL.BOTTOM_V.isHidden = false
            } else if indexPath.item == OBJ_DELIVERY[0].PROGRESSES.count-1 {
                CELL.TOP_V.isHidden = false; CELL.BOTTOM_V.isHidden = true
            } else {
                CELL.TOP_V.isHidden = false; CELL.BOTTOM_V.isHidden = false
            }
            
            CELL.STATUS_L1.text = DATA.STATUS_TEXT
            CELL.STATUS_L2.text = DATA.LOCATION_NAME
            CELL.STATUS_L3.text = DATA.DESCRIPTION
            CELL.DATETIME_L.text = FM_CUSTOM(DATA.TIME, "yy.MM.dd E HH:mm:ss")
            
            return CELL
        } else if indexPath.section == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "TC_DETAIL2_3", for: indexPath) as! TC_DETAIL2
        } else {
            return UITableViewCell()
        }
    }
}
