//
//  VC_POPUP3.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/22.
//

import UIKit

class VC_POPUP3: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    var AC_TYPE: String = "pangpang_history"
    var DT_TYPE: String = "receive_time"
    var START: Int = 0
    var END: Int = 0
    var TYPE: String = "전체"
    var SORT: String = ">"
    
    let MENUS1 = ["최근 6개월", "최근 3개월", "최근 1개월"]
    let MENUS2 = ["전체", "레페이 충전", "레고UP", "레고팡팡", "A배너", "B배너", "C배너"]
    let MENUS3 = ["최신순", "과거순"]
    
    let PICKERVIEW1 = UIPickerView()
    let PICKERVIEW2 = UIDatePicker()
    let PICKERVIEW3 = UIDatePicker()
    let PICKERVIEW4 = UIPickerView()
    let PICKERVIEW5 = UIPickerView()
    
    @IBAction func BACK_B(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var NAVI_L: UILabel!
    
    @IBOutlet weak var MONTH_TF1: UITextField!
    @IBOutlet weak var MONTH_TF2: UITextField!
    @IBOutlet weak var MONTH_TF3: UITextField!
    @IBOutlet weak var DIVISION_L: UILabel!
    @IBOutlet weak var MONTH_TF4: UITextField!
    @IBOutlet weak var MONTH_TF5: UITextField!
    
    @IBOutlet weak var SUBMIT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        S_KEYBOARD() //6048000
        
        DF.timeZone = TimeZone(abbreviation: "Asia/Seoul"); DF.dateFormat = "yyyy-MM-dd 00:00:00"
        
        let TIMESTAMP = setKoreaTimestamp()/1000
        START = TIMESTAMP-(2592000*6); END = TIMESTAMP
        MONTH_TF2.text = FM_TIMESTAMP(TIMESTAMP-(2592000*6), "yy.MM.dd")
        MONTH_TF3.text = FM_TIMESTAMP(TIMESTAMP, "yy.MM.dd")
        
        if AC_TYPE == "lepay_history" { DIVISION_L.isHidden = false; MONTH_TF4.isHidden = false } else { DIVISION_L.isHidden = true; MONTH_TF4.isHidden = true }
        
//        for PV in [PICKERVIEW1, PICKERVIEW2, PICKERVIEW3, PICKERVIEW4, PICKERVIEW5] { if #available(iOS 13.0, *) { PV.overrideUserInterfaceStyle = .light } }
        if #available(iOS 13.4, *) { PICKERVIEW2.preferredDatePickerStyle = .wheels }; PICKERVIEW2.datePickerMode = .date; PICKERVIEW2.locale = Locale(identifier: "ko"); PICKERVIEW2.maximumDate = Date()
        if #available(iOS 13.4, *) { PICKERVIEW3.preferredDatePickerStyle = .wheels }; PICKERVIEW3.datePickerMode = .date; PICKERVIEW3.locale = Locale(identifier: "ko"); PICKERVIEW3.maximumDate = Date()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DF.dateFormat = "yyyy-MM-dd"
        PICKERVIEW2.date = DF.date(from: "20"+MONTH_TF2.text!) ?? Date()
        
        PICKERVIEW1.delegate = self; PICKERVIEW1.dataSource = self; MONTH_TF1.inputView = PICKERVIEW1
        PICKERVIEW2.addTarget(self, action: #selector(DATE_DP(_:)), for: .valueChanged); MONTH_TF2.inputView = PICKERVIEW2
        PICKERVIEW3.addTarget(self, action: #selector(DATE_DP(_:)), for: .valueChanged); MONTH_TF3.inputView = PICKERVIEW3
        PICKERVIEW4.delegate = self; PICKERVIEW4.dataSource = self; MONTH_TF4.inputView = PICKERVIEW4
        PICKERVIEW5.delegate = self; PICKERVIEW5.dataSource = self; MONTH_TF5.inputView = PICKERVIEW5
        
        SUBMIT_B.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
    }
    
    @objc func DATE_DP(_ sender: UIDatePicker) {
        
        DF.timeZone = TimeZone(identifier: "Asia/Seoul"); DF.dateFormat = "yy.MM.dd"
        
        if sender == PICKERVIEW2 {
            MONTH_TF2.text = DF.string(from: sender.date); START = setKoreaTimestamp()/1000
        } else if sender == PICKERVIEW3 {
            MONTH_TF3.text = DF.string(from: sender.date); END = setKoreaTimestamp()/1000
        }; MONTH_TF1.text = "직접설정"
    }
    
    @objc func SUBMIT_B(_ sender: UIButton) {
        PUT_FILTER(NAME: "상세조회", AC_TYPE: AC_TYPE)
    }
}

extension VC_POPUP3: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == PICKERVIEW1 {
            return MENUS1.count
        } else if pickerView == PICKERVIEW4 {
            return MENUS2.count
        } else if pickerView == PICKERVIEW5 {
            return MENUS3.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == PICKERVIEW1 {
            return MENUS1[row]
        } else if pickerView == PICKERVIEW4 {
            return MENUS2[row]
        } else if pickerView == PICKERVIEW5 {
            return MENUS3[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == PICKERVIEW1 { MONTH_TF1.text = MENUS1[row]
            let TIMESTAMP = setKoreaTimestamp()/1000
            if row == 0 {
                MONTH_TF2.text = FM_TIMESTAMP(TIMESTAMP-(2592000*6), "yy.MM.dd"); START = TIMESTAMP-(2592000*6)
            } else if row == 1 {
                MONTH_TF2.text = FM_TIMESTAMP(TIMESTAMP-(2592000*3), "yy.MM.dd"); START = TIMESTAMP-(2592000*3)
            } else if row == 2 {
                MONTH_TF2.text = FM_TIMESTAMP(TIMESTAMP-(2592000*1), "yy.MM.dd"); START = TIMESTAMP-(2592000*1)
            }; MONTH_TF3.text = FM_TIMESTAMP(TIMESTAMP, "yy.MM.dd"); END = TIMESTAMP
        } else if pickerView == PICKERVIEW4 { MONTH_TF4.text = MENUS2[row]
            TYPE = MENUS2[row]
        } else if pickerView == PICKERVIEW5 { MONTH_TF5.text = MENUS3[row]
            if row == 0 { SORT = ">" } else if row == 1 { SORT = "<" }
        }
    }
}
