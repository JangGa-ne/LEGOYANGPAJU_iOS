//
//  VC_SIGNUP.swift
//  legoyang
//
//  Created by 장 제현 on 2022/09/17.
//

import UIKit

class VC_SIGNUP: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var DATE_DATA: String = ""
    var PROFILE_IMG: String = ""
    var TYPE: String = "lego"
    
    @IBOutlet weak var HEADER_L: UILabel!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    @IBOutlet weak var ID_TF: UITextField!
    @IBOutlet weak var VC_POPUP1_B1: UIButton!
    @IBOutlet weak var PW_TF1: UITextField!
    @IBOutlet weak var PW_TF2: UITextField!
    @IBOutlet weak var PW_L2: UILabel!
    @IBOutlet weak var NAME_TF: UITextField!
    @IBOutlet weak var NICK_TF: UITextField!
    @IBOutlet weak var BIRTH_TF: UITextField!
    @IBOutlet weak var VC_POPUP1_B2: UIButton!
    @IBOutlet weak var MALE_B: UIButton!
    @IBOutlet weak var FEMALE_B: UIButton!
    @IBOutlet weak var EMAIL_TF: UITextField!
    @IBOutlet weak var PHONE_TF: UITextField!
    @IBOutlet weak var PHONE_B: UIButton!
    @IBOutlet weak var VC_POPUP1_B3: UIButton!
    @IBOutlet weak var SIGNUP_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_SIGNUP_DEL = self
        
        setKeyboard()
        
        HEADER_L.alpha = 0.0
        
        ID_TF.placeholder("아이디", COLOR: .lightGray)
        PW_TF1.placeholder("비밀번호", COLOR: .lightGray)
        PW_TF2.placeholder("비밀번호 확인", COLOR: .lightGray)
        PW_L2.isHidden = true
        NAME_TF.placeholder("이름", COLOR: .lightGray)
        NICK_TF.placeholder("닉네임", COLOR: .lightGray)
        BIRTH_TF.placeholder("생년월일", COLOR: .lightGray)
        EMAIL_TF.placeholder("이메일", COLOR: .lightGray)
        PHONE_TF.placeholder("전화번호", COLOR: .lightGray)
        
//        if UIViewController.appDelegate.OBJ_VIRTUAL_USER.TYPE != "lego" {
//            
//            let DATA = UIViewController.appDelegate.OBJ_VIRTUAL_USER
//            let RANDOM_PW = String((0..<15).compactMap{ _ in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()_+".randomElement() })
//            
//            ID_TF.text = DATA.EMAIL
//            PW_TF1.text = RANDOM_PW
//            PW_TF2.text = RANDOM_PW
//            NAME_TF.text = DATA.NAME
//            NICK_TF.text = DATA.NICK
//            EMAIL_TF.text = DATA.EMAIL
//            PROFILE_IMG = DATA.IMG
//            TYPE = DATA.TYPE
//            
//            if UIViewController.appDelegate.OBJ_VIRTUAL_USER.TYPE == "apple" { ID_TF.text = DATA.USER }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCROLLVIEW.delegate = self
        
