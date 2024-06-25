//
//  VC_SETTING.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/13.
//

import UIKit

class VC_SETTING: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBOutlet weak var NAVI_L: UILabel!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var LINE_V: UIView!
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    @IBOutlet weak var NAME_L: UILabel!
    @IBOutlet weak var BIRTH_L: UILabel!
    @IBOutlet weak var PHONE_L: UILabel!
    @IBOutlet weak var CATEGORY_L: UILabel!
    @IBOutlet weak var EMAIL_L: UILabel!
    @IBOutlet weak var PW_TF: UITextField!
    @IBOutlet weak var VC_POPUP4_B: UIButton!
    
    @IBOutlet weak var PW_TF1: UITextField!
    @IBOutlet weak var PW_L1: UILabel!
    @IBOutlet weak var CHECK_B: UIButton!
    @IBOutlet weak var PW_SV: UIStackView!
    @IBOutlet weak var PW_TF2: UITextField!
    @IBOutlet weak var PW_TF3: UITextField!
    @IBOutlet weak var PW_L3: UILabel!
    @IBOutlet weak var SUBMIT_B: UIButton!
    
    @IBOutlet weak var MG_NAME_TF: UITextField!
    @IBOutlet weak var MG_PHONE_TF: UITextField!
    @IBOutlet weak var EDIT_B: UIButton!
    
    @IBOutlet weak var LOGOUT_B: UIButton!
    @IBOutlet weak var WITHDRAWAL_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_SETTING_DEL = self
        
        S_KEYBOARD()
        
        NAVI_L.alpha = 0.0; LINE_V.alpha = 0.0
        
        PW_L1.isHidden = true; PW_SV.isHidden = true; PW_L3.isHidden = true
        
//        PW_TF.placeholder("비밀번호 변경", COLOR: .lightGray)
        PW_TF1.placeholder("기존 비밀번호", COLOR: .lightGray)
        PW_TF2.placeholder("새로운 비밀번호", COLOR: .lightGray)
        PW_TF3.placeholder("새로운 비밀번호 확인", COLOR: .lightGray)
        MG_NAME_TF.placeholder("담당자명", COLOR: .lightGray)
        MG_PHONE_TF.placeholder("담당자 연락처", COLOR: .lightGray)
        
        let DATA = UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row]
        
        NAME_L.text = DATA.ownerName
        BIRTH_L.text = FM_CUSTOM(DATA.ownerBirth, "yy. MM. dd")
        PHONE_L.text = NUMBER("phone", DATA.ownerNumber)
        CATEGORY_L.text = DATA.storeCategory
        EMAIL_L.text = DATA.storeEmail
        
        MG_NAME_TF.text = DATA.managerName
        MG_PHONE_TF.text = DATA.managerNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCROLLVIEW.delegate = self
        
//        VC_POPUP4_B.addTarget(self, action: #selector(VC_POPUP4_B(_:)), for: .touchUpInside)
        CHECK_B.addTarget(self, action: #selector(CHECK_B(_:)), for: .touchUpInside)
        PW_TF3.addTarget(self, action: #selector(PW_TF(_:)), for: .editingChanged)
        SUBMIT_B.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
        
        EDIT_B.addTarget(self, action: #selector(EDIT_B(_:)), for: .touchUpInside)
        
        LOGOUT_B.addTarget(self, action: #selector(LOGOUT_B(_:)), for: .touchUpInside)
        WITHDRAWAL_B.addTarget(self, action: #selector(WITHDRAWAL_B(_:)), for: .touchUpInside)
    }
    
    @objc func VC_POPUP4_B(_ sender: UIButton) {
        
        MG_NAME_TF.resignFirstResponder(); MG_PHONE_TF.resignFirstResponder()
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_POPUP4") as! VC_POPUP4
        VC.modalPresentationStyle = .overCurrentContext; VC.transitioningDelegate = self
        present(VC, animated: true, completion: nil)
    }
    
    @objc func PW_TF(_ sender: UITextField) {
        if PW_TF2.text! != PW_TF3.text! { PW_L3.isHidden = false } else { PW_L3.isHidden = true }
    }
    
    @objc func CHECK_B(_ sender: UIButton) {
        
        PW_TF1.resignFirstResponder(); PW_TF2.resignFirstResponder(); PW_TF3.resignFirstResponder()
        
        if UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storePassword != PW_TF1.text! { PW_L1.isHidden = false; PW_SV.isHidden = true } else { PW_L1.isHidden = true; PW_SV.isHidden = false; S_NOTICE("비밀번호 확인됨") }
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
    
    @objc func EDIT_B(_ sender: UIButton) {
        
        MG_NAME_TF.resignFirstResponder(); MG_PHONE_TF.resignFirstResponder()
        
        if MG_NAME_TF.text! == "" {
            S_NOTICE("담당자명 (!)")
        } else if MG_PHONE_TF.text! == "" {
            S_NOTICE("담당자 연락처 (!)")
        } else {
            PUT_MANAGER(NAME: "담당자수정", AC_TYPE: "store")
        }
    }
    
    @objc func LOGOUT_B(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: "", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        ALERT.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { _ in
            self.S_NOTICE("로그아웃됨")
            UserDefaults.standard.removeObject(forKey: "store_id")
            self.segueViewController(identifier: "VC_LOADING")
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(ALERT, animated: true, completion: nil)
    }
    
    @objc func WITHDRAWAL_B(_ sender: UIButton) {
        segueViewController(identifier: "VC_WITHDRAWAL")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(true)
    }
}

extension VC_SETTING: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        if OFFSET_Y > 30 { NAVI_L.alpha = OFFSET_Y/30; LINE_V.alpha = 0.05 } else { NAVI_L.alpha = 0.0; LINE_V.alpha = 0.0 }
    }
}
