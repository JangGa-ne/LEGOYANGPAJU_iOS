//
//  LoginViewController.swift
//  legoyang
//
//  Created by 장 제현 on 2022/09/17.
//

import UIKit
import NaverThirdPartyLogin
import AuthenticationServices

class LoginViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    let NAVER = NaverThirdPartyLoginConnection.getSharedInstance()
    
    @IBOutlet weak var HEADER_L: UILabel!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    @IBOutlet weak var ID_TF: UITextField!
    @IBOutlet weak var PW_TF: UITextField!
    @IBOutlet weak var VC_FIND_B: UIButton!
    @IBOutlet weak var LOGIN_B: UIButton!
    @IBOutlet weak var NAVER_B: UIButton!
    @IBOutlet weak var KAKAO_B: UIButton!
    @IBOutlet weak var APPLE_B: UIButton!
    @IBOutlet weak var VC_AGREEMENT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.LoginViewController_DEL = self
        
        setKeyboard()
        
        HEADER_L.alpha = 0.0
        
        ID_TF.placeholder("아이디", COLOR: .lightGray)
        PW_TF.placeholder("비밀번호", COLOR: .lightGray)
        
        loadView2()
    }
    
    func loadView2() {
        
        NAVER_B.isHidden = UIViewController.appDelegate.OBJ_MAIN.ENABLE_ID
        KAKAO_B.isHidden = UIViewController.appDelegate.OBJ_MAIN.ENABLE_ID
        if #available(iOS 13.0, *) { APPLE_B.isHidden = false } else { APPLE_B.isHidden = true }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCROLLVIEW.delegate = self
        
        VC_FIND_B.addTarget(self, action: #selector(VC_FIND_B(_:)), for: .touchUpInside)
        
        LOGIN_B.tag = 0; LOGIN_B.addTarget(self, action: #selector(LOGIN_B(_:)), for: .touchUpInside)
        NAVER_B.tag = 1; NAVER_B.addTarget(self, action: #selector(LOGIN_B(_:)), for: .touchUpInside)
        KAKAO_B.tag = 2; KAKAO_B.addTarget(self, action: #selector(LOGIN_B(_:)), for: .touchUpInside)
        APPLE_B.tag = 3; APPLE_B.addTarget(self, action: #selector(LOGIN_B(_:)), for: .touchUpInside)
        
        VC_AGREEMENT_B.addTarget(self, action: #selector(VC_AGREEMENT_B(_:)), for: .touchUpInside)
    }
    
    @objc func LOGIN_B(_ sender: UIButton) { ID_TF.resignFirstResponder(); PW_TF.resignFirstResponder()
        
        if sender.tag == 0 {
            if ID_TF.text! == "" {
                S_NOTICE("아이디 (!)")
            } else if PW_TF.text! == "" {
                S_NOTICE("비밀번호 (!)")
            } else {
                GET_LOGIN1(NAME: "로그인", AC_TYPE: "member")
            }
        } else if sender.tag == 1 {
            NAVER?.delegate = self; NAVER?.requestThirdPartyLogin()
        } else if sender.tag == 2 {
            GET_KAKAO1(NAME: "KAKAO", AC_TYPE: "kakao")
        } else if sender.tag == 3, #available(iOS 13.0, *) {
            GET_APPLE(NAME: "APPLE", AC_TYPE: "apple")
        }
    }
    
    @objc func VC_FIND_B(_ sender: UIButton) { ID_TF.resignFirstResponder(); PW_TF.resignFirstResponder()
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_FIND") as! VC_FIND
        let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ALERT.addAction(UIAlertAction(title: "아이디 찾기", style: .default, handler: { _ in
            VC.FIND_TYPE = "id"; self.navigationController?.pushViewController(VC, animated: true)
        }))
        ALERT.addAction(UIAlertAction(title: "비밀번호 찾기", style: .default, handler: { _ in
            VC.FIND_TYPE = "pw"; self.navigationController?.pushViewController(VC, animated: true)
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(ALERT, animated: true, completion: nil)
    }
    
    @objc func VC_AGREEMENT_B(_ sender: UIButton) { ID_TF.resignFirstResponder(); PW_TF.resignFirstResponder()
        UIViewController.appDelegate.OBJ_VIRTUAL_USER = API_VIRTUAL_USER(EMAIL: "", IMG: "", NAME: "", NICK: "", TYPE: "lego", USER: ""); segueViewController(identifier: "VC_AGREEMENT")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false); NAVER?.requestDeleteToken(); UserDefaults.standard.removeObject(forKey: "document")
    }
}

extension LoginViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        if OFFSET_Y > 335 { HEADER_L.alpha = (OFFSET_Y-335)/35 } else { HEADER_L.alpha = 0.0 }
    }
}
