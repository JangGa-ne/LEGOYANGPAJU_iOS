//
//  VC_FINDPW.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2023/01/01.
//

import UIKit

class VC_FINDPW: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var TYPE: String = ""
    
    @IBOutlet weak var NAVI_L: UILabel!
    @IBOutlet weak var LINE_V: UIView!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    @IBOutlet weak var FIND_SV: UIStackView!
    
    @IBOutlet weak var CHECK_V1: UIView!
    @IBOutlet weak var CHECK_I1: UIImageView!
    @IBOutlet weak var CHECK_L1: UILabel!
    @IBOutlet weak var PHONE_V: UIView!
    @IBOutlet weak var NAME_TF1: UITextField!
    @IBOutlet weak var SIGN_TF1: UITextField!
    @IBOutlet weak var SIGN_B1: UIButton!
    
    @IBOutlet weak var CHECK_V2: UIView!
    @IBOutlet weak var CHECK_I2: UIImageView!
    @IBOutlet weak var CHECK_L2: UILabel!
    @IBOutlet weak var EMAIL_V: UIView!
    @IBOutlet weak var NAME_TF2: UITextField!
    @IBOutlet weak var SIGN_TF2: UITextField!
    @IBOutlet weak var SIGN_B2: UIButton!
    @IBOutlet weak var NUMBER_TF2: UITextField!
    @IBOutlet weak var NUMBER_B2: UIButton!
    
    @IBOutlet weak var PW_SV: UIStackView!
    @IBOutlet weak var PW_TF1: UITextField!
    @IBOutlet weak var PW_TF2: UITextField!
    @IBOutlet weak var PW_L2: UILabel!
    @IBOutlet weak var SUBMIT_SV: UIStackView!
    @IBOutlet weak var SUBMIT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        S_KEYBOARD()
        
        NAVI_L.alpha = 0.0; LINE_V.alpha = 0.0
        
        PHONE_V.isHidden = true; EMAIL_V.isHidden = true
        
        NAME_TF1.placeholder("이름", COLOR: .lightGray)
        SIGN_TF1.placeholder("휴대전화", COLOR: .lightGray)
        NAME_TF2.placeholder("이름", COLOR: .lightGray)
        SIGN_TF2.placeholder("이메일", COLOR: .lightGray)
        NUMBER_TF2.placeholder("인증번호", COLOR: .lightGray)
        
        PW_SV.isHidden = true; PW_L2.isHidden = true; SUBMIT_SV.isHidden = true
        
        PW_TF1.placeholder("새로운 비밀번호", COLOR: .lightGray)
        PW_TF2.placeholder("새로운 비밀번호 확인", COLOR: .lightGray)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCROLLVIEW.delegate = self
        
        CHECK_V1.tag = 0; CHECK_V1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CHECK_V(_:))))
        SIGN_B1.tag = 0; SIGN_B1.addTarget(self, action: #selector(SIGNCHECK_B(_:)), for: .touchUpInside)
        
        CHECK_V2.tag = 1; CHECK_V2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CHECK_V(_:))))
        SIGN_B2.tag = 0; SIGN_B2.addTarget(self, action: #selector(SIGNCHECK_B(_:)), for: .touchUpInside)
        NUMBER_B2.tag = 1; NUMBER_B2.addTarget(self, action: #selector(SIGNCHECK_B(_:)), for: .touchUpInside)
        
        PW_TF2.addTarget(self, action: #selector(PW_TF2(_:)), for: .editingChanged)
        
        SUBMIT_B.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
    }
    
    @objc func CHECK_V(_ sender: UITapGestureRecognizer) {
        
        if sender.view!.tag == 0 {
            CHECK_V1.backgroundColor = .H_00529C.withAlphaComponent(0.5); CHECK_I1.image = UIImage(named: "check_on.png"); CHECK_L1.textColor = .white
            CHECK_V2.backgroundColor = .H_F1F1F1; CHECK_I2.image = UIImage(named: "check_off.png"); CHECK_L2.textColor = .black
            TYPE = "phone"; PHONE_V.isHidden = false; EMAIL_V.isHidden = true
        } else if sender.view!.tag == 1 {
            CHECK_V1.backgroundColor = .H_F1F1F1; CHECK_I1.image = UIImage(named: "check_off.png"); CHECK_L1.textColor = .black
            CHECK_V2.backgroundColor = .H_00529C.withAlphaComponent(0.5); CHECK_I2.image = UIImage(named: "check_on.png"); CHECK_L2.textColor = .white
            TYPE = "email"; PHONE_V.isHidden = true; EMAIL_V.isHidden = false
        }
    }
    
    @objc func SIGNCHECK_B(_ sender: UIButton) {
        
        NAME_TF1.resignFirstResponder(); SIGN_TF1.resignFirstResponder(); NAME_TF2.resignFirstResponder(); SIGN_TF2.resignFirstResponder(); NUMBER_TF2.resignFirstResponder()
        
        if sender.tag == 0 && TYPE == "phone" {
            if NAME_TF1.text == "" {
                S_NOTICE("이름 (!)")
            } else if SIGN_TF1.text == "" {
                S_NOTICE("휴대전화 (!)")
            } else {
                PUT_BOOTPAY(NAME: "휴대전화 본인인증", AC_TYPE: "", US_PHONE: SIGN_TF1.text!)
            }
        } else if sender.tag == 1 && TYPE == "phone" {
            
        } else if sender.tag == 0 && TYPE == "email" {
            if NAME_TF2.text == "" {
                S_NOTICE("이름 (!)")
            } else if SIGN_TF2.text == "" {
                S_NOTICE("이메일 (!)")
            } else {
                PUT_EMAIL(NAME: "이메일 본인인증", AC_TYPE: "")
            }
        } else if sender.tag == 1 && TYPE == "email" {
            if NAME_TF2.text == "" {
                S_NOTICE("이름 (!)")
            } else if SIGN_TF2.text == "" {
                S_NOTICE("이메일 (!)")
            } else if NUMBER_TF2.text == "" {
                S_NOTICE("인증번호 (!)")
            } else if UserDefaults.standard.string(forKey: "emailcheck") ?? "" != SIGN_TF2.text!+NUMBER_TF2.text! {
                S_NOTICE("본인인증 (!)")
            } else {
                S_NOTICE("본인인증 확인됨"); S_INDICATOR(view, text: "등록된 회원정보 찾는중..."); GET_USER(NAME: "회원정보 검색", AC_TYPE: "store")
            }
        }
    }
    
    @objc func PW_TF2(_ sender: UITextField) {
        if PW_TF1.text! != PW_TF2.text! { PW_L2.isHidden = false } else { PW_L2.isHidden = true }
    }
    
    @objc func SUBMIT_B(_ sender: UIButton) {
        
        PW_TF1.resignFirstResponder(); PW_TF2.resignFirstResponder()
        
        if PW_TF1.text! == "" {
            S_NOTICE("새로운 비밀번호 (!)")
        } else if PW_TF1.text! != PW_TF2.text! {
            S_NOTICE("새로운 비밀번호 확인 (!)")
        } else {
            SET_PASSWORD(NAME: "비밀번호 변경", AC_TYPE: "store")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
        
        if TYPE == "phone" && UserDefaults.standard.bool(forKey: "phonecheck") { S_INDICATOR(view, text: "등록된 회원정보 찾는중..."); GET_USER(NAME: "회원정보 검색", AC_TYPE: "store") }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UserDefaults.standard.removeObject(forKey: "phonecheck")
        UserDefaults.standard.removeObject(forKey: "emailcheck")
        UserDefaults.standard.removeObject(forKey: "document")
    }
}

extension VC_FINDPW: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        if OFFSET_Y > 30 { NAVI_L.alpha = OFFSET_Y/30; LINE_V.alpha = 0.05 } else { NAVI_L.alpha = 0.0; LINE_V.alpha = 0.0 }
    }
}
