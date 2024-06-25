//
//  VC_LEGOPANGPANG.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/20.
//

import UIKit

class VC_LEGOPANGPANG: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var DOWN_UP: Bool = false
    var TOUCH = false
    
    var OBJ_STORE: [API_STORE] = []
    var OBJ_COUPON: [API_COUPON] = []
    var OBJ_POSITION: Int = 0
    
    @IBAction func BACK_B(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var BACKGROUND_V: UIView!
    @IBOutlet weak var COUPON_I: UIImageView!
    @IBOutlet weak var COUPON_L: UILabel!
    @IBOutlet weak var COUPON_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_LEGOPANGPANG_DEL = self
        
        BACKGROUND_V.roundShadows(color: .black, offset: CGSize(width: 0, height: 5), opcity: 0.1, radius1: 5, radius2: 12.5)
        
        if !DOWN_UP && (OBJ_STORE.count > 0) {
            
            let DATA = OBJ_STORE[OBJ_POSITION]
            
            NUKE(IV: COUPON_I, IU: DATA.PP_IMAGE, PH: UIImage(), RD: 5, CM: .scaleAspectFill)
            COUPON_L.text = "\(DATA.PP_MENU) 무료쿠폰"
            COUPON_B.isHidden = false
        } else if DOWN_UP && (OBJ_COUPON.count > 0) {
            
            let USER = UIViewController.appDelegate.OBJ_USER
            let DATA = OBJ_COUPON[OBJ_POSITION]
            
            if USER.NAME != "" {
                COUPON_I.image = S_QRCODE("\(DATA.USE_STORE_ID)|}{\(USER.NUMBER)|}{\(USER.ID)|}{\(USER.NAME)|}{\(DATA.RECEIVE_TIME)")
            } else {
                COUPON_I.image = S_QRCODE("\(DATA.USE_STORE_ID)|}{\(USER.NUMBER)|}{\(USER.ID)|}{\(USER.NICK)|}{\(DATA.RECEIVE_TIME)")
            }
            
            COUPON_L.text = "\(DATA.PP_MENU) 무료쿠폰"
            COUPON_B.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        COUPON_B.addTarget(self, action: #selector(COUPON_B(_:)), for: .touchUpInside)
    }
    
    @objc func COUPON_B(_ sender: UIButton) {
        if TOUCH { return }; TOUCH = true; PUT_LEGOPANGPANG(NAME: "쿠폰발급", AC_TYPE: "coupon")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIViewController.VC_LEGOPANGPANG_DEL = nil
    }
}
