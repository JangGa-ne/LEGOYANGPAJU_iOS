//
//  VC_POPUP1.swift
//  nslab
//
//  Created by 장 제현 on 2022/09/17.
//

import UIKit

class VC_POPUP1: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    var TYPE: String = "id"
    var DATE_DATA: String = ""
    var DATE: String = ""
    var SIGN: Bool = false
    
    @IBAction func BACK_B(_ sender: UIButton) { SIGN_TF.resignFirstResponder(); NUMBER_TF.resignFirstResponder(); dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var HEADER_L: UILabel!
    @IBOutlet weak var CUSTOM_SV1: UIStackView!
    @IBOutlet weak var SIGN_SV: UIStackView!
    @IBOutlet weak var SIGN_I: UIImageView!
    @IBOutlet weak var SIGN_TF: UITextField!
    @IBOutlet weak var SIGN_B: UIButton!
    @IBOutlet weak var NUMBER_SV: UIStackView!
    @IBOutlet weak var NUMBER_TF: UITextField!
    @IBOutlet weak var NUMBER_B: UIButton!
    @IBOutlet weak var BIRTH_DP: UIDatePicker!
    @IBOutlet weak var SUBMIT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        setKeyboard()
        
        if TYPE == "id" {
            CUSTOM_SV1.isHidden = false; SIGN_SV.isHidden = false; NUMBER_SV.isHidden = true; BIRTH_DP.isHidden = true
            HEADER_L.text = "아이디 중복확인"
            SIGN_I.image = UIImage(named: "login_email.png"); SIGN_TF.placeholder("아이디", COLOR: .lightGray); SIGN_TF.keyboardType = .emailAddress; SIGN_B.setTitle("중복확인", for: .normal)
        } else if TYPE == "birth" {
            CUSTOM_SV1.isHidden = true; SIGN_SV.isHidden = true; NUMBER_SV.isHidden = true; BIRTH_DP.isHidden = false
            HEADER_L.text = "생년월일"
            SIGN = true; DATE = FM_CUSTOM("\(Date())", "yy. MM. dd")
            if #available(iOS 13.0, *) { BIRTH_DP.overrideUserInterfaceStyle = .light }; BIRTH_DP.maximumDate = Date()
        } else if TYPE == "phone" {
            CUSTOM_SV1.isHidden = false; SIGN_SV.isHidden = false; NUMBER_SV.isHidden = false; BIRTH_DP.isHidden = true
            HEADER_L.text = "휴대전화 본인인증"
            SIGN_I.image = UIImage(named: "login_phone.png"); SIGN_TF.placeholder("전화번호", COLOR: .lightGray); SIGN_TF.keyboardType = .phonePad; SIGN_B.setTitle("인증요청", for: .normal)
        }
        NUMBER_TF.placeholder("인증번호", COLOR: .lightGray)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SIGN_B.tag = 0; SIGN_B.addTarget(self, action: #selector(SIGNCHECK_B(_:)), for: .touchUpInside)
        NUMBER_B.tag = 1; NUMBER_B.addTarget(self, action: #selector(SIGNCHECK_B(_:)), for: .touchUpInside)
        
        BIRTH_DP.addTarget(self, action: #selector(BIRTH_DP(_:)), for: .valueChanged)
        
        SUBMIT_B.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
    }
    
    @objc func SIGNCHECK_B(_ sender: UIButton) {
        
        if (sender.tag == 0) && (TYPE == "id") {
            if SIGN_TF.text! == "" { S_NOTICE("아이디 (!)") } else { PUT_ID(NAME: "아이디 중복확인", AC_TYPE: "member") }
        } else if (sender.tag == 0) && (TYPE == "phone") {
            if SIGN_TF.text! == "" { S_NOTICE("휴대전화 (!)") } else { GET_PHONE(NAME: "휴대전화 인증요청", AC_TYPE: "phone") }
        } else if (sender.tag == 1) && (TYPE == "phone") {
            if (SIGN_TF.text! == "") || (NUMBER_TF.text! == "") { S_NOTICE("인증번호 (!)") } else { PUT_NUMBER(NAME: "휴대전화 인증확인", AC_TYPE: "phone") }
        }
    }
    
    @objc func BIRTH_DP(_ sender: UIDatePicker) {
        let DF = DateFormatter()
        DF.dateFormat = "yy. MM. dd"; DATE = DF.string(from: sender.date)
        DF.dateFormat = "yyyyMMdd"; DATE_DATA = DF.string(from: sender.date)
    }
    
    @objc func SUBMIT_B(_ sender: UIButton) {
        
        if !SIGN {
            if TYPE == "id" {
                S_NOTICE("아이디 (!)")
            } else if TYPE == "phone" {
                S_NOTICE("휴대전화 (!)")
            }
        } else {
            if let BVC = UIViewController.VC_SIGNUP_DEL {
                if TYPE == "id" {
                    BVC.ID_TF.text = SIGN_TF.text!
                } else if TYPE == "birth" {
                    BVC.DATE_DATA = DATE_DATA
                    BVC.BIRTH_TF.text = DATE
                } else if TYPE == "phone" {
                    BVC.PHONE_TF.text = setHyphen("phone", SIGN_TF.text!)
                }
            }; dismiss(animated: true, completion: nil)
        }
    }
}
