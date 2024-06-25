//
//  VC_DETAIL4.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/02/10.
//

import UIKit

class VC_DETAIL4: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var OBJ_BASKET: [API_LEGONGGU] = []
    var OBJ_POSITION: Int = 0
    
    var OBJ_ORDER_DETAIL: [API_ORDER_DETAIL] = []
    
    var OPTION_IS: [UIImageView] = []
    var OPTION_LS: [UILabel] = []
    var POSITION: Int = 0
    
    var ADDRESS: String = ""
    var METHOD_TYPE: String = ""
    
    var POINT: Int = 0
    var PRICE1: Int = 0
    var PRICE2: Int = 0
    var PRICE3: Int = 0
    var FREEDELIVERY_COUPON_USE: Bool = false
    
    var PICKERVIEW1 = UIPickerView()
    var PICKERVIEW2 = UIPickerView()
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    
    @IBOutlet weak var CHECK_B1: UIButton!
    @IBOutlet weak var CHECK_B2: UIButton!
    
    @IBOutlet weak var MEMO_TF: UITextField!
    @IBOutlet weak var ADDRESS_V1: UIView!
    @IBOutlet weak var ADDRESS_SV1: UIStackView!
    @IBOutlet weak var ADDRESS_SV1_HEIGHT: NSLayoutConstraint!
    @IBOutlet weak var ADDRESS_SV2: UIStackView!
    @IBOutlet weak var NAME_TF1: UITextField!
    @IBOutlet weak var TYPE_B1: UIButton!
    @IBOutlet weak var TYPE_B2: UIButton!
    @IBOutlet weak var TYPE_B3: UIButton!
    @IBOutlet weak var TYPE_B4: UIButton!
    @IBOutlet weak var ADDRESS_TF1: UITextField!
    @IBOutlet weak var SEARCH_B: UIButton!
    @IBOutlet weak var ADDRESS_TF2: UITextField!
    @IBOutlet weak var SETTING_I1: UIImageView!
    @IBOutlet weak var SETTING_B1: UIButton!
    @IBOutlet weak var SETTING_I2: UIImageView!
    @IBOutlet weak var SETTING_B2: UIButton!
    
    @IBOutlet weak var NAME_TF2: UITextField!
    @IBOutlet weak var NUMBER_TF1_1: UITextField!
    @IBOutlet weak var NUMBER_TF1_2: UITextField!
    @IBOutlet weak var NUMBER_TF1_3: UITextField!
    @IBOutlet weak var NUMBER_TF2_1: UITextField!
    @IBOutlet weak var NUMBER_TF2_2: UITextField!
    @IBOutlet weak var NUMBER_TF2_3: UITextField!
    
    @IBOutlet weak var NAME_TF3: UITextField!
    @IBOutlet weak var NUMBER_TF3: UITextField!
    
    @IBOutlet weak var BASKET_SV: UIStackView!
    @IBOutlet weak var BASKET_L: UILabel!
    
    @IBOutlet weak var POINT_L1: UILabel!
    @IBOutlet weak var POINT_TF: UITextField!
    @IBOutlet weak var POINT_B: UIButton!
    @IBOutlet weak var SETTING_I3: UIImageView!
    @IBOutlet weak var SETTING_B3: UIButton!
    @IBOutlet weak var SETTING_I4: UIImageView!
    @IBOutlet weak var SETTING_B4: UIButton!
    @IBOutlet weak var SETTING_I5: UIImageView!
    @IBOutlet weak var SETTING_L5: UILabel!
    @IBOutlet weak var SETTING_B5: UIButton!
    
    @IBOutlet weak var PRICE_L1: UILabel!
    @IBOutlet weak var PRICE_L2: UILabel!
    @IBOutlet weak var PRICE_L3: UILabel!
    @IBOutlet weak var PRICE_L4: UILabel!
    
    @IBOutlet weak var GRADE_I: UIImageView!
    @IBOutlet weak var POINT_L2: UILabel!
    @IBOutlet weak var PRICE_L5: UILabel!
    
    @IBOutlet weak var PAYMENT_SV: UIStackView!
    @IBOutlet weak var PAYMENT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_DETAIL4_DEL = self
        
        setKeyboard()
        
        CHECK_B1.layer.borderWidth = 1; CHECK_B1.layer.borderColor = UIColor.H_00529C.cgColor
        CHECK_B2.layer.borderWidth = 1; CHECK_B2.layer.borderColor = UIColor.H_00529C.cgColor
        
        for TF in [MEMO_TF, NAME_TF1, ADDRESS_TF1, ADDRESS_TF2, NAME_TF2, NAME_TF3, NUMBER_TF3, POINT_TF] { TF?.paddingLeft(10); TF?.paddingRight(10) }
        
        MEMO_TF.placeholder("배송시 요청사항을 입력해 주세요.", COLOR: .lightGray)
        
        if UIViewController.appDelegate.MemberObject.deliveryAddress.count > 0 {
            
            CHECK_B1.backgroundColor = .H_00529C; CHECK_B1.setTitleColor(.white, for: .selected); CHECK_B1.isSelected = true
            CHECK_B2.backgroundColor = .white; CHECK_B2.setTitleColor(.H_00529C, for: .normal); CHECK_B2.isSelected = false
            ADDRESS_V1.isHidden = false; ADDRESS_SV2.isHidden = true
            
            for (I, DATA) in UIViewController.appDelegate.MemberObject.deliveryAddress.enumerated() {
                
                let OPTION_I = UIImageView()
                OPTION_I.translatesAutoresizingMaskIntoConstraints = false
                OPTION_I.addConstraints([NSLayoutConstraint(item: OPTION_I, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)])
                OPTION_I.contentMode = .scaleAspectFit
                OPTION_I.image = UIImage(named: "check_off")
                OPTION_IS.append(OPTION_I)
                
                let OPTION_L = UILabel()
                OPTION_L.font = UIFont.systemFont(ofSize: 14)
                OPTION_L.lineBreakMode = .byTruncatingMiddle
                OPTION_L.textAlignment = .left
                OPTION_L.textColor = .black
                OPTION_L.numberOfLines = 5
                OPTION_L.text = DATA
                OPTION_LS.append(OPTION_L)
                
                let BACKGROUND_SV = UIStackView(arrangedSubviews: [OPTION_I, OPTION_L])
                BACKGROUND_SV.axis = .horizontal
                BACKGROUND_SV.spacing = 5
                BACKGROUND_SV.tag = I; BACKGROUND_SV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ADDRESS_B(_:))))
                ADDRESS_SV1.addArrangedSubview(BACKGROUND_SV)
                
                ADDRESS_SV1_HEIGHT.constant += CGFloat(OPTION_L.countLines()*20+5)
            }; ADDRESS_SV1_HEIGHT.constant -= 5
        } else {
            
            CHECK_B1.backgroundColor = .white; CHECK_B1.setTitleColor(.H_00529C, for: .normal); CHECK_B1.isSelected = false
            CHECK_B2.backgroundColor = .H_00529C; CHECK_B2.setTitleColor(.white, for: .selected); CHECK_B2.isSelected = true
            ADDRESS_V1.isHidden = true; ADDRESS_SV2.isHidden = false
            
            let OPTION_L = UILabel()
            OPTION_L.font = UIFont.systemFont(ofSize: 14)
            OPTION_L.lineBreakMode = .byTruncatingMiddle
            OPTION_L.textAlignment = .left
            OPTION_L.textColor = .black
            OPTION_L.numberOfLines = 5
            OPTION_L.text = "신규등록으로 배송지 목록에 추가해 주세요."
            ADDRESS_SV1.addArrangedSubview(OPTION_L)
            
            ADDRESS_SV1_HEIGHT.constant = 25
        }; ADDRESS_TF1.isUserInteractionEnabled = false
        
        NAME_TF2.placeholder("이름을 입력해 주세요.", COLOR: .lightGray)
        
        if OBJ_BASKET.count > 0 { loadView2() } else { S_NOTICE("주문/결제 정보 없음"); navigationController?.popViewController(animated: true) }
    }
    
    @objc func ADDRESS_B(_ sender: UITapGestureRecognizer) {
        
        for I in 0 ..< OPTION_IS.count {
            if I == (sender.view?.tag ?? 0) {
                OPTION_IS[I].image = UIImage(named: "check_on"); ADDRESS = OPTION_LS[I].text!
            } else {
                OPTION_IS[I].image = UIImage(named: "check_off")
            }
        }
    }
    
    func loadView2() {
        
        let memberData = UIViewController.appDelegate.MemberObject
        let DATA2 = OBJ_BASKET[OBJ_POSITION]
        
        NAME_TF3.text = memberData.name; NAME_TF3.isUserInteractionEnabled = false
        NUMBER_TF3.text = setHyphen("phone", memberData.number); NUMBER_TF3.isUserInteractionEnabled = false
        
        BASKET_L.text = DATA2.ITEM_NAME
        
        for (_, DATA) in DATA2.ORDER_ITEMARRAY.enumerated() {
            
            PRICE1 += ((Int(DATA.ITEM_PRICE) ?? 0)*(Int(DATA.ITEM_COUNT) ?? 0))
            if DATA.FREEDELIVERY_COUPON_USE == "true" { PRICE2 = 0; FREEDELIVERY_COUPON_USE = true } else { PRICE2 = 3000; FREEDELIVERY_COUPON_USE = false }
            
            let BACKGROUND_SV = UIStackView()
            BACKGROUND_SV.axis = .vertical
            BACKGROUND_SV.spacing = 0
            
            let OPTION_L1 = UILabel()
            OPTION_L1.translatesAutoresizingMaskIntoConstraints = false
            OPTION_L1.addConstraints([NSLayoutConstraint(item: OPTION_L1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15)])
            OPTION_L1.font = UIFont.boldSystemFont(ofSize: 12)
            OPTION_L1.textAlignment = .left
            OPTION_L1.textColor = .black
            OPTION_L1.numberOfLines = 3
            OPTION_L1.text = "옵션: \(DATA.ITEM_OPTION) | 수량: \(DATA.ITEM_COUNT)"
            BACKGROUND_SV.addArrangedSubview(OPTION_L1)
            
            let OPTION_L2 = UILabel()
            OPTION_L2.translatesAutoresizingMaskIntoConstraints = false
            OPTION_L2.addConstraints([NSLayoutConstraint(item: OPTION_L2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)])
            OPTION_L2.font = UIFont.boldSystemFont(ofSize: 14)
            OPTION_L2.textAlignment = .left
            OPTION_L2.textColor = .H_FF6F00
            OPTION_L2.numberOfLines = 3
            OPTION_L2.text = "\(NF.string(from: ((Int(DATA.ITEM_PRICE) ?? 0)*(Int(DATA.ITEM_COUNT) ?? 0)) as NSNumber) ?? "0")원"
            BACKGROUND_SV.addArrangedSubview(OPTION_L2)
            
            BASKET_SV.addArrangedSubview(BACKGROUND_SV)
        }; pointSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for TF in [ADDRESS_TF2, NAME_TF2, NUMBER_TF1_1, NUMBER_TF1_2, NUMBER_TF1_3, NAME_TF3, NUMBER_TF3, POINT_TF] { TF?.addTarget(self, action: #selector(TEXTFIELD(_:)), for: .editingChanged) }
        
        CHECK_B1.tag = 0; CHECK_B1.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        CHECK_B2.tag = 1; CHECK_B2.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        
        SEARCH_B.tag = 2; SEARCH_B.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        SETTING_B1.tag = 3; SETTING_B1.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        SETTING_B2.tag = 4; SETTING_B2.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        
        NAME_TF2.delegate = self
        PICKERVIEW1.delegate = self; PICKERVIEW1.dataSource = self; NUMBER_TF1_1.inputView = PICKERVIEW1
        NUMBER_TF1_2.delegate = self; NUMBER_TF1_3.delegate = self
        PICKERVIEW2.delegate = self; PICKERVIEW2.dataSource = self; NUMBER_TF2_1.inputView = PICKERVIEW2
        NUMBER_TF2_2.delegate = self; NUMBER_TF2_3.delegate = self
        
        POINT_TF.delegate = self
        POINT_B.tag = 5; POINT_B.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        SETTING_B3.tag = 6; SETTING_B3.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        SETTING_B4.tag = 7; SETTING_B4.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        SETTING_B5.tag = 8; SETTING_B5.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        
        PAYMENT_B.tag = 9; PAYMENT_B.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
    }
    
    @objc func BUTTON(_ sender: UIButton) {
        
        for TF in [MEMO_TF, ADDRESS_TF2, NAME_TF2, NUMBER_TF1_1, NUMBER_TF1_2, NUMBER_TF1_3, NUMBER_TF2_1, NUMBER_TF2_2, NUMBER_TF2_3, NAME_TF3, NUMBER_TF3, POINT_TF] { TF?.resignFirstResponder() }
        
        if sender.tag == 0 {
            CHECK_B1.backgroundColor = .H_00529C; CHECK_B1.setTitleColor(.white, for: .selected); CHECK_B1.isSelected = true
            CHECK_B2.backgroundColor = .white; CHECK_B2.setTitleColor(.H_00529C, for: .normal); CHECK_B2.isSelected = false
            ADDRESS_V1.isHidden = false; ADDRESS_SV2.isHidden = true; ADDRESS = ""; ADDRESS_TF1.text?.removeAll(); ADDRESS_TF2.text?.removeAll(); SETTING_B1.isSelected = false; SETTING_I1.image = UIImage(named: "check_off")
        } else if sender.tag == 1 {
            CHECK_B1.backgroundColor = .white; CHECK_B1.setTitleColor(.H_00529C, for: .normal); CHECK_B1.isSelected = false
            CHECK_B2.backgroundColor = .H_00529C; CHECK_B2.setTitleColor(.white, for: .selected); CHECK_B2.isSelected = true
            ADDRESS_V1.isHidden = true; ADDRESS_SV2.isHidden = false; ADDRESS = ""; for IMAGE in OPTION_IS { IMAGE.image = UIImage(named: "check_off") }
        } else if sender.tag == 2 {
            segueViewController(identifier: "VC_ADDRESS")
        } else if sender.tag == 3 {
            if !sender.isSelected { sender.isSelected = true; SETTING_I1.image = UIImage(named: "check_on") } else { sender.isSelected = false; SETTING_I1.image = UIImage(named: "check_off") }
        } else if sender.tag == 4 {
            
        } else if sender.tag == 5 {
            if POINT > (PRICE1+PRICE2) { PRICE3 = (PRICE1+PRICE2) } else { PRICE3 = POINT }; pointSetup()
        } else if sender.tag == 6 {
            METHOD_TYPE = "네이버페이"
            SETTING_I3.image = UIImage(named: "check_on"); SETTING_B3.isSelected = true
            SETTING_I4.image = UIImage(named: "check_off"); SETTING_B4.isSelected = false
            SETTING_I5.image = UIImage(named: "check_off"); SETTING_B5.isSelected = false
            SETTING_L5.text = "일반결제"; //paymentCheck()
        } else if sender.tag == 7 {
            METHOD_TYPE = "카카오페이"
            SETTING_I3.image = UIImage(named: "check_off"); SETTING_B3.isSelected = false
            SETTING_I4.image = UIImage(named: "check_on"); SETTING_B4.isSelected = true
            SETTING_I5.image = UIImage(named: "check_off"); SETTING_B5.isSelected = false
            SETTING_L5.text = "일반결제"; //paymentCheck()
        } else if sender.tag == 8 {
            SETTING_I3.image = UIImage(named: "check_off"); SETTING_B3.isSelected = false
            SETTING_I4.image = UIImage(named: "check_off"); SETTING_B4.isSelected = false
            SETTING_I5.image = UIImage(named: "check_on"); SETTING_B5.isSelected = true
            
            let ALERT = UIAlertController(title: nil, message: "일반결제", preferredStyle: .actionSheet)
            ALERT.addAction(UIAlertAction(title: "신용/체크 카드", style: .default, handler: { _ in
                self.METHOD_TYPE = "카드"; self.SETTING_L5.text = "일반결제 (신용/체크 카드)"; //self.paymentCheck()
            }))
            ALERT.addAction(UIAlertAction(title: "휴대폰 소액결제", style: .default, handler: { _ in
                self.METHOD_TYPE = "휴대폰"; self.SETTING_L5.text = "일반결제 (휴대폰 소액결제)"; //self.paymentCheck()
            }))
            present(ALERT, animated: true, completion: nil)
        } else if sender.tag == 9 {
            if (ADDRESS == "") || ((CHECK_B2.isSelected) && (ADDRESS_TF1.text! == "")) {
                S_NOTICE("배송지 (!)")
            } else if (NAME_TF2.text! == "") || (NUMBER_TF1_1.text! == "선택") || (NUMBER_TF1_2.text! == "") || (NUMBER_TF1_3.text! == "") {
                S_NOTICE("수령인 (!)")
            } else if (NAME_TF3.text! == "") || (NUMBER_TF3.text! == "") {
                S_NOTICE("주문자 (!)")
            } else if METHOD_TYPE == "" && ((PRICE1+PRICE2-PRICE3) != 0) {
                S_NOTICE("결제수단 (!)")
            } else if (PRICE1+PRICE2-PRICE3) != 0 {
                PUT_BOOTPAY2(NAME: "결제하기", AC_TYPE: "bootpay")
            } else {
                PUT_PAYMENT(NAME: "주문요청", AC_TYPE: "legonggu_order_detail")
            }
        }
    }
    
    func pointSetup() {
        
        let DATA = UIViewController.appDelegate.MemberObject
        POINT = Int(DATA.point) ?? 0
        
        POINT_L1.text = "보유 포인트 \(NF.string(from: POINT as NSNumber) ?? "0")원"
        POINT_TF.text = "\(PRICE3)"
        PRICE_L1.text = "\(NF.string(from: PRICE1 as NSNumber) ?? "0")원"
        PRICE_L2.text = "\(NF.string(from: PRICE2 as NSNumber) ?? "0")원"
        PRICE_L3.text = "\(NF.string(from: -PRICE3 as NSNumber) ?? "0")원"
        PRICE_L4.text = "\(NF.string(from: (PRICE1+PRICE2-PRICE3) as NSNumber) ?? "0")원"
        
        let GRADE = (Int(DATA.grade) ?? 1)+1
        GRADE_I.image = UIImage(named: "lv\(DATA.grade)")
        POINT_L2.text = "레pay 적립 \(GRADE)%"
        PRICE_L5.text = "\(NF.string(from: Int(CGFloat(PRICE1+PRICE2-PRICE3)*(CGFloat(GRADE)*0.01)) as NSNumber) ?? "0")원"
    }
    
    func paymentCheck() {
        
        for TF in [NAME_TF2, NUMBER_TF1_1, NUMBER_TF1_2, NUMBER_TF1_3, NAME_TF3, NUMBER_TF3] {
            if (TF?.text! == "") || (NUMBER_TF1_1.text! == "선택") || (METHOD_TYPE == "") || (ADDRESS == "") { PAYMENT_SV.isHidden = true; return }
        }; PAYMENT_SV.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
        
        if ADDRESS_TF1.text != "" { ADDRESS = ADDRESS_TF1.text! }
    }
}

extension VC_DETAIL4 {
    
    @objc func TEXTFIELD(_ sender: UITextField) {
        
        if sender == ADDRESS_TF2 {
            ADDRESS = "\(ADDRESS_TF1.text!) \(ADDRESS_TF2.text!)"
        } else if sender == POINT_TF {
            if ((PRICE1+PRICE2) <= POINT) && ((PRICE1+PRICE2) <= (Int(sender.text!) ?? 0)) {
                POINT_TF.text = "\(PRICE1+PRICE2)"
            } else if (POINT < (PRICE1+PRICE2)) && (POINT <= (Int(sender.text!) ?? 0)) {
                POINT_TF.text = "\(POINT)"
            } else {
                POINT_TF.text = sender.text!
            }; PRICE3 = Int(POINT_TF.text!) ?? 0; pointSetup(); return
        }; //paymentCheck()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var isBackspace: Bool = false
        if let char = string.cString(using: .utf8) { isBackspace = (strcmp(char, "\\b") == -92) } else { isBackspace = false }
        
        if textField == NAME_TF2 {
            if (range.location < 20) { return true } else { return false }
        } else if (textField == NUMBER_TF1_2) || (textField == NUMBER_TF1_3) || (textField == NUMBER_TF2_2) || (textField == NUMBER_TF2_3) {
            if (range.location < 4) || isBackspace { return true } else { textField.resignFirstResponder(); return false }
        } else {
            return true
        }
    }
}

extension VC_DETAIL4: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ["선택", "010", "011", "016", "018", "019"][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == PICKERVIEW1 {
            NUMBER_TF1_1.text = ["선택", "010", "011", "016", "018", "019"][row]
        } else if pickerView == PICKERVIEW2 {
            NUMBER_TF2_1.text = ["선택", "010", "011", "016", "018", "019"][row]
        }; //paymentCheck()
    }
}