//        if UIViewController.appDelegate.OBJ_VIRTUAL_USER.TYPE != "lego" {
//
//            ID_TF.isUserInteractionEnabled = false
//            PW_TF1.isUserInteractionEnabled = false
//            PW_TF2.isUserInteractionEnabled = false
//        } else {
            
            VC_POPUP1_B1.tag = 0; VC_POPUP1_B1.addTarget(self, action: #selector(VC_POPUP1_B(_:)), for: .touchUpInside)
            VC_POPUP1_B2.tag = 1; VC_POPUP1_B2.addTarget(self, action: #selector(VC_POPUP1_B(_:)), for: .touchUpInside)
            
            PW_TF1.tag = 0; PW_TF1.addTarget(self, action: #selector(TEXTFIELD(_:)), for: .editingChanged)
            PW_TF2.tag = 1; PW_TF2.addTarget(self, action: #selector(TEXTFIELD(_:)), for: .editingChanged)
            
            MALE_B.tag = 0; MALE_B.addTarget(self, action: #selector(GENDER_B(_:)), for: .touchUpInside)
            FEMALE_B.tag = 1; FEMALE_B.addTarget(self, action: #selector(GENDER_B(_:)), for: .touchUpInside)
            
            ID_TF.isUserInteractionEnabled = true
            PW_TF1.isUserInteractionEnabled = true
            PW_TF2.isUserInteractionEnabled = true
//        }
        
        PHONE_TF.tag = 2; PHONE_TF.addTarget(self, action: #selector(TEXTFIELD(_:)), for: .editingChanged)
        PHONE_B.addTarget(self, action: #selector(PHONE_B(_:)), for: .touchUpInside)
        VC_POPUP1_B3.tag = 2; VC_POPUP1_B3.addTarget(self, action: #selector(VC_POPUP1_B(_:)), for: .touchUpInside)
        
        SIGNUP_B.addTarget(self, action: #selector(SIGNUP_B(_:)), for: .touchUpInside)
    }
    
    @objc func TEXTFIELD(_ sender: UITextField) {
        if sender.tag == 0 {
            PW_TF2.text!.removeAll(); PW_L2.isHidden = true
        } else if sender.tag == 1 {
            if PW_TF1.text! != PW_TF2.text! { PW_L2.isHidden = false } else { PW_L2.isHidden = true }
        } else if sender.tag == 2 {
            if UserDefaults.standard.bool(forKey: "phonecheck") { sender.text?.removeAll(); UserDefaults.standard.removeObject(forKey: "phonecheck") }
        }
    }
    
    @objc func VC_POPUP1_B(_ sender: UIButton) {
        
        for TF in [ID_TF, PW_TF1, PW_TF2, NAME_TF, BIRTH_TF, EMAIL_TF, PHONE_TF] { TF?.resignFirstResponder() }
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_POPUP1") as! VC_POPUP1
        VC.modalPresentationStyle = .overCurrentContext; VC.transitioningDelegate = self
        if sender.tag == 0 {
            VC.TYPE = "id"
        } else if sender.tag == 1 {
            VC.TYPE = "birth"
        } else if sender.tag == 2 {
            VC.TYPE = "phone"
        }
        present(VC, animated: true, completion: nil)
    }
    
    @objc func PHONE_B(_ sender: UIButton) {
        
        for TF in [ID_TF, PW_TF1, PW_TF2, NAME_TF, BIRTH_TF, EMAIL_TF, PHONE_TF] { TF?.resignFirstResponder() }
        
        if (PHONE_TF.text == "") || ((PHONE_TF.text?.count ?? 0) != 11) {
            S_NOTICE("휴대전화 (!)")
        } else {
            PUT_BOOTPAY1(NAME: "본인인증", AC_TYPE: "bootpay", US_PHONE: PHONE_TF.text!)
        }
    }
    
    @objc func GENDER_B(_ sender: UIButton) {
        
        if sender.tag == 0 {
            if !MALE_B.isSelected {
                MALE_B.isSelected = true; MALE_B.backgroundColor = .H_00529C
                FEMALE_B.isSelected = false; FEMALE_B.backgroundColor = .darkGray
            } else {
                MALE_B.isSelected = false; MALE_B.backgroundColor = .darkGray
            }
        } else if sender.tag == 1 {
            if !FEMALE_B.isSelected {
                MALE_B.isSelected = false; MALE_B.backgroundColor = .darkGray
                FEMALE_B.isSelected = true; FEMALE_B.backgroundColor = .H_00529C
            } else {
                FEMALE_B.isSelected = false; FEMALE_B.backgroundColor = .darkGray
            }
        }
    }
    
    @objc func SIGNUP_B(_ sender: UIButton) {
        
        if ID_TF.text! == "" {
            S_NOTICE("아이디 (!)")
        } else if PW_TF1.text! == "" {
            S_NOTICE("비밀번호 (!)")
        } else if (PW_TF2.text! == "") || !(PW_L2.isHidden) {
            S_NOTICE("비밀번호 확인 (!)")
        } else if NAME_TF.text! == "" {
            S_NOTICE("이름 (!)")
        } else if NICK_TF.text! == "" {
            S_NOTICE("닉네임 (!)")
        } else if (EMAIL_TF.text! == "") || !(EMAIL_TF.text!.contains("@")) || !(EMAIL_TF.text!.contains(".")) {
            S_NOTICE("이메일 (!)")
        } else if (PHONE_TF.text! == "") || !UserDefaults.standard.bool(forKey: "phonecheck") {
            S_NOTICE("휴대전화 (!)")
        } else {
            PUT_SIGNUP(NAME: "회원가입", AC_TYPE: "member")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
        
        if !UserDefaults.standard.bool(forKey: "phonecheck") { PHONE_TF.text?.removeAll() }
    }
}

extension VC_SIGNUP: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let OFFSET_Y = scrollView.contentOffset.y
        if OFFSET_Y > 35 { HEADER_L.alpha = (OFFSET_Y-35)/35 } else { HEADER_L.alpha = 0.0 }
    }
}

