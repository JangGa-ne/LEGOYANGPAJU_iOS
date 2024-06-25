//
//  VC_ORDER2.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/02/21.
//

import UIKit

class TC_ORDER2: UITableViewCell {
    
    var PROTOCOL: VC_ORDER2!
    
    var OBJ_ORDER_DETAIL: [API_ORDER_DETAIL] = []
    var OBJ_POSITION: Int = 0
    
    @IBOutlet weak var DATETIME_L: UILabel!
    
    @IBOutlet weak var ITEM_I: UIImageView!
    @IBOutlet weak var GRADE_L: UILabel!
    @IBOutlet weak var ITEM_L: UILabel!
    @IBOutlet weak var OPTION_SV: UIStackView!
    @IBOutlet weak var PRICE_L: UILabel!
    
    @IBOutlet weak var SUBMIT_B1: UIButton!
    @IBOutlet weak var SUBMIT_SV2: UIStackView!
    @IBOutlet weak var SUBMIT_B2: UIButton!
    @IBOutlet weak var SUBMIT_B3: UIButton!
    @IBOutlet weak var SUBMIT_B4: UIButton!
    @IBOutlet weak var SUBMIT_B5: UIButton!
    @IBOutlet weak var STATE_L: UILabel!
    
    @IBOutlet weak var NAME_L: UILabel!
    @IBOutlet weak var PHONE_L: UILabel!
    @IBOutlet weak var ADDRESS_L: UILabel!
    @IBOutlet weak var MEMO_L: UILabel!
    
    @IBOutlet weak var PRICE_L1: UILabel!
    @IBOutlet weak var PRICE_L2: UILabel!
    @IBOutlet weak var PRICE_L3: UILabel!
    @IBOutlet weak var PRICE_L4: UILabel!
    @IBOutlet weak var PRICE_L5: UILabel!
    @IBOutlet weak var PRICE_L6: UILabel!
    
    func viewDidLoad() {
        
        OPTION_SV.removeAllArrangedSubviews()
        
        let DATA = OBJ_ORDER_DETAIL[OBJ_POSITION]
        for (_, DATA) in DATA.ORDER_ITEMARRAY.enumerated() {
            
            let OPTION_L1 = UILabel()
            OPTION_L1.font = UIFont.systemFont(ofSize: 12)
            OPTION_L1.lineBreakMode = .byTruncatingMiddle
            OPTION_L1.textAlignment = .left
            OPTION_L1.textColor = .black
            OPTION_L1.text = DATA.ITEM_OPTION
            
            let OPTION_L2 = UILabel()
            OPTION_L2.font = UIFont.systemFont(ofSize: 12)
            OPTION_L2.lineBreakMode = .byTruncatingMiddle
            OPTION_L2.textAlignment = .right
            OPTION_L2.textColor = .black
            OPTION_L2.text = "수량: \(DATA.ITEM_COUNT)개"
            
            let BACKGROUND_SV = UIStackView(arrangedSubviews: [OPTION_L1, OPTION_L2])
            BACKGROUND_SV.translatesAutoresizingMaskIntoConstraints = false
            BACKGROUND_SV.addConstraints([NSLayoutConstraint(item: BACKGROUND_SV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)])
            BACKGROUND_SV.axis = .horizontal
            BACKGROUND_SV.spacing = 5
            OPTION_SV.addArrangedSubview(BACKGROUND_SV)
        }
    }
}

class VC_ORDER2: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var KEY: String = ""
    
    var OBJ_ORDER_DETAIL: [API_ORDER_DETAIL] = []
    var OBJ_POSITION: Int = 0
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        S_INDICATOR(self.view, animated: false)
        
        UIViewController.VC_ORDER2_DEL = self
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        if KEY != "" { GET_ORDER_DETAIL(NAME: "주문내역", AC_TYPE: "legonggu_order_detail") }
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

