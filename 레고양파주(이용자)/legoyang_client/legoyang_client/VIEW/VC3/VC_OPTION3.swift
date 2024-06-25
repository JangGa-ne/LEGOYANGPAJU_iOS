//
//  VC_OPTION3.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/16.
//

import UIKit
import FirebaseFirestore

class TC_OPTION3: UITableViewCell {
    
    var PROTOCOL: VC_OPTION3!
    
    var FIRST: Bool = true
    
    var OBJ_OPTION: [API_OPTION] = []
    var OBJ_POSITION: Int = 0
    
    @IBOutlet weak var OPTION_SV: UIStackView!
    @IBOutlet weak var TITLE_L: UILabel!
    
    @IBOutlet weak var NAME_L: UILabel!
    @IBOutlet weak var DELETE_B: UIButton!
    @IBOutlet weak var OPTION_L: UILabel!
    @IBOutlet weak var MINUS_B: UIButton!
    @IBOutlet weak var COUNT_L: UILabel!
    @IBOutlet weak var PLUS_B: UIButton!
    @IBOutlet weak var PRICE_L: UILabel!
    
    @IBOutlet weak var COUPON_I: UIImageView!
    @IBOutlet weak var COUPON_L: UILabel!
    
    func viewDidLoad() {
        
        if FIRST {
            
            var BUTTONS: [UIButton] = []
            
            for (I, DATA) in OBJ_OPTION[OBJ_POSITION].OBJ_TYPE.enumerated() {
                
                TITLE_L.text = DATA.OPTION_TYPE
                
                let OPTION_B = UIButton()
                OPTION_B.frame.size.height = 44
                OPTION_B.backgroundColor = .white
                OPTION_B.layer.cornerRadius = 5; OPTION_B.clipsToBounds = true
                OPTION_B.layer.borderWidth = 1; OPTION_B.layer.borderColor = UIColor.lightGray.cgColor
                OPTION_B.contentHorizontalAlignment = .left
                OPTION_B.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                OPTION_B.setTitleColor(.black, for: .normal)
                OPTION_B.setTitle("  \(DATA.OPTION_NAME) (+\(NF.string(from: (Int(DATA.OPTION_PRICE) ?? 0) as NSNumber) ?? "0")원)", for: .normal)
                OPTION_B.tag = I; OPTION_B.addTarget(self, action: #selector(OPTION_B(_:)), for: .touchUpInside)
                BUTTONS.append(OPTION_B)
                OPTION_SV.addArrangedSubview(OPTION_B)
            }; FIRST = false
            
            let AP_VALUE = API_BASKET()
            
            AP_VALUE.SET_CHECK(CHECK: false)
            AP_VALUE.SET_BUTTON(BUTTON: BUTTONS)
            AP_VALUE.SET_OPTION_NAME(OPTION_NAME: "")
            AP_VALUE.SET_OPTION_PRICE(OPTION_PRICE: 0)
            // 데이터 추가
            PROTOCOL.OBJ_BASKET.append(AP_VALUE)
        }
    }
    
    @objc func OPTION_B(_ sender: UIButton) {
        
        let ITEM_BASEPRICE: Int = Int(PROTOCOL.OBJ_LEGONGGU[PROTOCOL.OBJ_POSITION].ITEM_BASEPRICE) ?? 0
        var OPTION_NAME: String = ""
        var OPTION_PRICE: Int = 0
        // 옵션 선택
        for (I, BTN) in PROTOCOL.OBJ_BASKET[OBJ_POSITION].BUTTON.enumerated() {
            
            if sender.tag == I {
                PROTOCOL.OBJ_BASKET[OBJ_POSITION].CHECK = true
                PROTOCOL.OBJ_BASKET[OBJ_POSITION].OPTION_NAME = OBJ_OPTION[OBJ_POSITION].OBJ_TYPE[I].OPTION_NAME
                PROTOCOL.OBJ_BASKET[OBJ_POSITION].OPTION_PRICE = (Int(OBJ_OPTION[OBJ_POSITION].OBJ_TYPE[I].OPTION_PRICE) ?? 0)
                BTN.setTitleColor(.white, for: .normal); BTN.backgroundColor = .H_FF6F00; BTN.layer.borderWidth = 0
            } else {
                BTN.setTitleColor(.black, for: .normal); BTN.backgroundColor = .white; BTN.layer.borderWidth = 1
            }
        }
        // 전체 옵션 선택완료 확인
        for (_, DATA) in PROTOCOL.OBJ_BASKET.enumerated() { PROTOCOL.CHECK = true; if !DATA.CHECK { PROTOCOL.CHECK = false; break } }
        if !(PROTOCOL.CHECK) { return }
        // 항목 추가
        for (I, DATA) in PROTOCOL.OBJ_BASKET.enumerated() {
            if I < (PROTOCOL.OBJ_BASKET.count-1) { OPTION_NAME.append("\(DATA.OPTION_NAME) / ") } else { OPTION_NAME.append(DATA.OPTION_NAME) }
            OPTION_PRICE += DATA.OPTION_PRICE
        }; PROTOCOL.OBJ_BASKETS.append(["option_name": OPTION_NAME, "option_price": OPTION_PRICE + ITEM_BASEPRICE, "count": 1])
        // 옵션 버튼 비활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for (_, DATA) in self.PROTOCOL.OBJ_BASKET.enumerated() {
                for (_, BTN) in DATA.BUTTON.enumerated() {
                    DATA.CHECK = false; DATA.OPTION_NAME = ""; DATA.OPTION_PRICE = 0
                    BTN.setTitleColor(.black, for: .normal); BTN.backgroundColor = .white; BTN.layer.borderWidth = 1
                }
            }
        }; PROTOCOL.CHECK = false; PROTOCOL.OBJ_BASKETS.reverse()
        // 데이터 새로고침
        UIView.performWithoutAnimation {
            self.PROTOCOL.TABLEVIEW.reloadSections(IndexSet(integer: 1), with: .none)
            self.PROTOCOL.TABLEVIEW.reloadSections(IndexSet(integer: 2), with: .none)
            self.PROTOCOL.TABLEVIEW.contentOffset = self.PROTOCOL.TABLEVIEW.contentOffset
        }
    }
}

