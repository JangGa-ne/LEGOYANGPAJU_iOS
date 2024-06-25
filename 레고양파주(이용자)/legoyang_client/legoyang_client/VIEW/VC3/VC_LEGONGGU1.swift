//
//  VC_LEGONGGU1.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/13.
//

import UIKit

class TC_LEGONGGU1: UITableViewCell {
    
    @IBOutlet weak var TIMER_L: UILabel!
    @IBOutlet weak var COUNT_L: UILabel!
    @IBOutlet weak var SLIDER_I: UIImageView!
    @IBOutlet weak var SUBJECT_L: UILabel!
    @IBOutlet weak var ITEM_PRICE_L: UILabel!
    @IBOutlet weak var PRICE_L: UILabel!
    @IBOutlet weak var POINT_I: UIImageView!
    @IBOutlet weak var DELIVERY_L: UILabel!
    @IBOutlet weak var SHARE_B: UIButton!
}

class VC_LEGONGGU1: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var OBJ_LEGONGGU: [API_LEGONGGU] = []
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_LEGONGGU1_DEL = self
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 20, right: 0)
        
        GET_LEGONGGU(NAME: "레공구", AC_TYPE: "legonggu_item")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}

extension VC_LEGONGGU1: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if OBJ_LEGONGGU.count > 0 { return OBJ_LEGONGGU.count } else { return 0 }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_LEGONGGU1_1", for: indexPath) as! TC_LEGONGGU1
            
            return CELL
        } else if indexPath.section == 1 {
            
            let DATA = OBJ_LEGONGGU[indexPath.item]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_LEGONGGU1_2", for: indexPath) as! TC_LEGONGGU1
            
            var TIMESTAMP = (Int(DATA.END_TIME) ?? 0) - Int(floor(Date().timeIntervalSince1970)); CELL.TIMER_L.text = FM_TIMER(TIMESTAMP: TIMESTAMP)
            let TIMER = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                TIMESTAMP = TIMESTAMP - 1; CELL.TIMER_L.text = self.FM_TIMER(TIMESTAMP: TIMESTAMP)
            }
            if FM_TIMER(TIMESTAMP: TIMESTAMP) == "마감" { TIMER.invalidate(); CELL.COUNT_L.text = "-" } else { RunLoop.current.add(TIMER, forMode: .common); CELL.COUNT_L.text = "\(DATA.REMAIN_COUNT)" }
            
            if DATA.ITEM_MAINIMG != "" {
                NUKE(IV: CELL.SLIDER_I, IU: DATA.ITEM_MAINIMG, PH: UIImage(), RD: 7.5, CM: .scaleAspectFill)
            } else if DATA.ITEM_IMG.count > 0 {
                NUKE(IV: CELL.SLIDER_I, IU: DATA.ITEM_IMG[0], PH: UIImage(), RD: 7.5, CM: .scaleAspectFill)
            } else {
                CELL.SLIDER_I.image = UIImage(named: "icon")
            }
            CELL.SUBJECT_L.text = DATA.ITEM_NAME
            CELL.ITEM_PRICE_L.text = DATA.ITEM_PRICE
            CELL.PRICE_L.text = "\(NF.string(from: (Int(DATA.ITEM_BASEPRICE) ?? 0) as NSNumber) ?? "0")원"
            if DATA.ITEM_SALEINFO.contains("적립") { CELL.POINT_I.isHidden = false } else { CELL.POINT_I.isHidden = true }
            CELL.DELIVERY_L.text = DATA.ITEM_SALEINFO
            CELL.SHARE_B.tag = indexPath.item; CELL.SHARE_B.addTarget(self, action: #selector(SHARE_B(_:)), for: .touchUpInside)
            
            return CELL
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func SHARE_B(_ sender: UIButton) { UIImpactFeedbackGenerator().impactOccurred()
        
        if OBJ_LEGONGGU.count > 0 {
            
            let DATA = OBJ_LEGONGGU[sender.tag]
            
            var IMAGE: String = ""
            if DATA.ITEM_MAINIMG != "" { IMAGE = DATA.ITEM_MAINIMG } else if DATA.ITEM_IMG.count > 0 { IMAGE = DATA.ITEM_IMG[0] }
            
            setShare(title: DATA.ITEM_NAME, description: DATA.ITEM_PRICE, imageUrl: IMAGE, params: "item_name=\(DATA.ITEM_NAME)&type=legonggu")
        } else {
            S_NOTICE("오류 (!)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let DATA = OBJ_LEGONGGU[indexPath.item]
            let TIMESTAMP = (Int(DATA.END_TIME) ?? 0) - Int(floor(Date().timeIntervalSince1970))
            
            let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
            if (TIMESTAMP <= 0) && (MEMBER_ID != "01031870005") && (MEMBER_ID != "01031853309") {
                S_NOTICE("마감된 공구")
            } else {
                let VC = storyboard?.instantiateViewController(withIdentifier: "VC_LEGONGGU2") as! VC_LEGONGGU2
                VC.OBJ_LEGONGGU = OBJ_LEGONGGU; VC.OBJ_POSITION = indexPath.item
                navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
}
