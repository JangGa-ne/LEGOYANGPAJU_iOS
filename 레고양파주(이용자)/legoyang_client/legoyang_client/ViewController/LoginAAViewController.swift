//
//  LoginAAViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/05/07.
//

import UIKit
import Alamofire
import FirebaseFirestore
import NaverThirdPartyLogin
import KakaoSDKUser
import AuthenticationServices

class LoginAAViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var detail: Bool = false
    let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
//    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var memberIdTextField: UITextField!
    @IBOutlet weak var memberPwTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var naverButton: UIButton!
    @IBOutlet weak var kakaoButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboard()
        
        UIViewController.LoginAAViewControllerDelegate = self
        
        backView.isHidden = detail
        
        memberIdTextField.placeholder("아이디", COLOR: .lightGray)
        memberPwTextField.placeholder("비밀번호", COLOR: .lightGray)
        
        findButton.tag = 0; findButton.addTarget(self, action: #selector(button(_:)), for: .touchUpInside)
        
        for (i, button) in [loginButton, naverButton, kakaoButton, appleButton].enumerated() {
            button?.tag = i; button?.addTarget(self, action: #selector(loginButton(_:)), for: .touchUpInside)
        }
        
        signupButton.tag = 1; signupButton.addTarget(self, action: #selector(button(_:)), for: .touchUpInside)
    }
    
    @objc func loginButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        if sender.tag == 0 {
            
            if memberIdTextField.text! == "" {
                S_NOTICE("아이디 (!)")
            } else if memberPwTextField.text! == "" {
                S_NOTICE("비밀번호 (!)")
            } else {
                
                loadingData(id:  memberIdTextField.text!, platform: "lego") { login in

                    if login {
                        self.segueViewController(identifier: "LoadingViewController")
                    } else {
                        self.S_NOTICE("로그인 실패")
                        self.memberIdTextField.text?.removeAll()
                        self.memberPwTextField.text?.removeAll()
                    }
                }
            }
            
        } else if sender.tag == 1 {
            naverInstance?.delegate = self; naverInstance?.requestThirdPartyLogin()
        } else if sender.tag == 2 {
            
            let DispatchGroup = DispatchGroup()
            
            DispatchGroup.enter()
            DispatchQueue.global().async {
                
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk { _, error in if error == nil { DispatchGroup.leave() } }
                } else {
                    UserApi.shared.loginWithKakaoAccount { _, error in if error == nil { DispatchGroup.leave() } }
                }
            }
            
            DispatchGroup.notify(queue: .main) {
                
                UserApi.shared.me { response, error in
                    
                    guard let response = response?.kakaoAccount else { return }
                    
                    self.loadingData(id: response.email ?? "", platform: "kakao") { login in

                        if login {
                            self.segueViewController(identifier: "LoadingViewController")
                        } else {
                            self.loadingData2(name: response.profile?.nickname ?? "", nick: response.profile?.nickname ?? "", email: response.email ?? "", profile_img: "\(response.profile?.profileImageUrl as Any)", platform: "kakao")
                        }
                    }
                }
            }
            
        } else if sender.tag == 3, #available(iOS 13.0, *) {
            
            let appleRequest = ASAuthorizationAppleIDProvider().createRequest()
            appleRequest.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [appleRequest])
            controller.delegate = self; controller.presentationContextProvider = self; controller.performRequests()
        }
    }
    
    func loadingData(id: String, platform: String, completion: @escaping (Bool) -> Void) {
        
        print(id)
        
        Firestore.firestore().collection("member").whereField("id", isEqualTo: id).whereField("platform", isEqualTo: platform).getDocuments { responses, error in
            
            guard let responses = responses else { completion(false); return }
            
            if responses.count == 0 { completion(false); return }
            
            for response in responses.documents {
                
                if (response.data()["password"] as? String ?? "" != self.memberPwTextField.text!) && (platform == "lego") {
                    self.S_NOTICE("비밀번호 (!)"); return
                } else if response.data()["secession"] as? String ?? "" != "" {
                    
                    let alert = UIAlertController(title: "알림", message: "회원탈퇴 요청한 계정입니다. \n 복구하시겠습니까?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "복구하기", style: .default, handler: { _ in
                        Firestore.firestore().collection("member").document(response.documentID).setData(["secession": FieldValue.delete()], merge: true) { error in
                            if error == nil {
                                self.S_NOTICE("계정 복구됨")
                                UIViewController.appDelegate.MemberId = response.documentID
                                UserDefaults.standard.setValue(response.documentID, forKey: "member_id")
                                UserDefaults.standard.synchronize()
                                completion(true)
                            }
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    UIViewController.appDelegate.MemberId = response.documentID
                    UserDefaults.standard.setValue(response.documentID, forKey: "member_id")
                    UserDefaults.standard.synchronize()
                    completion(true)
                }
            }
        }
    }
    
    func loadingData2(name: String, nick: String, email: String, profile_img: String, platform: String) {
        
        UIViewController.appDelegate.SignupObject = ["name": name, "nick": nick, "email": email, "profile_img": profile_img, "platform": platform]
        
        UserDefaults.standard.setValue(false, forKey: "check_phone")
        
        let segue = storyboard?.instantiateViewController(withIdentifier: "PhoneCheckViewController") as! PhoneCheckViewController
        segue.modalPresentationStyle = .overCurrentContext; segue.transitioningDelegate = self
        present(segue, animated: true, completion: nil)
    }
    
    @objc func button(_ sender: UIButton) {
        
        if sender.tag == 0 {
            segueViewController(identifier: "VC_FIND")
        } else if sender.tag == 1 {
            segueViewController(identifier: "VC_AGREEMENT")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(detail)
        
        naverInstance?.requestDeleteToken()
    }
}

extension LoginAAViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        
//        // 현재시간 확인
//        if naverInstance?.isValidAccessTokenExpireTimeNow() ?? false {
//
//        } else {
//
//        }
        
        guard let tokenType = naverInstance?.tokenType else { return }
        guard let accessToken = naverInstance?.accessToken else { return }
        guard let postUrl = URL(string: "https://openapi.naver.com/v1/nid/me") else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "\(tokenType) \(accessToken)"
        ]
        
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 5
        manager.request(postUrl, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(_):
                
                guard let mainDict = response.value as? [String: Any] else { return }
                guard let subDict = mainDict["response"] as? [String: Any] else { return }
                
                self.loadingData(id: subDict["email"] as? String ?? "", platform: "naver") { login in
                    
                    if login {
                        self.segueViewController(identifier: "LoadingViewController")
                    } else {
                        self.loadingData2(name: subDict["name"] as? String ?? "", nick: subDict["name"] as? String ?? "", email: subDict["email"] as? String ?? "", profile_img: subDict["profile_image"] as? String ?? "", platform: "naver")
                    }
                }
                
            case .failure(_):
                break
            }
        }
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        naverInstance?.requestDeleteToken()
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[naver login error]:", error.localizedDescription)
    }
}

extension LoginAAViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let response = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let accessToken = String(data: response.identityToken ?? Data(), encoding: .utf8) else { return }
        
        UserDefaults.standard.setValue(Utils.decode(jwtToken: accessToken)["sub"] as? String ?? "", forKey: "apple_id")
        UserDefaults.standard.synchronize()
        
        self.loadingData(id: UserDefaults.standard.string(forKey: "apple_id") ?? "", platform: "apple") { login in
            
            if login {
                self.segueViewController(identifier: "LoadingViewController")
            } else {
                self.loadingData2(name: "\(response.fullName?.familyName ?? "")\(response.fullName?.givenName ?? "")", nick: response.fullName?.nickname ?? "", email: Utils.decode(jwtToken: accessToken)["email"] as? String ?? "", profile_img: "", platform: "apple")
            }
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error as Any)
    }
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

//extension LoginAAViewController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let OFFSET_Y = scrollView.contentOffset.y
//        if OFFSET_Y > 335 { HEADER_L.alpha = (OFFSET_Y-335)/35 } else { HEADER_L.alpha = 0.0 }
//    }
//}