class VC_OPTION3: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var CHECK: Bool = true
    var FREE_DELIVERY: Bool = false
    
    var OBJ_LEGONGGU: [API_LEGONGGU] = []
    var OBJ_POSITION: Int = 0
    
    var OBJ_OPTION: [API_OPTION] = []
    var OBJ_BASKET: [API_BASKET] = []
    var OBJ_BASKETS: [[String: Any]] = []
    var ITEM_COUNT: Int = 0
    
    @IBAction func BACK_B(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    @IBOutlet weak var CHECK_B1: UIButton!
    @IBOutlet weak var CHECK_B2: UIButton!
    
    override func loadView() {
        super.loadView()
        
        TABLEVIEW.separatorStyle = .none; if #available(iOS 15.0, *) { TABLEVIEW.sectionHeaderTopPadding = 0 }
        TABLEVIEW.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        if #available(iOS 15.0, *) { TABLEVIEW.sectionHeaderTopPadding = 0 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
        
        CHECK_B1.tag = 0; CHECK_B1.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
        CHECK_B2.tag = 1; CHECK_B2.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
    }
    
    @objc func SUBMIT_B(_ sender: UIButton) {
        
        Firestore.firestore().collection("legonggu_item").document(self.OBJ_LEGONGGU[self.OBJ_POSITION].ITEM_NAME).getDocument { response, error in
            if let response = response {
                if self.OBJ_BASKETS.count == 0 {
                    self.S_NOTICE("항목이 없음")
                } else if (response.data()?["remain_count"] as? Int ?? 0) < self.ITEM_COUNT {
                    self.S_NOTICE("구매가능 갯수 초과")
                } else {
                    self.PUT_BASKET(NAME: "장바구니/주문결제", AC_TYPE: "legonggu_basket", BASKET: sender.tag)
                }
            }
        }
    }
}