extension VC_ORDER2: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if OBJ_ORDER_DETAIL.count > 0 { return 1 } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = OBJ_ORDER_DETAIL[OBJ_POSITION]
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_ORDER2_1", for: indexPath) as! TC_ORDER2
        CELL.PROTOCOL = self; CELL.OBJ_ORDER_DETAIL = OBJ_ORDER_DETAIL; CELL.OBJ_POSITION = indexPath.item; CELL.viewDidLoad()
        
        CELL.DATETIME_L.text = FM_TIMESTAMP(Int(DATA.ORDER_TIME) ?? 0, "yy.MM.dd E. HH:mm:ss")
        
        if DATA.ITEM_MAINIMG != "" {
            NUKE(IV: CELL.ITEM_I, IU: DATA.ITEM_MAINIMG, RD: 12.5, CM: .scaleAspectFill)
        } else if DATA.ITEM_IMG.count > 0 {
            NUKE(IV: CELL.ITEM_I, IU: DATA.ITEM_IMG[0], RD: 12.5, CM: .scaleAspectFill)
        } else {
            CELL.ITEM_I.image = UIImage()
        }
        CELL.GRADE_L.text = DT_CHECK(DATA.ORDER_STATE)
        CELL.ITEM_L.text = DT_CHECK(DATA.ITEM_NAME)
        
        var OPTION: String = ""
        var COUNT: Int = 0
        let PRICE = (Int(DATA.ORDER_TOTALPRICE) ?? 0) - (Int(DATA.ORDER_TOTALDISCOUNT) ?? 0)
        for (I, DATA) in DATA.ORDER_ITEMARRAY.enumerated() {
            if I != (OBJ_ORDER_DETAIL[indexPath.item].ORDER_ITEMARRAY.count-1) {
                OPTION.append("\(DATA.ITEM_OPTION) / ")
            } else {
                OPTION.append(DATA.ITEM_OPTION)
            }
            COUNT += Int(DATA.ITEM_COUNT) ?? 0
        }
        CELL.PRICE_L.text = "\(NF.string(from: PRICE as NSNumber) ?? "0")원"
        if DATA.ORDER_STATE == "배송전" {
            CELL.SUBMIT_B1.isHidden = false; CELL.SUBMIT_SV2.isHidden = true
        } else if DATA.ORDER_COMPLETE == "false" {
            CELL.SUBMIT_B1.isHidden = true; CELL.SUBMIT_SV2.isHidden = false
        } else if (DATA.ORDER_STATE == "배송완료") && (DATA.ORDER_COMPLETE == "true") {
            CELL.GRADE_L.text = "구매확정"; CELL.SUBMIT_B1.isHidden = true; CELL.SUBMIT_SV2.isHidden = true
        }
        CELL.SUBMIT_B1.tag = 0; CELL.SUBMIT_B1.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
        CELL.SUBMIT_B2.tag = 1; CELL.SUBMIT_B2.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
        CELL.SUBMIT_B3.tag = 2; CELL.SUBMIT_B3.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
        CELL.SUBMIT_B4.tag = 3; CELL.SUBMIT_B4.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
        CELL.SUBMIT_B5.tag = 4; CELL.SUBMIT_B5.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
        
        if DATA.ORDER_STATE.contains("주문취소") {
            CELL.SUBMIT_B1.isHidden = true; CELL.SUBMIT_SV2.isHidden = true; CELL.STATE_L.isHidden = false
            CELL.STATE_L.text = "주문취소 요청(처리)됨"
        } else if DATA.ORDER_STATE.contains("반품") {
            CELL.SUBMIT_B1.isHidden = true; CELL.SUBMIT_SV2.isHidden = true; CELL.STATE_L.isHidden = false
            CELL.STATE_L.text = "반품(\(DT_CHECK(DATA.ORDER_WRONG_TYPE))) 요청(처리)됨"
        } else if DATA.ORDER_STATE.contains("교환") {
            CELL.SUBMIT_B1.isHidden = true; CELL.SUBMIT_SV2.isHidden = true; CELL.STATE_L.isHidden = false
            CELL.STATE_L.text = "교환(\(DT_CHECK(DATA.ORDER_WRONG_TYPE))) 요청(처리)됨"
        } else if DATA.ORDER_STATE == "구매확정" {
            CELL.SUBMIT_B1.isHidden = true; CELL.SUBMIT_SV2.isHidden = true; CELL.STATE_L.isHidden = false
            let GRADE = (Int(DATA.GRADE) ?? 1)+1
            CELL.STATE_L.text = "\(GRADE)%, 레페이 \(NF.string(from: (Int(DATA.ORDER_BENEFIT_POINT) ?? 0) as NSNumber) ?? "0")원 적립됨"
        } else {
            CELL.STATE_L.isHidden = true
        }
        
        CELL.NAME_L.text = DT_CHECK(DATA.RECEIVER_NAME)
        CELL.PHONE_L.text = setHyphen("phone", DATA.RECEIVER_NUMBER1)
        CELL.ADDRESS_L.text = DT_CHECK(DATA.RECEIVER_ADDRESS)
        CELL.MEMO_L.text = DT_CHECK(DATA.RECEIVER_MEMO)
        
        CELL.PRICE_L1.text = "\(NF.string(from: (Int(DATA.ORDER_ITEMPRICE) ?? 0) as NSNumber) ?? "0")원"
        CELL.PRICE_L2.text = "\(NF.string(from: (Int(DATA.ORDER_DELIVERYFEE) ?? 0) as NSNumber) ?? "0")원"
        CELL.PRICE_L3.text = "\(NF.string(from: -(Int(DATA.ORDER_TOTALDISCOUNT) ?? 0) as NSNumber) ?? "0")원"
        CELL.PRICE_L4.text = "\(NF.string(from: -(Int(DATA.LEPAY_DISCOUNT) ?? 0) as NSNumber) ?? "0")원"
        CELL.PRICE_L5.text = "\(NF.string(from: -(Int(DATA.ORDER_DELIVERYFEE) ?? 0) as NSNumber) ?? "0")원"
        CELL.PRICE_L6.text = "\(NF.string(from: PRICE as NSNumber) ?? "0")원"
        
        return CELL
    }
    
    @objc func SUBMIT_B(_ sender: UIButton) {
        
        let DATA = OBJ_ORDER_DETAIL[OBJ_POSITION]
            
        if sender.tag == 0 {
            let ALERT = UIAlertController(title: "", message: "주문취소 요청시 관리자가 승인을 해야\n환불 및 결제가 취소됩니다.\n환불 및 결제 취소는 익일(주말 제외) 처리될 예정입니다.", preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "주문취소", style: .destructive, handler: { _ in
                self.OBJ_POSITION = self.OBJ_POSITION
                self.SET_CANCEL(NAME: "주문취소", AC_TYPE: "legonggu_order_detail")
            }))
            ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            present(ALERT, animated: true, completion: nil)
        } else if sender.tag == 1 {
            let VC = storyboard?.instantiateViewController(withIdentifier: "VC_ORDER3") as! VC_ORDER3
            VC.TITLE1 = "구매확정"; VC.TITLE2 = "상품은 잘 받으셨나요?"; VC.OBJ_ORDER_DETAIL = OBJ_ORDER_DETAIL; VC.OBJ_POSITION = OBJ_POSITION
            navigationController?.pushViewController(VC, animated: true)
        } else if sender.tag == 2 {
            let VC = storyboard?.instantiateViewController(withIdentifier: "VC_ORDER3") as! VC_ORDER3
            VC.TITLE1 = "반품요청"; VC.TITLE2 = "반품 사유를 입력해 주세요."; VC.OBJ_ORDER_DETAIL = OBJ_ORDER_DETAIL; VC.OBJ_POSITION = OBJ_POSITION
            VC.WRONG_TYPE = ["단순변심", "주문실수", "파손 및 불량", "오배송"]
            navigationController?.pushViewController(VC, animated: true)
        } else if sender.tag == 3 {
            let VC = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL2") as! VC_DETAIL2
            VC.ITEM_IMG = DATA.ITEM_MAINIMG; VC.ITEM_NAME = DATA.ITEM_NAME; VC.ITEM_TIME = DATA.ORDER_TIME; VC.DL_COMPANY = DATA.DELIVERY_COMPANY; VC.DL_NUMBER = DATA.INVOICE_NUMBER
            navigationController?.pushViewController(VC, animated: true)
        } else if sender.tag == 4 {
            let VC = storyboard?.instantiateViewController(withIdentifier: "VC_ORDER3") as! VC_ORDER3
            VC.TITLE1 = "교환요청"; VC.TITLE2 = "교환 사유를 입력해 주세요."; VC.OBJ_ORDER_DETAIL = OBJ_ORDER_DETAIL; VC.OBJ_POSITION = OBJ_POSITION
            VC.WRONG_TYPE = ["옵션변경", "주문실수", "파손 및 불량", "오배송"]
            navigationController?.pushViewController(VC, animated: true)
        }
    }
}
