//
//  VC_POPUP1.swift
//  legoyang_owner
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
    var CHECK: Bool = false
    var DATA: String = ""
    var DATE: String = ""
    let CATES1: [String] = ["놀이", "대관대여", "맛집", "문화", "뷰티", "애견", "액티비티", "운동", "주점", "카페", "키즈존", "풀빌라펜션", "행사", "호텔"]
    let CATES2: [String] = ["cate_play", "cate_rental", "cate_restaurant", "cate_culture", "cate_beauty", "cate_dog", "cate_activity", "cate_exercise", "cate_pub", "cate_cafe", "cate_kidszone", "cate_pension", "cate_event", "cate_hotel"]
    
    var ROW1: Int = 0
    var ROW2: Int = 0
    
    @IBAction func BACK_B(_ sender: UIButton) { SIGN_TF.resignFirstResponder(); NUMBER_TF.resignFirstResponder(); dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var NAVI_L: UILabel!
    @IBOutlet weak var CUSTOM_SV1: UIStackView!
    @IBOutlet weak var SIGN_SV: UIStackView!
    @IBOutlet weak var SIGN_I: UIImageView!
    @IBOutlet weak var SIGN_TF: UITextField!
    @IBOutlet weak var SIGN_B: UIButton!
    @IBOutlet weak var NUMBER_SV: UIStackView!
    @IBOutlet weak var NUMBER_TF: UITextField!
    @IBOutlet weak var NUMBER_B: UIButton!
    @IBOutlet weak var BIRTH_DP: UIDatePicker!
    @IBOutlet weak var PICKERVIEW: UIPickerView!
    @IBOutlet weak var VC_SIGNUP_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        S_KEYBOARD()
        
        if TYPE == "birth" {
            CUSTOM_SV1.isHidden = true; SIGN_SV.isHidden = true; NUMBER_SV.isHidden = true; BIRTH_DP.isHidden = false; PICKERVIEW.isHidden = true
            NAVI_L.text = "생년월일"
            CHECK = true; DATA = FM_CUSTOM("\(Date())", "yyyyMMdd"); DATE = FM_CUSTOM("\(Date())", "yy. MM. dd")
            if #available(iOS 13.0, *) { BIRTH_DP.overrideUserInterfaceStyle = .light }; BIRTH_DP.maximumDate = Date()
        } else if TYPE == "phone" { UserDefaults.standard.setValue(false, forKey: "phonecheck")
            CUSTOM_SV1.isHidden = false; SIGN_SV.isHidden = false; NUMBER_SV.isHidden = false; BIRTH_DP.isHidden = true; PICKERVIEW.isHidden = true
            NAVI_L.text = "휴대전화 본인인증"
            SIGN_I.image = UIImage(named: "login_phone.png"); SIGN_TF.placeholder("전화번호", COLOR: .lightGray); SIGN_TF.keyboardType = .phonePad; SIGN_B.setTitle("인증요청", for: .normal)
        } else if TYPE == "id" {
            CUSTOM_SV1.isHidden = false; SIGN_SV.isHidden = false; NUMBER_SV.isHidden = true; BIRTH_DP.isHidden = true; PICKERVIEW.isHidden = true
            NAVI_L.text = "아이디 중복확인"
            SIGN_I.image = UIImage(named: "login_id.png"); SIGN_TF.placeholder("아이디", COLOR: .lightGray); SIGN_TF.keyboardType = .emailAddress; SIGN_B.setTitle("중복확인", for: .normal)
        } else if TYPE == "category" {
            CUSTOM_SV1.isHidden = true; SIGN_SV.isHidden = true; NUMBER_SV.isHidden = true; BIRTH_DP.isHidden = true; PICKERVIEW.isHidden = false
            NAVI_L.text = "카테고리"
            CHECK = true; DATA = CATES1[0]
            if #available(iOS 13.0, *) { PICKERVIEW.overrideUserInterfaceStyle = .light }
        } else if TYPE == "address" {
            CUSTOM_SV1.isHidden = true; SIGN_SV.isHidden = true; NUMBER_SV.isHidden = true; BIRTH_DP.isHidden = true; PICKERVIEW.isHidden = false
            NAVI_L.text = "주소"
            CHECK = true; DATA = "고양시 덕양구 고양동"; //GOYANG_PAJU_SI.sorted(by: { $0.key > $1.key })
            if #available(iOS 13.0, *) { PICKERVIEW.overrideUserInterfaceStyle = .light }
        }
        NUMBER_TF.placeholder("인증번호", COLOR: .lightGray)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SIGN_B.tag = 0; SIGN_B.addTarget(self, action: #selector(SIGNCHECK_B(_:)), for: .touchUpInside)
        NUMBER_B.tag = 1; NUMBER_B.addTarget(self, action: #selector(SIGNCHECK_B(_:)), for: .touchUpInside)
        
        BIRTH_DP.addTarget(self, action: #selector(BIRTH_DP(_:)), for: .valueChanged)
        
        PICKERVIEW.delegate = self; PICKERVIEW.dataSource = self
        
        VC_SIGNUP_B.addTarget(self, action: #selector(VC_SIGNUP_B(_:)), for: .touchUpInside)
    }
    
    @objc func SIGNCHECK_B(_ sender: UIButton) {
        
        if sender.tag == 0 && TYPE == "phone" {
            if SIGN_TF.text! == "" {
                S_NOTICE("휴대전화 (!)")
            } else {
                GET_PHONE(NAME: "휴대전화 본인인증", AC_TYPE: TYPE)
            }
        } else if sender.tag == 1 && TYPE == "phone" {
            if SIGN_TF.text! == "" || NUMBER_TF.text! == "" {
                S_NOTICE("인증번호 (!)")
            } else {
                PUT_PHONE(NAME: "휴대전화 본인인증", AC_TYPE: TYPE)
            }
        } else if sender.tag == 0 && TYPE == "id" {
            S_NOTICE("아이디 (!)")
        } else if sender.tag == 1 && TYPE == "id" {
            
        }
    }
    
    @objc func BIRTH_DP(_ sender: UIDatePicker) {
        DF.dateFormat = "yy. MM. dd"; DATE = DF.string(from: sender.date)
        DF.dateFormat = "yyyyMMdd"; DATA = DF.string(from: sender.date)
    }
    
    @objc func VC_SIGNUP_B(_ sender: UIButton) {
        
        if !CHECK {
            if TYPE == "phone" {
                S_NOTICE("휴대전화 (!)")
            } else if TYPE == "id" {
                S_NOTICE("아이디 (!)")
            }
        } else {
            if let BVC = UIViewController.VC_SIGNUP_DEL {
                if TYPE == "birth" {
                    BVC.DATE_DATA = DATA
                    BVC.US_BIRTH_TF.text = DATE
                } else if TYPE == "phone" {
                    BVC.US_ID_TF.text = SIGN_TF.text!
                    BVC.US_PHONE_TF.text = NUMBER("phone", SIGN_TF.text!)
                } else if TYPE == "id" {
                    BVC.US_ID_TF.text = SIGN_TF.text!
                } else if TYPE == "category" {
                    BVC.BS_CATE_TF.text = DATA
                } else if TYPE == "address" {
                    BVC.BS_ADDRESS_TF1.text = DATA
                }
            }; dismiss(animated: true, completion: nil)
        }
    }
}

extension VC_POPUP1: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if TYPE == "category" { return 1 } else if TYPE == "address" { return 2 } else { return 0 }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if TYPE == "category" {
            if CATES1.count > 0 { return CATES1.count } else { return 0 }
        } else if TYPE == "address" {
            if component == 0 { return Array(GOYANG_PAJU_SI.keys).count } else { return Array(GOYANG_PAJU_SI.values)[ROW1].count }
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if TYPE == "category" {
            
            let imageView = UIImageView()
            imageView.frame.size.width = view?.frame.height ?? 0
            imageView.image = UIImage(named: CATES2[row])
            imageView.contentMode = .scaleAspectFit
            
            let label = UILabel()
            label.text = CATES1[row]
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            
            let stackview = UIStackView()
            stackview.distribution = .fillEqually
            stackview.axis = .horizontal
            stackview.spacing = 10
            stackview.addArrangedSubview(imageView)
            stackview.addArrangedSubview(label)
            
            return stackview
        } else if TYPE == "address" {
            
            let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            if component == 0 { label.text = Array(GOYANG_PAJU_SI.keys)[row]; return label } else { label.text = Array(GOYANG_PAJU_SI.values)[ROW1][row]; return label }
        } else {
            return UIView()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if TYPE == "category" {
            DATA = CATES1[row]
        } else if TYPE == "address" {
            if component == 0 {
                ROW1 = row; ROW2 = 0; PICKERVIEW.selectRow(0, inComponent: 1, animated: true); PICKERVIEW.reloadAllComponents()
            } else {
                ROW2 = row
            }; DATA = "\(Array(GOYANG_PAJU_SI.keys)[ROW1]) \(Array(GOYANG_PAJU_SI.values)[ROW1][ROW2])"
        }
    }
}
