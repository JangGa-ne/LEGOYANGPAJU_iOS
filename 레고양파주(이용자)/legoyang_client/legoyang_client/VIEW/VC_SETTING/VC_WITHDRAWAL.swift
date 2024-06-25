//
//  VC_WITHDRAWAL.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2023/01/03.
//

import UIKit

class VC_WITHDRAWAL: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var AGREE_B: UIButton!
    @IBOutlet weak var WITHDRAWAL_V: UIView!
    @IBOutlet weak var WITHDRAWAL_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        WITHDRAWAL_V.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AGREE_B.addTarget(self, action: #selector(AGREE_B(_:)), for: .touchUpInside)
        WITHDRAWAL_B.addTarget(self, action: #selector(WITHDRAWAL_B(_:)), for: .touchUpInside)
    }
    
    @objc func AGREE_B(_ sender: UIButton) {
        WITHDRAWAL_V.isHidden = false
    }
    
    @objc func WITHDRAWAL_B(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: "", message: "정말 회원탈퇴 하시겠습니까?", preferredStyle: .alert)
        
        ALERT.addAction(UIAlertAction(title: "회원탈퇴", style: .destructive, handler: { _ in
            self.PUT_WITHDRAWAL(NAME: "회원탈퇴", AC_TYPE: "member")
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(ALERT, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}
