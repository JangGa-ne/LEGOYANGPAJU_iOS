//
//  VC_FIND.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2023/01/01.
//

import UIKit

class VC_FIND: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var FIND_TYPE: String = "id"
    var SIGN_TYPE: String = ""
    
    @IBOutlet weak var HEADER_L: UILabel!
    @IBOutlet weak var LINE_V: UIView!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    @IBOutlet weak var TITLE_L: UILabel!
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
    
    @IBOutlet weak var ID_L: UILabel!
    @IBOutlet weak var PW_SV: UIStackView!
    @IBOutlet weak var PW_TF1: UITextField!
    @IBOutlet weak var PW_TF2: UITextField!
    @IBOutlet weak var PW_L2: UILabel!
    @IBOutlet weak var SUBMIT_SV: UIStackView!
    @IBOutlet weak var SUBMIT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        setKeyboard()
        
        HEADER_L.alpha = 0.0; LINE_V.alpha = 0.0
        
        if FIND_TYPE == "id" {
            TITLE_L.text = "아이디를 찾을 방법을 선택해 주세요."
        } else if FIND_TYPE == "pw" {
            TITLE_L.text = "비밀번호를 찾을 방법을 선택해 주세요."
        }
        PHONE_V.isHidden = true; EMAIL_V.isHidden = true
        
        NAME_TF1.placeholder("이름", COLOR: .lightGray)
        SIGN_TF1.placeholder("휴대전화", COLOR: .lightGray)
        NAME_TF2.placeholder("이름", COLOR: .lightGray)
        SIGN_TF2.placeholder("이메일", COLOR: .lightGray)
        NUMBER_TF2.placeholder("인증번호", COLOR: .lightGray)
        
        ID_L.isHidden = true; PW_SV.isHidden = true; PW_L2.isHidden = true; SUBMIT_SV.isHidden = true
        
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
            CHECK_V1.backgroundColor = .H_00529C.withAlphaComponent(0.5); CHECK_I1.image = UIImage(named: "check_on2"); CHECK_L1.textColor = .white
            CHECK_V2.backgroundColor = .H_F1F1F1; CHECK_I2.image = UIImage(named: "check_off"); CHECK_L2.textColor = .black
            SIGN_TYPE = "phone"; PHONE_V.isHidden = false; EMAIL_V.isHidden = true
        } else if sender.view!.tag == 1 {
            CHECK_V1.backgroundColor = .H_F1F1F1; CHECK_I1.image = UIImage(named: "check_off"); CHECK_L1.textColor = .black
            CHECK_V2.backgroundColor = .H_00529C.withAlphaComponent(0.5); CHECK_I2.image = UIImage(named: "check_on2"); CHECK_L2.textColor = .white
            SIGN_TYPE = "email"; PHONE_V.isHidden = true; EMAIL_V.isHidden = false
        }
    }
    
    @objc func SIGNCHECK_B(_ sender: UIButton) {
        
        NAME_TF1.resignFirstResponder(); SIGN_TF1.resignFirstResponder(); NAME_TF2.resignFirstResponder(); SIGN_TF2.resignFirstResponder(); NUMBER_TF2.resignFirstResponder()
        
        if sender.tag == 0 && SIGN_TYPE == "phone" {
            if NAME_TF1.text == "" {
                S_NOTICE("이름 (!)")
            } else if SIGN_TF1.text == "" {
                S_NOTICE("휴대전화 (!)")
            } else {
                S_INDICATOR(view, text: "등록된 회원정보 찾는중..."); GET_USER(NAME: "회원정보 검색", AC_TYPE: "member")
            }
        } else if sender.tag == 1 && SIGN_TYPE == "phone" {
            
        } else if sender.tag == 0 && SIGN_TYPE == "email" {
            if NAME_TF2.text == "" {
                S_NOTICE("이름 (!)")
            } else if SIGN_TF2.text == "" {
                S_NOTICE("이메일 (!)")
            } else {
                S_INDICATOR(view, text: "등록된 회원정보 찾는중..."); GET_USER(NAME: "회원정보 검색", AC_TYPE: "member")
            }
        } else if sender.tag == 1 && SIGN_TYPE == "email" {
            if NAME_TF2.text == "" {
                S_NOTICE("이름 (!)")
            } else if SIGN_TF2.text == "" {
                S_NOTICE("이메일 (!)")
            } else if NUMBER_TF2.text == "" {
                S_NOTICE("인증번호 (!)")
            } else if UserDefaults.standard.string(forKey: "emailcheck") ?? "" != SIGN_TF2.text!+NUMBER_TF2.text! {
                S_NOTICE("본인인증 (!)")
            } else {
                S_NOTICE("본인인증 확인됨"); self.FIND_SV.isHidden = true
                if FIND_TYPE == "id" {
                    self.ID_L.isHidden = false
                } else if FIND_TYPE == "pw" {
                    self.PW_SV.isHidden = false; self.SUBMIT_SV.isHidden = false
                }
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
            SET_PASSWORD(NAME: "비밀번호 변경", AC_TYPE: "member")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
        
        if UserDefaults.standard.bool(forKey: "phonecheck") { self.FIND_SV.isHidden = true
            if FIND_TYPE == "id" {
                self.ID_L.isHidden = false
            } else if FIND_TYPE == "pw" {
                self.PW_SV.isHidden = false; self.SUBMIT_SV.isHidden = false
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UserDefaults.standard.removeObject(forKey: "phonecheck")
        UserDefaults.standard.removeObject(forKey: "emailcheck")
    }
}

extension VC_FIND: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        if OFFSET_Y > 30 { HEADER_L.alpha = OFFSET_Y/30; LINE_V.alpha = 0.05 } else { HEADER_L.alpha = 0.0; LINE_V.alpha = 0.0 }
    }
}
