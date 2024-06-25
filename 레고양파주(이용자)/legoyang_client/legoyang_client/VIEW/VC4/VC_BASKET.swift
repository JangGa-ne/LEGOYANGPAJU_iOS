//
//  VC_BASKET.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/02/06.
//

import UIKit
import FirebaseFirestore

class TC_BASKET: UITableViewCell {
    
    var PRICE: Int = 0
    var DELIVERY: Int = 0
    
    var OBJ_BASKET: [API_LEGONGGU] = []
    var OBJ_POSITION: Int = 0
    
    @IBOutlet weak var STORE_I: UIImageView!
    @IBOutlet weak var SUBJECT_L: UILabel!
    @IBOutlet weak var CONTENS_L: UILabel!
    @IBOutlet weak var OPTION_SV: UIStackView!
    
    @IBOutlet weak var TIMER_L: UILabel!
    @IBOutlet weak var COUNT_L: UILabel!
    
    @IBOutlet weak var PRICE_L1: UILabel!
    @IBOutlet weak var PRICE_L2: UILabel!
    @IBOutlet weak var PRICE_L3: UILabel!
    @IBOutlet weak var DELETE_B: UIButton!
    @IBOutlet weak var SUBMIT_B: UIButton!
    
    @objc func viewDidLoad() {
        
        OPTION_SV.removeAllArrangedSubviews(); PRICE = 0
        
        for DATA in OBJ_BASKET[OBJ_POSITION].ORDER_ITEMARRAY {
            
            PRICE += ((Int(DATA.ITEM_PRICE) ?? 0)*(Int(DATA.ITEM_COUNT) ?? 0))
            if DATA.FREEDELIVERY_COUPON_USE == "true" { DELIVERY = 0 } else { DELIVERY = 3000 }
            
            let BACKGROUND_SV = UIStackView()
            BACKGROUND_SV.axis = .vertical
            BACKGROUND_SV.spacing = 0
            
            let OPTION_L1 = UILabel()
            OPTION_L1.translatesAutoresizingMaskIntoConstraints = false
            OPTION_L1.addConstraints([NSLayoutConstraint(item: OPTION_L1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15)])
            OPTION_L1.font = UIFont.boldSystemFont(ofSize: 12)
            OPTION_L1.textAlignment = .left
            OPTION_L1.textColor = .black
            OPTION_L1.numberOfLines = 3
            OPTION_L1.text = "옵션: \(DATA.ITEM_OPTION) | 수량: \(DATA.ITEM_COUNT)"
            BACKGROUND_SV.addArrangedSubview(OPTION_L1)
            
            let OPTION_L2 = UILabel()
            OPTION_L2.translatesAutoresizingMaskIntoConstraints = false
            OPTION_L2.addConstraints([NSLayoutConstraint(item: OPTION_L2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)])
            OPTION_L2.font = UIFont.boldSystemFont(ofSize: 14)
            OPTION_L2.textAlignment = .left
            OPTION_L2.textColor = .H_FF6F00
            OPTION_L2.numberOfLines = 3
            OPTION_L2.text = "\(NF.string(from: ((Int(DATA.ITEM_PRICE) ?? 0)*(Int(DATA.ITEM_COUNT) ?? 0)) as NSNumber) ?? "0")원"
            BACKGROUND_SV.addArrangedSubview(OPTION_L2)
            
            OPTION_SV.addArrangedSubview(BACKGROUND_SV)
        }
    }
}

class VC_BASKET: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var FIRST: Bool = false
    var TIMER: [Timer] = []
    
    var OBJ_BASKET: [API_LEGONGGU] = []
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_BASKET_DEL = self
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 20, right: 0)
        
        GET_BASKET(NAME: "장바구니(추가)", AC_TYPE: "legonggu_basket")
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

extension VC_BASKET: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if OBJ_BASKET.count > 0 { return OBJ_BASKET.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = OBJ_BASKET[indexPath.item]
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_BASKET_1", for: indexPath) as! TC_BASKET
        CELL.OBJ_BASKET = OBJ_BASKET; CELL.OBJ_POSITION = indexPath.item; CELL.viewDidLoad()
        
