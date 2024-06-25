//
//  TC0_MAIN.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/28.
//

import UIKit

class TC0_MAIN: UITableViewCell {
    
    var PROTOCOL: UIViewController?
    var OBJ_POSITION: Int = 0
    
    @IBOutlet weak var PROFILE_I: UIImageView!
    @IBOutlet weak var NAME_L1: UILabel!
    @IBOutlet weak var NAME_L2: UILabel!
    @IBOutlet weak var CATEGORY_I: UIImageView!
    @IBOutlet weak var CATEGORY_L: UILabel!
    @IBOutlet weak var VISIT_L: UILabel!
    
    @IBOutlet weak var PAY_L: UILabel!
    @IBOutlet weak var VC_LEPAY_B: UIButton!
    
    @IBOutlet weak var AMOUNT_L1: UILabel!
    @IBOutlet weak var AMOUNT_L2: UILabel!
    @IBOutlet weak var LEGOUP_B: UIButton!
    
    @IBOutlet weak var COUPON_L: UILabel!
    @IBOutlet weak var COUNT_L: UILabel!
    
    @objc func VC_LEPAY_B(_ sender: UIButton) {
        
        let VC = PROTOCOL?.storyboard?.instantiateViewController(withIdentifier: "VC_LEPAY") as! VC_LEPAY
        VC.PAY = PAY_L.text!
        PROTOCOL?.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func LEGOUP_B(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: "", message: "레고UP 사용시 500원이\n레pay에서 차감됩니다.", preferredStyle: .alert)
        
        ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.PROTOCOL?.GET_LEGOUP(NAME: "레고UP", AC_TYPE: "store")
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        PROTOCOL?.present(ALERT, animated: true, completion: nil)
    }
}
