//
//  VC_JUDGE.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/11/25.
//

import UIKit

class VC_JUDGE: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBOutlet weak var TITLE_L: UILabel!
    
    @IBOutlet weak var STEP1_SV: UIStackView!
    @IBOutlet weak var CATE_I: UIImageView!
    @IBOutlet weak var CATE_L: UILabel!
    
    @IBOutlet weak var STEP2_V: UIView!
    @IBOutlet weak var ON_NAME_L: UILabel!
    @IBOutlet weak var ON_BIRTH_L: UILabel!
    @IBOutlet weak var ON_PHONE_L: UILabel!
    @IBOutlet weak var BS_CATE_L: UILabel!
    @IBOutlet weak var BS_NAME_L: UILabel!
    @IBOutlet weak var BS_NUMBER_L: UILabel!
    @IBOutlet weak var BS_ADDRESS_L: UILabel!
    
    @IBOutlet weak var NEXT_SV: UIStackView!
    @IBOutlet weak var NEXT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        let DATA = UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row]
        
        if DATA.waitingStep == "0" { TITLE_L.text = "입점 심사중이에요!"; STEP1_SV.isHidden = false; STEP2_V.isHidden = true; NEXT_SV.isHidden = true
            CATE_L.text = DATA.storeCategory
        } else if DATA.waitingStep == "1" { TITLE_L.text = "입점을 축하해요!"; STEP1_SV.isHidden = true; STEP2_V.isHidden = false; NEXT_SV.isHidden = false
            ON_NAME_L.text = DATA.ownerName
            ON_BIRTH_L.text = ""
            ON_PHONE_L.text = NUMBER("phone", DATA.ownerNumber)
            BS_CATE_L.text = DATA.storeCategory
            BS_NAME_L.text = DATA.storeName
            BS_NUMBER_L.text = NUMBER("company", DATA.storeRegnum)
            BS_ADDRESS_L.text = DATA.storeAddress
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NEXT_B.addTarget(self, action: #selector(NEXT_B(_:)), for: .touchUpInside)
    }
    
    @objc func NEXT_B(_ sender: UIButton) {
        SET_JUDGE(NAME: "내사업장등록", AC_TYPE: "store")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
    }
}