        if DATA.ITEM_MAINIMG != "" {
            NUKE(IV: CELL.STORE_I, IU: DATA.ITEM_MAINIMG, RD: 10, CM: .scaleAspectFill)
        } else if DATA.ITEM_IMG.count > 0 {
            NUKE(IV: CELL.STORE_I, IU: DATA.ITEM_IMG[0], RD: 10, CM: .scaleAspectFill)
        }
        CELL.SUBJECT_L.text = DATA.ITEM_NAME
        CELL.CONTENS_L.text = DATA.ITEM_CONTENT
        
        if DATA.ORDER_ITEMARRAY.count > 0 { CELL.OPTION_SV.isHidden = false } else { CELL.OPTION_SV.isHidden = true }
        
        if FIRST || (OBJ_BASKET.count == 1) {
            var TIMESTAMP = (Int(DATA.END_TIME) ?? 0) - Int(floor(Date().timeIntervalSince1970)); CELL.TIMER_L.text = FM_TIMER(TIMESTAMP: TIMESTAMP)
            let TIMER = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                TIMESTAMP = TIMESTAMP - 1; CELL.TIMER_L.text = self.FM_TIMER(TIMESTAMP: TIMESTAMP)
            }; RunLoop.current.add(TIMER, forMode: .common); self.TIMER.append(TIMER)
            if FM_TIMER(TIMESTAMP: TIMESTAMP) == "마감" { CELL.COUNT_L.text = "-" } else { CELL.COUNT_L.text = "\(DATA.REMAIN_COUNT)" }
            
            CELL.PRICE_L1.text = "\(NF.string(from: CELL.PRICE as NSNumber) ?? "0")원"
            CELL.PRICE_L2.text = "\(NF.string(from: CELL.DELIVERY as NSNumber) ?? "0")원"
            CELL.PRICE_L3.text = "\(NF.string(from: (CELL.PRICE+CELL.DELIVERY) as NSNumber) ?? "0")원"
            
            CELL.DELETE_B.tag = indexPath.item; CELL.DELETE_B.addTarget(self, action: #selector(DELETE_B(_:)), for: .touchUpInside)
            CELL.SUBMIT_B.tag = indexPath.item; CELL.SUBMIT_B.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
        }; FIRST = true
        
        return CELL
    }
    
    @objc func DELETE_B(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: "", message: "선택하신 상품을 삭제하시겠습니까?", preferredStyle: .alert)
        ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.PUT_DELETE(NAME: "장바구니(삭제)", AC_TYPE: "legonggu_basket", POSITION: sender.tag)
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(ALERT, animated: true, completion: nil)
    }
    
    @objc func SUBMIT_B(_ sender: UIButton) {
        
        Firestore.firestore().collection("legonggu_item").document(self.OBJ_BASKET[sender.tag].ITEM_NAME).getDocument { response, error in
            
            if let response = response {
                
                let TIMESTAMP = (Int(self.OBJ_BASKET[sender.tag].END_TIME) ?? 0) - Int(floor(Date().timeIntervalSince1970))
                let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
                
                var item_count: Int = 0
                for data in self.OBJ_BASKET[sender.tag].ORDER_ITEMARRAY { item_count += (Int(data.ITEM_COUNT) ?? 0) }
                
                if (response.data()?["remain_count"] as? Int ?? 0) < item_count && (MEMBER_ID != "01031870005") && (MEMBER_ID != "01031853309") {
                    self.S_NOTICE("구매가능 갯수 초과")
                } else if (self.FM_TIMER(TIMESTAMP: TIMESTAMP) == "마감") && (MEMBER_ID != "01031870005") && (MEMBER_ID != "01031853309") {
                    self.S_NOTICE("마감된 공구")
                } else {
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL4") as! VC_DETAIL4
                    VC.OBJ_BASKET = self.OBJ_BASKET; VC.OBJ_POSITION = sender.tag
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
        }
    }
}
