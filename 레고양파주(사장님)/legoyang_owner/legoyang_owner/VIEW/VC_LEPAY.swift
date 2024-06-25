//
//  VC_LEPAY.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/06.
//

import UIKit

class TC_LEPAY: UITableViewCell {
    
    @IBOutlet weak var DATETIME_L: UILabel!
    @IBOutlet weak var USE_L1: UILabel!
    @IBOutlet weak var USE_L2: UILabel!
    @IBOutlet weak var CASH_L: UILabel!
}

class VC_LEPAY: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var PAY: String = ""
    var OBJ_PAYMENT: [API_LEPAY_HISTORY] = []
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var PAY_L: UILabel!
    @IBOutlet weak var VC_POPUP3_B: UIButton!
    @IBOutlet weak var TABLEVIEW: UITableView!
    @IBOutlet weak var VC_PAYMENT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_LEPAY_DEL = self
        
        PAY_L.text = PAY
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        GET_PAYMENT(NAME: "레pay", AC_TYPE: "lepay_history")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VC_POPUP3_B.addTarget(self, action: #selector(VC_POPUP3_B(_:)), for: .touchUpInside)
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
        
        VC_PAYMENT_B.addTarget(self, action: #selector(VC_PAYMENT_B(_:)), for: .touchUpInside)
    }
    
    @objc func VC_POPUP3_B(_ sender: UIButton) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_POPUP3") as! VC_POPUP3
        VC.modalPresentationStyle = .overCurrentContext; VC.transitioningDelegate = self
        VC.AC_TYPE = "lepay_history"; VC.DT_TYPE = "lepay_time"
        present(VC, animated: true, completion: nil)
    }
    
    @objc func VC_PAYMENT_B(_ sender: UIButton) {
        segueViewController(identifier: "VC_PAYMENT")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(true)
    }
}

extension VC_LEPAY: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if OBJ_PAYMENT.count > 0 { return OBJ_PAYMENT.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = OBJ_PAYMENT[indexPath.item]
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_LEPAY1", for: indexPath) as! TC_LEPAY
        
        if DATA.LEPAY_TIME.count == 13 {
            CELL.DATETIME_L.text = FM_TIMESTAMP((Int(DATA.LEPAY_TIME) ?? 0)/1000, "yy.MM.dd (E) a hh:mm")
        } else {
            CELL.DATETIME_L.text = FM_TIMESTAMP(Int(DATA.LEPAY_TIME) ?? 0, "yy.MM.dd (E) a hh:mm")
        }
        CELL.USE_L1.text = DATA.LEPAY_TYPE
        CELL.USE_L2.text = DATA.LEPAY_DETAIL
        CELL.CASH_L.text = "\((NF.string(from: (Int(DATA.LEPAY_AMOUNT) ?? 0) as NSNumber) ?? ""))원"
        
        return CELL
    }
}
