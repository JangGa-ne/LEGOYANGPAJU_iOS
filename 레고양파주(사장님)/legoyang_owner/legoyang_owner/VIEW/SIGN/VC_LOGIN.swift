//
//  VC_LOGIN.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/11/15.
//

import UIKit

class VC_LOGIN: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var ID_TF: UITextField!
    @IBOutlet weak var PW_TF: UITextField!
    @IBOutlet weak var LOGIN_B: UIButton!
    @IBOutlet weak var VC_FIND_B: UIButton!
    @IBOutlet weak var VC_JOIN_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        S_KEYBOARD()
        
        // 데이터 초기화
        UIViewController.AD.LISTENER = nil
        UserDefaults.standard.setValue(true, forKey: "first")
        UserDefaults.standard.removeObject(forKey: "store_id")
        UserDefaults.standard.removeObject(forKey: "store_category")
        UserDefaults.standard.removeObject(forKey: "payment_agree")
        UserDefaults.standard.removeObject(forKey: "waiting_step")
        UserDefaults.standard.removeObject(forKey: "use_pangpang")
        
        ID_TF.placeholder("휴대전화", COLOR: .white.withAlphaComponent(0.7))
        PW_TF.placeholder("비밀번호", COLOR: .white.withAlphaComponent(0.7))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LOGIN_B.addTarget(self, action: #selector(LOGIN_B(_:)), for: .touchUpInside)
        
        VC_FIND_B.addTarget(self, action: #selector(VC_FIND_B(_:)), for: .touchUpInside)
        VC_JOIN_B.addTarget(self, action: #selector(VC_JOIN_B(_:)), for: .touchUpInside)
    }
    
    @objc func LOGIN_B(_ sender: UIButton) {
        if ID_TF.text! == "" {
            S_NOTICE("아이디 (!)")
        } else if PW_TF.text! == "" {
            S_NOTICE("비밀번호 (!)")
        } else {
            ID_TF.resignFirstResponder(); PW_TF.resignFirstResponder(); LOGIN_B.isHidden = true; S_INDICATOR(view, text: "로그인 중...")
            GET_LOGIN(NAME: "로그인", AC_TYPE: "store")
        }
    }
    
    @objc func VC_FIND_B(_ sender: UIButton) {
        segueViewController(identifier: "VC_FINDPW")
    }
    
    @objc func VC_JOIN_B(_ sender: UIButton) {
        segueViewController(identifier: "VC_INFO")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
    }
}
