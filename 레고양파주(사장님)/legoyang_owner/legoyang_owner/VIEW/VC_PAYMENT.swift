//
//  VC_PAYMENT.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/10/28.
//

import UIKit

class VC_PAYMENT: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var TICKET_V1: UIView!
    @IBOutlet weak var TICKET_V2: UIView!
    @IBOutlet weak var TICKET_V3: UIView!
    @IBOutlet weak var TICKET_V4: UIView!
    @IBOutlet weak var TICKET_V5: UIView!
    @IBOutlet weak var TICKET_V6: UIView!
    @IBOutlet weak var RESTORE_V: UIView!
    
    @IBOutlet weak var TICKET_B1: UIButton!
    @IBOutlet weak var TICKET_B2: UIButton!
    @IBOutlet weak var TICKET_B3: UIButton!
    @IBOutlet weak var TICKET_B4: UIButton!
    @IBOutlet weak var TICKET_B5: UIButton!
    @IBOutlet weak var TICKET_B6: UIButton!
    @IBOutlet weak var RESTORE_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        IAPHelper.VC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let VIEWS: [UIView] = [TICKET_V1, TICKET_V2, TICKET_V3, TICKET_V4, TICKET_V5, TICKET_V6, RESTORE_V]
//        for i in 0 ..< VIEWS.count {
//            VIEWS[i].tag = i; VIEWS[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TICKET_V(_:))))
//        }
        
        let BUTTONS: [UIButton] = [TICKET_B1, TICKET_B2, TICKET_B3, TICKET_B4, TICKET_B5, TICKET_B6, RESTORE_B]
        for i in 0 ..< BUTTONS.count {
            BUTTONS[i].tag = i; BUTTONS[i].addTarget(self, action: #selector(TICKET_B(_:)), for: .touchUpInside)
        }
    }
    
    @objc func TICKET_B(_ sender: UIButton) {
        
        if sender.tag != 6 {
            if UserDefaults.standard.bool(forKey: "payment_agree") { S_INDICATOR(view)
                InAppProducts.store.requestProducts { success, products in
                    if success, let product = products?[sender.tag] { InAppProducts.store.buyProduct(product) }
                }
            } else {
                let ALERT = UIAlertController(title: "안내", message: "레고양파주 사장용 유료 서비스를 이용하시려면\n약관에 동의하셔야 합니다.\n동의하시겠습니까?", preferredStyle: .alert)
                ALERT.addAction(UIAlertAction(title: "약관 보기", style: .default, handler: { _ in
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "VC_HTML") as! VC_HTML
                    VC.TITLE = "유료 서비스 이용약관"; VC.POSITION = 5; self.navigationController?.pushViewController(VC, animated: true)
                }))
                ALERT.addAction(UIAlertAction(title: "동의", style: .default, handler: { _ in S_INDICATOR(self.view)
                    UserDefaults.standard.setValue(true, forKey: "payment_agree")
                    InAppProducts.store.requestProducts { success, products in
                        if success, let product = products?[sender.tag] { InAppProducts.store.buyProduct(product) }
                    }
                }))
                ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
                    S_INDICATOR(self.view, animated: false)
                }))
                present(ALERT, animated: true, completion: nil)
            }
        } else { S_INDICATOR(view)
            InAppProducts.store.requestProducts { success, products in
                if success { InAppProducts.store.restorePurchases() }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(true)
    }
}