extension VC_OPTION3: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_TITLE") as! TC_TITLE
        if section == 0 {
            CELL.TITLE_L.text = "옵션"
        } else if section == 3 {
            CELL.TITLE_L.text = "쿠폰"
        }
        return CELL
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if OBJ_OPTION.count > 0 { return 44 } else { return 0 }
        } else if section == 3 {
            return 44
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if OBJ_OPTION.count > 0 { return OBJ_OPTION.count } else { return 0 }
        } else if section == 1 {
            if OBJ_BASKETS.count > 0 { return OBJ_BASKETS.count } else { return 0 }
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let DATA = OBJ_OPTION[indexPath.item]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_OPTION3_1", for: indexPath) as! TC_OPTION3
            CELL.PROTOCOL = self; CELL.OBJ_OPTION = OBJ_OPTION; CELL.OBJ_POSITION = indexPath.item; CELL.viewDidLoad()
            
            if DATA.OBJ_TYPE.count > 0 { CELL.OPTION_SV.isHidden = false } else { CELL.OPTION_SV.isHidden = true }
            
            return CELL
        } else if indexPath.section == 1 {
            
            let DATA = OBJ_BASKETS[indexPath.item]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_OPTION3_2", for: indexPath) as! TC_OPTION3
            
            let OPTION_NAME = DATA["option_name"] as? String ?? ""
            let OPTION_PRICE = DATA["option_price"] as? Int ?? 0
            let COUNT = DATA["count"] as? Int ?? 0
            
            CELL.NAME_L.text = OBJ_LEGONGGU[OBJ_POSITION].ITEM_NAME
            CELL.OPTION_L.text = OPTION_NAME
            CELL.COUNT_L.text = "\(COUNT)"
            CELL.PRICE_L.text = "\(NF.string(from: (OPTION_PRICE*COUNT) as NSNumber) ?? "0")원"
            
            CELL.DELETE_B.tag = indexPath.item; CELL.DELETE_B.addTarget(self, action: #selector(DELETE_B(_:)), for: .touchUpInside)
            CELL.MINUS_B.tag = indexPath.item; CELL.MINUS_B.addTarget(self, action: #selector(MINUS_B(_:)), for: .touchUpInside)
            CELL.PLUS_B.tag = indexPath.item; CELL.PLUS_B.addTarget(self, action: #selector(PLUS_B(_:)), for: .touchUpInside)
            
            return CELL
        } else if indexPath.section == 2 {
            
            var COUNT: Int = 0
            var PRICE: Int = 0
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_OPTION3_3", for: indexPath) as! TC_OPTION3
            
            for (_, DATA) in OBJ_BASKETS.enumerated() {
                COUNT += (DATA["count"] as? Int ?? 0)
                PRICE += (DATA["option_price"] as? Int ?? 0)*(DATA["count"] as? Int ?? 0)
            }
            
            CELL.COUNT_L.text = "\(COUNT)"; ITEM_COUNT = COUNT
            if FREE_DELIVERY {
                CELL.PRICE_L.text = NF.string(from: PRICE as NSNumber) ?? "0"
            } else {
                CELL.PRICE_L.text = NF.string(from: (PRICE+3000) as NSNumber) ?? "0"
            }
            
            return CELL
        } else if indexPath.section == 3 {
            
            let DATA = UIViewController.appDelegate.MemberObject
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_OPTION3_4", for: indexPath) as! TC_OPTION3
            
            if FREE_DELIVERY { CELL.COUPON_I.image = UIImage(named: "check_on") } else { CELL.COUPON_I.image = UIImage(named: "check_off") }
            CELL.COUPON_L.text = "잔여량 \(DATA.freeDeliveryCoupon)개"
            
            return CELL
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let DATA = UIViewController.appDelegate.MemberObject
        
        if indexPath.section == 3 {
            if (DATA.freeDeliveryCoupon) > 0 {
                if !FREE_DELIVERY { FREE_DELIVERY = true } else { FREE_DELIVERY = false }
                UIView.performWithoutAnimation {
                    self.TABLEVIEW.reloadSections(IndexSet(integer: 2), with: .none)
                    self.TABLEVIEW.reloadRows(at: [IndexPath(item: 0, section: 3)], with: .automatic)
                    self.TABLEVIEW.contentOffset = self.TABLEVIEW.contentOffset
                }
            } else {
                S_NOTICE("사용가능한 쿠폰 없음")
            }
        }
    }
    
    @objc func DELETE_B(_ sender: UIButton) {
        OBJ_BASKETS.remove(at: sender.tag)
        UIView.performWithoutAnimation {
            self.TABLEVIEW.reloadSections(IndexSet(integer: 1), with: .none)
            self.TABLEVIEW.reloadSections(IndexSet(integer: 2), with: .none)
            self.TABLEVIEW.contentOffset = self.TABLEVIEW.contentOffset
        }
    }
    
    @objc func MINUS_B(_ sender: UIButton) {
        if (OBJ_BASKETS[sender.tag]["count"] as? Int ?? 0) > 1 { OBJ_BASKETS[sender.tag]["count"] = (OBJ_BASKETS[sender.tag]["count"] as? Int ?? 0) - 1 }
        UIView.performWithoutAnimation {
            self.TABLEVIEW.reloadSections(IndexSet(integer: 1), with: .none)
            self.TABLEVIEW.reloadSections(IndexSet(integer: 2), with: .none)
            self.TABLEVIEW.contentOffset = self.TABLEVIEW.contentOffset
        }
    }
    
    @objc func PLUS_B(_ sender: UIButton) {
        OBJ_BASKETS[sender.tag]["count"] = (OBJ_BASKETS[sender.tag]["count"] as? Int ?? 0) + 1
        UIView.performWithoutAnimation {
            self.TABLEVIEW.reloadSections(IndexSet(integer: 1), with: .none)
            self.TABLEVIEW.reloadSections(IndexSet(integer: 2), with: .none)
            self.TABLEVIEW.contentOffset = self.TABLEVIEW.contentOffset
        }
    }
}

class API_BASKET {
    
    var CHECK: Bool = false
    var BUTTON: [UIButton] = []
    var OPTION_NAME: String = ""
    var OPTION_PRICE: Int = 0
    
    func SET_CHECK(CHECK: Any) { self.CHECK = CHECK as? Bool ?? false }
    func SET_BUTTON(BUTTON: Any) { self.BUTTON = BUTTON as? [UIButton] ?? [] }
    func SET_OPTION_NAME(OPTION_NAME: Any) { self.OPTION_NAME = OPTION_NAME as? String ?? "" }
    func SET_OPTION_PRICE(OPTION_PRICE: Any) { self.OPTION_PRICE = OPTION_PRICE as? Int ?? 0 }
}
