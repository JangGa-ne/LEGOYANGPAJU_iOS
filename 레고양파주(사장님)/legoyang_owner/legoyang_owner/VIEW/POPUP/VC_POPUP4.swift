//
//  VC_POPUP4.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/27.
//

import UIKit

class VC_POPUP4: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    @IBAction func BACK_B(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var NAVI_L: UILabel!
    @IBOutlet weak var PW_TF1: UITextField!
    @IBOutlet weak var PW_L1: UILabel!
    @IBOutlet weak var PW_TF2: UITextField!
    @IBOutlet weak var PW_TF3: UITextField!
    @IBOutlet weak var PW_L3: UILabel!
    
    @IBOutlet weak var SUBMIT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        S_KEYBOARD()
        
        PW_L1.isHidden = true; PW_L3.isHidden = true
        
        PW_TF1.placeholder("기존 비밀번호", COLOR: .lightGray)
        PW_TF2.placeholder("새로운 비밀번호", COLOR: .lightGray)
        PW_TF3.placeholder("새로운 비밀번호 확인", COLOR: .lightGray)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PW_TF1.addTarget(self, action: #selector(PW_TF(_:)), for: .editingChanged)
        PW_TF3.addTarget(self, action: #selector(PW_TF(_:)), for: .editingChanged)
        
        SUBMIT_B.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
    }
    
    @objc func PW_TF(_ sender: UITextField) {
        
        if sender == PW_TF1 {
            if UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storePassword != PW_TF1.text! { PW_L1.isHidden = false } else { PW_L1.isHidden = true }
        } else if sender == PW_TF3 {
            if PW_TF2.text! != PW_TF3.text! { PW_L3.isHidden = false } else { PW_L3.isHidden = true }
        }
    }
    
    @objc func SUBMIT_B(_ sender: UIButton) {
        
        PW_TF1.resignFirstResponder(); PW_TF2.resignFirstResponder(); PW_TF3.resignFirstResponder()
        
        if (PW_TF1.text! == "") || !PW_L1.isHidden {
            S_NOTICE("기존 비밀번호 (!)")
        } else if (PW_TF2.text! == "") {
            S_NOTICE("새로운 비밀번호 (!)")
        } else if (PW_TF2.text! == "") {
            S_NOTICE("새로운 비밀번호 확인 (!)")
        } else {
            SET_PASSWORD(NAME: "비밃번호 변경", AC_TYPE: "store")
        }
    }
}
