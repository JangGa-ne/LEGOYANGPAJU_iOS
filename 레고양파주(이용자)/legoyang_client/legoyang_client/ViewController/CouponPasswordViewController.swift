//
//  CouponPasswordViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/05/19.
//

import UIKit
import FirebaseFirestore

class CouponPasswordViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var StoreObject: StoreData = StoreData()
    var row: Int = 0
    var MemberPangpangHistoryObject: MemberPangpangHistoryData = MemberPangpangHistoryData()
    var password: [String] = []
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var passwordTextField_1: UITextField!
    @IBOutlet weak var passwordTextField_2: UITextField!
    @IBOutlet weak var passwordTextField_3: UITextField!
    @IBOutlet weak var passwordTextField_4: UITextField!

    @IBOutlet weak var pangpangImageView: UIImageView!
    @IBOutlet weak var pangpangNameLabel: UILabel!
    
    @IBOutlet weak var numberPad1Button: UIButton!
    @IBOutlet weak var numberPad2Button: UIButton!
    @IBOutlet weak var numberPad3Button: UIButton!
    @IBOutlet weak var numberPad4Button: UIButton!
    @IBOutlet weak var numberPad5Button: UIButton!
    @IBOutlet weak var numberPad6Button: UIButton!
    @IBOutlet weak var numberPad7Button: UIButton!
    @IBOutlet weak var numberPad8Button: UIButton!
    @IBOutlet weak var numberPad9Button: UIButton!
    @IBOutlet weak var numberPad0Button: UIButton!
    @IBOutlet weak var numberPadDeleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.CouponPasswordViewControllerDelegate = self
        
        for (i, textField) in [passwordTextField_1, passwordTextField_2, passwordTextField_3, passwordTextField_4].enumerated() {
            textField?.tag = i; textField?.isEnabled = false
        }
        
        titleLabel.text = StoreObject.storeName
        
        passwordTextField_1.layer.borderWidth = 2
        passwordTextField_1.layer.borderColor = UIColor.systemBlue.cgColor
        
        if StoreObject.pangpangImage != "" {
            setImageNuke(imageView: pangpangImageView, placeholder: UIImage(named: "logo3"), imageUrl: StoreObject.pangpangImage, cornerRadius: 5, contentMode: .scaleAspectFill)
        } else {
            pangpangImageView.image = UIImage(named: "logo3")
        }
        pangpangNameLabel.text = "\(StoreObject.pangpangMenu) 무료쿠폰"
        
        for (i, button) in [numberPad1Button, numberPad2Button, numberPad3Button, numberPad4Button, numberPad5Button, numberPad6Button, numberPad7Button, numberPad8Button, numberPad9Button, numberPad0Button, numberPadDeleteButton].enumerated() {
            button?.tag = i; button?.addTarget(self, action: #selector(numberPadButton(_:)), for: .touchUpInside)
        }
    }
    
    @objc func numberPadButton(_ sender: UIButton) {
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if (password.count != 0) && (sender.tag == 10) {
            password.remove(at: password.count-1)
        } else if (password.count < 4) && (sender.tag != 10) {
            password.append(sender.titleLabel?.text! ?? "")
        }
        
        for textField in [passwordTextField_1, passwordTextField_2, passwordTextField_3, passwordTextField_4] {
            textField?.text?.removeAll()
        }
        
        for i in 0 ..< password.count {
            if i == 0 {
                passwordTextField_1.text = password[i]
                passwordTextField_1.layer.borderWidth = 2
                passwordTextField_1.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                passwordTextField_1.layer.borderWidth = 0.5
                passwordTextField_1.layer.borderColor = UIColor.darkGray.cgColor
            }
            if i == 1 {
                passwordTextField_2.text = password[i]
                passwordTextField_2.layer.borderWidth = 2
                passwordTextField_2.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                passwordTextField_2.layer.borderWidth = 0.5
                passwordTextField_2.layer.borderColor = UIColor.darkGray.cgColor
            }
            if i == 2 {
                passwordTextField_3.text = password[i]
                passwordTextField_3.layer.borderWidth = 2
                passwordTextField_3.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                passwordTextField_3.layer.borderWidth = 0.5
                passwordTextField_3.layer.borderColor = UIColor.darkGray.cgColor
            }
            if i == 3 {
                passwordTextField_4.text = password[i]
                passwordTextField_4.layer.borderWidth = 2
                passwordTextField_4.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                passwordTextField_4.layer.borderWidth = 0.5
                passwordTextField_4.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
        
        if password.count == 4 {
            
            let pangpangPassword = passwordTextField_1.text!+passwordTextField_2.text!+passwordTextField_3.text!+passwordTextField_4.text!
            let timestamp = setKoreaTimestamp()
            
            Firestore.firestore().collection("store").document(self.StoreObject.storeId).getDocument { response, error in
                
                let pangpangPw = response?.data()?["pangpang_pw"] as? String ?? ""
                let pangpangRemain = response?.data()?["pangpang_remain"] as? Int ?? 0
                
                if (pangpangPw != pangpangPassword) || (pangpangRemain == 0) {
                    
                    if pangpangPw != pangpangPassword {
                        self.S_NOTICE("비밀번호 (!)")
                    } else if pangpangRemain == 0 {
                        self.S_NOTICE("쿠폰 잔여부족")
                    }
                    
                    self.password.removeAll()
                    
                    for (i, textField) in [self.passwordTextField_1, self.passwordTextField_2, self.passwordTextField_3, self.passwordTextField_4].enumerated() {
                        
                        textField?.text?.removeAll()
                        textField?.layer.borderWidth = 2
                        textField?.layer.borderColor = UIColor.systemRed.cgColor
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                            if i == 0 {
                                textField?.layer.borderWidth = 2
                                textField?.layer.borderColor = UIColor.systemBlue.cgColor
                            } else {
                                textField?.layer.borderWidth = 0.5
                                textField?.layer.borderColor = UIColor.darkGray.cgColor
                            }
                        }
                    }
                    
                } else {
                    
                    var checkError: Bool = false
                    let DispatchGroup = DispatchGroup()
                    
                    DispatchGroup.enter()
                    DispatchQueue.global().async {
                        
                        if self.StoreObject.storeId == "01099999999" {
                            checkError = false; DispatchGroup.leave()
                        } else {
                            
                            let params: [String: Any] = [
                                "\(self.MemberPangpangHistoryObject.receiveTime)": [
                                    "receive_time": self.MemberPangpangHistoryObject.receiveTime,
                                    "review_idx": "",
                                    "use_menu": self.MemberPangpangHistoryObject.useMenu,
                                    "use_nick": UIViewController.appDelegate.MemberObject.nick,
                                    "use_num": UIViewController.appDelegate.MemberObject.number,
                                    "use_time": "\(timestamp)",
                                    "write_review": "false"
                                ]
                            ]
                            
                            Firestore.firestore().collection("pangpang_history").document(self.StoreObject.storeId).updateData(params) { error in
                                if error == nil { checkError = false } else { checkError = true }; DispatchGroup.leave()
                            }
                        }
                    }
                    
                    DispatchGroup.enter()
                    DispatchQueue.global().async {
                        
                        let params: [String: Any] = [
                            "\(self.MemberPangpangHistoryObject.receiveTime)": [
                                "receive_time": self.MemberPangpangHistoryObject.receiveTime,
                                "review_idx": self.MemberPangpangHistoryObject.receiveTime+UIViewController.appDelegate.MemberObject.id,
                                "use_menu": self.MemberPangpangHistoryObject.useMenu,
                                "use_time": "\(timestamp)",
                                "use_store_id": self.StoreObject.storeId,
                                "use_store_name": self.StoreObject.storeName,
                                "write_review": "false"
                            ]
                        ]
                        
                        Firestore.firestore().collection("member_pangpang_history").document(UIViewController.appDelegate.MemberId).updateData(params) { error in
                            if error == nil { checkError = false } else { checkError = true }; DispatchGroup.leave()
                        }
                    }
                    
                    DispatchGroup.notify(queue: .main) {
                        
                        if !checkError {
                            
                            Firestore.firestore().collection("store").document(self.StoreObject.storeId).setData(["pangpang_remain": self.StoreObject.pangpangRemain-1], merge: true) { _ in
                                
                                if let refresh_1 = UIViewController.MainViewControllerDelegate, UIViewController.appDelegate.MemberPangpangHistoryObject.count > self.row {
                                    UIViewController.appDelegate.MainPangpangStoreObject[self.row].pangpangRemain -= 1; refresh_1.listView.reloadData()
                                }
                                if let refresh_2 = UIViewController.StoreViewControllerDelegate {
                                    UIViewController.appDelegate.StoreObject[self.row].pangpangRemain -= 1; refresh_2.listView.reloadData()
                                }
                                if let refresh_3 = UIViewController.CouponPasswordViewControllerDelegate {
                                    refresh_3.StoreObject.pangpangRemain -= 1
                                }
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            self.S_NOTICE("오류 (!)")
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIViewController.CouponPasswordViewControllerDelegate = nil
    }
}
