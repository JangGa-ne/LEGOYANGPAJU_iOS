//
//  PangpangCouponViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/09.
//

import UIKit
import FirebaseFirestore

class PangpangCouponViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var type: String = "download"
    
    var StoreObject: StoreData = StoreData()
    var MemberPangpangHistoryObject: MemberPangpangHistoryData = MemberPangpangHistoryData()
    
    @IBAction func backButton(_ sender: UIButton) { dismiss(animated: false, completion: nil) }
    
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var pangpangView: UIView!
    @IBOutlet weak var pangpangImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    @IBOutlet weak var couponDownloadView: UIView!
    @IBOutlet weak var couponDownloadButton: UIButton!
    
    @IBOutlet weak var DetailView: UIView!
    @IBOutlet weak var DetailImageView: UIImageView!
    @IBOutlet weak var DetailExitButton: UIButton!
    
    @IBOutlet weak var couponSignView: UIView!
    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var passwordStackView: UIStackView!
    @IBOutlet weak var passwordTextField_1: UITextField!
    @IBOutlet weak var passwordTextField_2: UITextField!
    @IBOutlet weak var passwordTextField_3: UITextField!
    @IBOutlet weak var passwordTextField_4: UITextField!
    @IBOutlet weak var passwordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.PangpangCouponViewControllerDelegate = self
        
        if type == "download" {
            
            couponSignView.isHidden = true
            
            pangpangView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pangpangViewTap(_:))))
            storeNameLabel.text = StoreObject.storeName
            setImageNuke(imageView: pangpangImageView, placeholder: UIImage(named: "logo3"), imageUrl: StoreObject.pangpangImage, cornerRadius: 5, contentMode: .scaleAspectFill)
            mainTitleLabel.text = "\(StoreObject.pangpangMenu) 무료쿠폰"
            
            DetailView.isHidden = true
            setImageNuke(imageView: DetailImageView, placeholder: UIImage(named: "logo3"), imageUrl: StoreObject.pangpangImage, cornerRadius: 10, contentMode: .scaleAspectFit)
            DetailExitButton.addTarget(self, action: #selector(DetailExitButton(_:)), for: .touchUpInside)
            
            couponDownloadView.isHidden = false
            couponDownloadButton.addTarget(self, action: #selector(couponDownloadButton(_:)), for: .touchUpInside)
            
            if let delegate = UIViewController.TutorialViewControllerDelegate {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { delegate.loadingData(level: 4, image: self.couponView.toImage(), y: self.couponView.frame.minY, imageHeight: self.couponView.frame.height) }
            }
            
        } else if type == "password" {
            
            couponSignView.isHidden = false
            passwordStackView.isHidden = false
            for textField in [passwordTextField_1, passwordTextField_2, passwordTextField_3, passwordTextField_4] {
                textField?.addTarget(self, action: #selector(textField(_:)), for: .editingChanged); textField?.delegate = self
            }
            passwordButton.addTarget(self, action: #selector(passwordButton(_:)), for: .touchUpInside)
            qrcodeImageView.isHidden = true
            
            couponDownloadView.isHidden = true
            
        } else if type == "qrcode" {
            
            couponSignView.isHidden = false
            passwordStackView.isHidden = true
            qrcodeImageView.isHidden = false
            qrcodeImageView.image = setQrcodeImage("\(MemberPangpangHistoryObject.useStoreId)|}{\(UIViewController.appDelegate.MemberObject.number)|}{\(UIViewController.appDelegate.MemberObject.id)|}{\(UIViewController.appDelegate.MemberObject.nick)|}{\(MemberPangpangHistoryObject.receiveTime)")
            
            couponDownloadView.isHidden = true
        }
    }
    
    @objc func pangpangViewTap(_ sender: UITapGestureRecognizer) {
        DetailView.isHidden = false
    }
    
    func setQrcodeImage(_ string: String) -> UIImage? {
        // 한글을 포함한 문자열을 NSData로 변환합니다.
        let data = string.data(using: String.Encoding.utf8)
        
        // QR 코드 생성을 위한 CIFilter를 생성합니다.
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        // 필터에 입력값을 지정합니다.
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue("H", forKey: "inputCorrectionLevel") // 오류 정정 레벨을 "H"로 지정합니다.
        
        // QR 코드 이미지를 생성합니다.
        guard let qrImage = qrFilter.outputImage else { return nil }
        
        // 이미지를 크기 조정합니다.
        let scaleX = UIScreen.main.scale
        let transformedImage = qrImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleX))
        
        // UIImage를 생성하여 반환합니다.
        return UIImage(ciImage: transformedImage)
    }
    
    @objc func DetailExitButton(_ sender: UIButton) {
        DetailView.isHidden = true
    }
    
    @objc func couponDownloadButton(_ sender: UIButton) {
        
        Firestore.firestore().collection("member_pangpang_history").document(UIViewController.appDelegate.MemberId).getDocument { response, error in
            
            var getCoupon: Bool = false
            
            let _: [()] = response?.data()?.compactMap({ (key: String, value: Any) in
                
                let dict = response?.data()?[key] as? [String: Any] ?? [:]
                
                let useStoreId = dict["use_store_id"] as? String ?? ""
                let useTime = dict["use_time"] as? String ?? ""
                let writeReview = dict["write_review"] as? String ?? ""
                
                if (self.StoreObject.storeId == useStoreId) && (UIViewController.appDelegate.MemberId != "01034231219") && (UIViewController.appDelegate.MemberId != "01031853309") {
                    
                    getCoupon = true
                    
                    if (useTime == "0") && (writeReview == "false") {
                        
                        self.dismiss(animated: false) {
                            if let delegate = UIViewController.TabBarControllerDelegate {
                                let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
                                segue.modalPresentationStyle = .overFullScreen
                                segue.type = "coupon_notUse"
                                delegate.present(segue, animated: false, completion: nil)
                            }
                        }
                        
                    } else if (useTime != "0") && (writeReview == "false") {
                        
                        self.dismiss(animated: false) {
                            if let delegate = UIViewController.TabBarControllerDelegate {
                                let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
                                segue.modalPresentationStyle = .overFullScreen
                                segue.type = "coupon_review"
                                delegate.present(segue, animated: false, completion: nil)
                            }
                        }
                        
                    } else if (useTime != "0") && (writeReview == "true") {
                        
                        self.dismiss(animated: false) {
                            if let delegate = UIViewController.TabBarControllerDelegate {
                                let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
                                segue.modalPresentationStyle = .overFullScreen
                                segue.type = "coupon_useCoupon"
                                delegate.present(segue, animated: false, completion: nil)
                            }
                        }
                    }
                    
                    return
                }
            }) ?? []
            
            if getCoupon { return }
            
            let timestamp: String = "\(self.setKoreaTimestamp())"
            
            let memberPangpangHistoryParams: [String: Any] = [
                timestamp: [
                    "receive_time": timestamp,
                    "review_idx": "",
                    "use_menu": self.StoreObject.pangpangMenu,
                    "use_store_id": self.StoreObject.storeId,
                    "use_store_name": self.StoreObject.storeName,
                    "use_time": "0",
                    "write_review": "false"
                ]
            ]
            Firestore.firestore().collection("member_pangpang_history").document(UIViewController.appDelegate.MemberId).setData(memberPangpangHistoryParams, merge: true)
            
            let storePangpangHistoryParams: [String: Any] = [
                timestamp: [
                    "receive_time": timestamp,
                    "review_idx": "",
                    "use_menu": self.StoreObject.pangpangMenu,
                    "use_nick": UIViewController.appDelegate.MemberObject.nick,
                    "use_num": UIViewController.appDelegate.MemberObject.number,
                    "use_time": "0",
                    "write_review": "false"
                ]
            ]
            Firestore.firestore().collection("pangpang_history").document(self.StoreObject.storeId).setData(storePangpangHistoryParams, merge: true)
            
            self.dismiss(animated: false) {
                if let delegate = UIViewController.TabBarControllerDelegate {
                    let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
                    segue.modalPresentationStyle = .overFullScreen
                    segue.type = "coupon_download"
                    delegate.present(segue, animated: false, completion: nil)
                }
            }
        }
    }
    
    @objc func textField(_ sender: UITextField) {
        sender.text?.remove(at: sender.text!.startIndex)
    }
    
    @objc func passwordButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        let pangpangPassword = passwordTextField_1.text!+passwordTextField_2.text!+passwordTextField_3.text!+passwordTextField_4.text!
        let timestamp = setKoreaTimestamp()
        
        if pangpangPassword.count < 4 {
            S_NOTICE("번호 (!)")
        } else {
            
            Firestore.firestore().collection("store").document(self.StoreObject.storeId).getDocument { response, error in
                
                if response?.data()?["pangpang_pw"] as? String ?? "" != pangpangPassword {
                    self.S_NOTICE("인증 실패")
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
                            self.dismiss(animated: false, completion: nil)
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
        
        UIViewController.PangpangCouponViewControllerDelegate = nil
    }
}

extension PangpangCouponViewController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 1
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if newText.count <= maxLength {
            
            textField.text = newText
            
            switch textField {
            case passwordTextField_1:
                passwordTextField_2.becomeFirstResponder()
            case passwordTextField_2:
                passwordTextField_3.becomeFirstResponder()
            case passwordTextField_3:
                passwordTextField_4.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
            }
            
            return false
        }
        
        return true
    }
}
