//
//  PhoneCheckViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/05/07.
//

import UIKit
import Bootpay
import FirebaseFirestore

class PhoneCheckViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    var number: String = ""
    
    @IBAction func backButton(_ sender: UIButton) { UIViewController.appDelegate.SignupObject.removeAll(); dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberCheckButton: UIButton!
    @IBOutlet weak var phoneNumberCheckLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboard()
        
        UIViewController.PhoneCheckViewControllerDelegate = self
        
        phoneNumberTextField.placeholder("휴대전화", COLOR: .lightGray)
        phoneNumberTextField.text = number
        phoneNumberTextField.addTarget(self, action: #selector(phoneNumberCheckLabel(_:)), for: .editingChanged)
        phoneNumberCheckButton.addTarget(self, action: #selector(phoneNumberCheckButton(_:)), for: .touchUpInside)
        
        if UserDefaults.standard.bool(forKey: "check_phone") {
            phoneNumberCheckLabel.isHidden = false
        } else {
            phoneNumberCheckLabel.isHidden = true
        }
        
        signupButton.addTarget(self, action: #selector(signupButton(_:)), for: .touchUpInside)
    }
    
    @objc func phoneNumberCheckLabel(_ sender: UITextField) {
        
        UserDefaults.standard.setValue(false, forKey: "check_phone")
        phoneNumberCheckLabel.isHidden = true
    }
    
    @objc func phoneNumberCheckButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        UserDefaults.standard.setValue(false, forKey: "check_phone")
        
        if (phoneNumberTextField.text! == "") || ((phoneNumberTextField.text?.count ?? 0) != 11) {
            S_NOTICE("휴대전화 (!)")
        } else {
            
            let payload = Payload()
            payload.applicationId = "63718f88cf9f6d002023e415"
            payload.price = 0
            payload.authenticationId = "\(setKoreaTimestamp())"
            payload.pg = "danal"
            payload.method = "본인인증"
            payload.orderName = "레고양파주 본인인증: \(setHyphen("phone", phoneNumberTextField.text!))"
            
            let user = BootUser()
            user.phone = phoneNumberTextField.text!
            payload.user = user
            
            let extra = BootExtra()
            extra.openType = "iframe"
            payload.extra = extra
            
            Bootpay.requestAuthentication(viewController: self, payload: payload)
            .onCancel { data in
                print("-- cancel: \(data)")
            }
            .onIssued { data in
                print("-- issued: \(data)")
            }
            .onConfirm { data in
                print("-- confirm: \(data)")
                return true
            }
            .onDone { data in
                print("-- done: \(data)")
                self.S_NOTICE("본인인증 확인됨")
                
                UserDefaults.standard.setValue(true, forKey: "check_phone")
                
                if let delegate_1 = UIViewController.SafariViewControllerDelegate {
                    
                    delegate_1.navigationController?.popViewController(animated: true)
                    
                    if let delegate_2 = UIViewController.LoginAAViewControllerDelegate {
                        
                        let segue = self.storyboard?.instantiateViewController(withIdentifier: "PhoneCheckViewController") as! PhoneCheckViewController
                        segue.modalPresentationStyle = .overCurrentContext; segue.transitioningDelegate = self
                        segue.number = delegate_1.number
                        delegate_2.present(segue, animated: true, completion: nil)
                    }
                }
            }
            .onError { data in
                print("-- error: \(data)")
                let DICT = data as [String: Any]
                self.S_NOTICE(DICT["message"] as? String ?? "")
            }
            .onClose {
                print("-- close")
            }
            
            dismiss(animated: true, completion: nil)
            
            if let delegate = UIViewController.LoginAAViewControllerDelegate {
                
                let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "SafariViewController") as! SafariViewController
                segue.bootpay = true; segue.number = phoneNumberTextField.text!; segue.titleName = "본인인증"
                delegate.navigationController?.pushViewController(segue, animated: true)
            }
        }
    }
    
    @objc func signupButton(_ sender: UIButton) {
        
        if !UserDefaults.standard.bool(forKey: "check_phone") {
            S_NOTICE("본인인증 (!)")
        } else {
            
            var check_member: Bool = false
            var platform: String = ""
            
            let DispatchGroup = DispatchGroup()
            
            DispatchGroup.enter()
            DispatchQueue.global().async {
                
                Firestore.firestore().collection("member").whereField("number", isEqualTo: self.number).getDocuments { responses, error in
                    
                    guard let responses = responses else { return }
                    
                    for response in responses.documents {
                        if response.documentID == self.phoneNumberTextField.text! {
                            check_member = true
                            platform = response["platform"] as? String ?? ""
                        }
                    }
                    
                    DispatchGroup.leave()
                }
            }
            
            DispatchGroup.notify(queue: .main) {
                
                if check_member {
                    
                    let alert = UIAlertController(title: "알림", message: "\(platform)(으)로 가입된 이력이 있습니다.\n그래도 가입하시겠습니까?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "회원가입", style: .default, handler: { _ in
                        self.loadingData()
                    }))
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    self.loadingData()
                }
            }
        }
    }
    
    func loadingData() {
        
        let dict = UIViewController.appDelegate.SignupObject
        var params: [String: Any] = [
            "benefit_point": "0",
            "fcm_id": UserDefaults.standard.string(forKey: "fcm_id") ?? "",
            "free_delivery_coupon": 0,
            "email": dict["email"] as? String ?? "",
            "grade": "1",
            "legonggu_topic": "true",
            "name": dict["name"] as? String ?? "",
            "nick": dict["nick"] as? String ?? "",
            "os_platform": "ios",
            "password": String((0..<15).compactMap{ _ in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()_+".randomElement() }),
            "number": self.number,
            "platform": dict["platform"] as? String ?? "",
            "point": "0",
            "profile_img": dict["profile_img"] as? String ?? "",
            "pangpang_topic": "true",
            "signup_time": "\(self.setKoreaTimestamp()+32400000)",
        ]
        
        if dict["platform"] as? String ?? "" == "apple" {
            params["id"] = UserDefaults.standard.string(forKey: "apple_id") ?? ""
        } else {
            params["id"] = dict["email"] as? String ?? ""
        }
        
        Firestore.firestore().collection("member").document(self.number).setData(params, merge: true) { error in
            
            if error == nil {
                
                self.S_NOTICE("회원가입 성공")
                
                self.dismiss(animated: true, completion: nil)
                
                if let delegate = UIViewController.LoginAAViewControllerDelegate {
                    
                    UIViewController.appDelegate.MemberId = self.phoneNumberTextField.text!
                    UserDefaults.standard.setValue(self.phoneNumberTextField.text!, forKey: "member_id")
                    UserDefaults.standard.synchronize()
                    delegate.segueViewController(identifier: "LoadingViewController")
                }
                
            } else {
                self.S_NOTICE("회원가입 실패")
            }
        }
    }
}
