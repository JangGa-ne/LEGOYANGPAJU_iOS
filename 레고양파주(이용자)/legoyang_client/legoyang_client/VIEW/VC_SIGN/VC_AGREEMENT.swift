//
//  VC_AGREEMENT.swift
//  legoyang
//
//  Created by 장 제현 on 2022/09/17.
//

import UIKit

class VC_AGREEMENT: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var BOOLS: [Bool] = [false, false, false]
    
    @IBOutlet weak var HEADER_L: UILabel!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    
    @IBOutlet weak var AGREE_V1: UIView!
    @IBOutlet weak var AGREE_I1: UIImageView!
    @IBOutlet weak var AGREE_L1_1: UILabel!
    @IBOutlet weak var AGREE_L1_2: UILabel!
    
    @IBOutlet weak var AGREE_V2: UIView!
    @IBOutlet weak var AGREE_I2: UIImageView!
    @IBOutlet weak var AGREE_L2: UILabel!
    @IBOutlet weak var AGREE_V3: UIView!
    @IBOutlet weak var AGREE_I3: UIImageView!
    @IBOutlet weak var AGREE_L3: UILabel!
    
    @IBOutlet weak var VC_SIGNUP_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        HEADER_L.alpha = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCROLLVIEW.delegate = self
        
        let VIEWS: [UIView] = [AGREE_V1, AGREE_V2, AGREE_V3]
        for i in 0 ..< VIEWS.count {
            VIEWS[i].tag = i; VIEWS[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AGREE_V(_:))))
        }
        
        VC_SIGNUP_B.addTarget(self, action: #selector(VC_SIGNUP_B(_:)), for: .touchUpInside)
    }
    
    @objc func AGREE_V(_ sender: UITapGestureRecognizer) {
        
        let VIEWS: [UIView] = [AGREE_V1, AGREE_V2, AGREE_V3]
        let IMAGES: [UIImageView] = [AGREE_I1, AGREE_I2, AGREE_I3]
        let LABELS: [UILabel] = [AGREE_L1_1, AGREE_L2, AGREE_L3]
        let HTMLS: [String] = ["", "개인정보 처리방침 (위치정보 포함)", "서비스 이용약관 (전자상거래 포함)"]
        let IDX: Int = sender.view!.tag
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_HTML") as! VC_HTML
        
        if IDX == 0 && !BOOLS[0] {
            for i in 0 ..< VIEWS.count { BOOLS[i] = true; VIEWS[i].backgroundColor = .H_00529C.withAlphaComponent(0.5); IMAGES[i].image = UIImage(named: "check_on2"); LABELS[i].textColor = .white; AGREE_L1_2.textColor = .white }
        } else if IDX == 0 && BOOLS[0] {
            for i in 0 ..< VIEWS.count { BOOLS[i] = false; VIEWS[i].backgroundColor = .H_F1F1F1; IMAGES[i].image = UIImage(named: "check_off"); LABELS[i].textColor = .black; AGREE_L1_2.textColor = .black }
        } else {
            for I in 1 ..< VIEWS.count {
                if IDX == I && !BOOLS[IDX] {
                    BOOLS[I] = true; VIEWS[I].backgroundColor = .H_00529C.withAlphaComponent(0.5); IMAGES[I].image = UIImage(named: "check_on2"); LABELS[I].textColor = .white
                    VC.TITLE = HTMLS[I]; VC.POSITION = I; navigationController?.pushViewController(VC, animated: true)
                } else if IDX == I && BOOLS[IDX] {
                    BOOLS[0] = false; VIEWS[0].backgroundColor = .H_F1F1F1; IMAGES[0].image = UIImage(named: "check_off"); LABELS[0].textColor = .black; AGREE_L1_2.textColor = .black
                    BOOLS[I] = false; VIEWS[I].backgroundColor = .H_F1F1F1; IMAGES[I].image = UIImage(named: "check_off"); LABELS[I].textColor = .black
                }
                if BOOLS[1] && BOOLS[2] { BOOLS[0] = true; VIEWS[0].backgroundColor = .H_00529C.withAlphaComponent(0.5); IMAGES[0].image = UIImage(named: "check_on2"); LABELS[0].textColor = .white; AGREE_L1_2.textColor = .white }
            }
        }
    }
    
    @objc func VC_SIGNUP_B(_ sender: UIButton) {
        if BOOLS[0] || (BOOLS[1] && BOOLS[2]) { segueViewController(identifier: "VC_SIGNUP") } else { S_NOTICE("이용약관 (!)") }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}

extension VC_AGREEMENT: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        if OFFSET_Y > 35 { HEADER_L.alpha = (OFFSET_Y-35)/35 } else { HEADER_L.alpha = 0.0 }
    }
}
