//
//  VC_GRADE.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/02/01.
//

import UIKit

class VC_GRADE: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    
    @IBOutlet weak var PROFILE_I: UIImageView!
    @IBOutlet weak var NAME_L: UILabel!
    @IBOutlet weak var PHONE_L: UILabel!
    @IBOutlet weak var GRADE_SV: UIStackView!
    @IBOutlet weak var GRADE_I1: UIImageView!
    
    @IBOutlet weak var BENEFIT_L: UILabel!
    
    @IBOutlet weak var LV1_B: UIButton!
    @IBOutlet weak var LV2_B: UIButton!
    @IBOutlet weak var LV3_B: UIButton!
    @IBOutlet weak var LV4_B: UIButton!
    
    @IBOutlet weak var GRADE_I2: UIImageView!
    @IBOutlet weak var CONDITION_SV1: UIStackView!
    @IBOutlet weak var CONDITION_SV2: UIStackView!
    @IBOutlet weak var CONDITION_SV3: UIStackView!
    @IBOutlet weak var CONDITION_SV4: UIStackView!
    
    @IBOutlet weak var GRADE_I3: UIImageView!
    @IBOutlet weak var COUPON_SV1: UIStackView!
    @IBOutlet weak var COUPON_L1: UILabel!
    @IBOutlet weak var COUPON_I2: UIImageView!
    @IBOutlet weak var COUPON_L2: UILabel!
    @IBOutlet weak var COUPON_SV4: UIStackView!
    
    override func loadView() {
        super.loadView()
        
        let DATA = UIViewController.appDelegate.MemberObject
        
        NUKE(IV: PROFILE_I, IU: DATA.profileImg, PH: UIImage(), RD: 25, CM: .scaleAspectFill)
        NAME_L.text = "\(DATA.name)(\(DATA.nick))님 :D"
        PHONE_L.text = setHyphen("phone", DATA.number)
        GRADE_I1.image = UIImage(named: "lv\(DATA.grade)")
        
        BENEFIT_L.text = "총 받은 혜택은 \(NF.string(from: (Int(DATA.benefitPoint) ?? 0) as NSNumber) ?? "0")원 입니다."
        
        loadView2(Int(DATA.grade) ?? 1)
    }
    
    func loadView2(_ ITEM: Int) {
        
        GRADE_I2.image = UIImage(named: "lv\(ITEM)")
        CONDITION_SV1.isHidden = true
        CONDITION_SV2.isHidden = true
        CONDITION_SV3.isHidden = true
        CONDITION_SV4.isHidden = true
        
        GRADE_I3.image = UIImage(named: "lv\(ITEM)")
        COUPON_SV1.isHidden = true; COUPON_L1.text = "\(ITEM-1)장"
        COUPON_I2.image = UIImage(named: "level\(ITEM)"); COUPON_L2.text = "\(ITEM+1)%"
        COUPON_SV4.isHidden = true
        
        if ITEM == 1 {
            CONDITION_SV1.isHidden = false
        } else if ITEM == 2 {
            CONDITION_SV2.isHidden = false
        } else if ITEM == 3 {
            CONDITION_SV3.isHidden = false
            COUPON_SV1.isHidden = false
        } else if ITEM == 4 {
            CONDITION_SV4.isHidden = false
            COUPON_SV1.isHidden = false
            COUPON_SV4.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LV1_B.tag = 1; LV1_B.addTarget(self, action: #selector(INFOMATION(_:)), for: .touchUpInside)
        LV2_B.tag = 2; LV2_B.addTarget(self, action: #selector(INFOMATION(_:)), for: .touchUpInside)
        LV3_B.tag = 3; LV3_B.addTarget(self, action: #selector(INFOMATION(_:)), for: .touchUpInside)
        LV4_B.tag = 4; LV4_B.addTarget(self, action: #selector(INFOMATION(_:)), for: .touchUpInside)
    }
    
    @objc func INFOMATION(_ sender: UIButton) {
        loadView2(sender.tag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}
