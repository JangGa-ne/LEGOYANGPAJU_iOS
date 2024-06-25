//
//  P_LOGIN.swift
//  legoyang
//
//  Created by 장 제현 on 2022/09/26.
//

import UIKit
import FirebaseFirestore
import NaverThirdPartyLogin
import Alamofire
import KakaoSDKUser
import AuthenticationServices

/// 레고양 로그인
extension LoginViewController {
    
    func GET_LOGIN1(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        Firestore.firestore().collection(AC_TYPE).whereField("id", isEqualTo: ID_TF.text!).getDocuments { responses, error in
            
            guard let responses = responses else { self.S_NOTICE("아이디 (!)"); return }
            
            for response in responses.documents {
                
                let dict = response.data()
                
                if (dict["password"] as? String ?? "") != self.PW_TF.text! {
                    self.S_NOTICE("비밀번호 (!)"); return
                } else if (dict["secession"] as? String ?? "") != "" {
                    
                    let ALERT = UIAlertController(title: "", message: "회원탈퇴 요청한 계정입니다.\n복구하시겠습니까?", preferredStyle: .alert)
                    ALERT.addAction(UIAlertAction(title: "복구", style: .default, handler: { _ in
                        Firestore.firestore().collection("member").document(response.documentID).updateData(["secession": FieldValue.delete()]) { error in
                            if error == nil { self.S_NOTICE("계정 복구됨")
                                UserDefaults.standard.setValue(response.documentID, forKey: "member_id"); UserDefaults.standard.synchronize()
                                self.segueViewController(identifier: "LoadingViewController")
                            }
                        }
                    }))
                    ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    self.present(ALERT, animated: true, completion: nil)
                    
                } else {
                    UserDefaults.standard.setValue(response.documentID, forKey: "member_id"); UserDefaults.standard.synchronize()
                    self.segueViewController(identifier: "LoadingViewController")
                }
            }
        }
    }
}

/// 네이버 로그인
extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        GET_NAVER(NAME: "NAVER로그인", AC_TYPE: "naver")
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        NAVER?.requestDeleteToken()
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }
    
    func GET_NAVER(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        if NAVER?.isValidAccessTokenExpireTimeNow() ?? false {
            
            guard let tokenType = self.NAVER?.tokenType else { return }
            guard let accessToken = self.NAVER?.accessToken else { return }
            let postUrl = URL(string: "https://openapi.naver.com/v1/nid/me")!
            
            let MANAGER = Alamofire.Session.default
            MANAGER.session.configuration.timeoutIntervalForRequest = 5
            MANAGER.request(postUrl, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "\(tokenType) \(accessToken)"]).responseJSON { response in
                
                print("[\(NAME)]", response)
                
                switch response.result {
                case .success(_):
                    
                    if let DICT1 = response.value as? [String: Any] {
                        
                        if let DICT2 = DICT1["response"] as? [String: Any] {
                            
                            Firestore.firestore().collection("member").whereField("id", isEqualTo: DICT2["email"] as? String ?? "").whereField("platform", isEqualTo: "naver").getDocuments { document, error in
                                
                                if let document = document {
                                    
                                    for document in document.documents {
                                        
                                        if document.data()["secession"] as? String ?? "" != "" {
                                            
                                            let ALERT = UIAlertController(title: "", message: "회원탈퇴 요청한 계정입니다.\n복구하시겠습니까?", preferredStyle: .alert)
                                            ALERT.addAction(UIAlertAction(title: "복구", style: .default, handler: { _ in
                                                Firestore.firestore().collection("member").document(document.documentID).updateData(["secession": FieldValue.delete()]) { error in
                                                    if error == nil { self.S_NOTICE("계정 복구됨")
                                                        UserDefaults.standard.setValue(document.documentID, forKey: "member_id"); UserDefaults.standard.synchronize()
                                                        self.segueViewController(identifier: "LoadingViewController")
                                                    }
                                                }
                                            }))
                                            ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                                            self.present(ALERT, animated: true, completion: nil)
                                        } else {
                                            UserDefaults.standard.setValue(document.documentID, forKey: "member_id"); UserDefaults.standard.synchronize()
                                            self.segueViewController(identifier: "LoadingViewController")
                                        }; return
                                    }
                                }
                                // 회원가입 임시 데이터 추가
                                UIViewController.appDelegate.OBJ_VIRTUAL_USER = API_VIRTUAL_USER(
                                    EMAIL: DICT2["email"] as? String ?? "",
                                    IMG: DICT2["profile_image"] as? String ?? "",
                                    NAME: DICT2["name"] as? String ?? "",
                                    NICK: DICT2["name"] as? String ?? "",
                                    TYPE: "naver",
                                    USER: ""
                                ); self.S_NOTICE("NAVER로 등록된 회원정보 없음"); self.segueViewController(identifier: "VC_AGREEMENT")
                            }
                        }
                    }; break
                case .failure(_):
                    break
                }
            }
        }
    }
}

/// 카카오 로그인
extension LoginViewController {
    
    func GET_KAKAO1(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { _, error in if error == nil { self.GET_KAKAO2(NAME: "카카오 로그인", AC_TYPE: AC_TYPE) } else { self.S_NOTICE("KAKAO (!)") } }
        } else {
            UserApi.shared.loginWithKakaoAccount { _, error in if error == nil { self.GET_KAKAO2(NAME: "카카오 로그인", AC_TYPE: AC_TYPE) } else { self.S_NOTICE("KAKAO (!)") } }
        }
    }
    
    func GET_KAKAO2(NAME: String, AC_TYPE: String) { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        UserApi.shared.me { response, error in
            
            if let response = response?.kakaoAccount {
                
                if response.profileNeedsAgreement == true { print(response.profile ?? "") }
                if response.nameNeedsAgreement == true { print(response.name ?? "") }
                if response.profileNicknameNeedsAgreement == true { print(response.profile?.nickname ?? "") }
                if response.birthdayNeedsAgreement == true { print(response.birthday ?? "") }
                if response.genderNeedsAgreement == true { print(response.gender ?? "") }
                if response.emailNeedsAgreement == true { print(response.email ?? "") }
                if response.phoneNumberNeedsAgreement == true { print(self.setHyphen("phone", response.phoneNumber ?? "")) }
                
                Firestore.firestore().collection("member").whereField("id", isEqualTo: response.email ?? "").whereField("platform", isEqualTo: "kakao").getDocuments { document, error in
                    
                    if let document = document {
                        
                        for document in document.documents {
                            
                            if document.data()["secession"] as? String ?? "" != "" {
                                
                                let ALERT = UIAlertController(title: "", message: "회원탈퇴 요청한 계정입니다.\n복구하시겠습니까?", preferredStyle: .alert)
                                ALERT.addAction(UIAlertAction(title: "복구", style: .default, handler: { _ in
                                    Firestore.firestore().collection("member").document(document.documentID).updateData(["secession": FieldValue.delete()]) { error in
                                        if error == nil { self.S_NOTICE("계정 복구됨")
                                            UserDefaults.standard.setValue(document.documentID, forKey: "member_id"); UserDefaults.standard.synchronize()
                                            self.segueViewController(identifier: "LoadingViewController")
                                        }
                                    }
                                }))
                                ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                                self.present(ALERT, animated: true, completion: nil)
                            } else {
                                UserDefaults.standard.setValue(document.documentID, forKey: "member_id"); UserDefaults.standard.synchronize()
                                self.segueViewController(identifier: "LoadingViewController")
                            }; return
                        }
                    }
                    // 회원가입 임시 데이터 추가
                    UIViewController.appDelegate.OBJ_VIRTUAL_USER = API_VIRTUAL_USER(
                        EMAIL: response.email ?? "",
                        IMG: "\(response.profile?.profileImageUrl as Any)".replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: ""),
                        NAME: response.name ?? "",
                        NICK: response.profile?.nickname ?? "",
                        TYPE: "kakao",
                        USER: ""
                    ); self.S_NOTICE("KAKAO로 등록된 회원정보 없음"); self.segueViewController(identifier: "VC_AGREEMENT")
                }
            } else {
                self.S_NOTICE("응답 실패")
            }
        }
    }
}

struct API_VIRTUAL_USER {
    
    var EMAIL: String = ""
    var IMG: String = ""
    var NAME: String = ""
    var NICK: String = ""
    var TYPE: String = ""
    var USER: String = ""
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func GET_APPLE(NAME: String, AC_TYPE: String) {
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let response = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            if let tokenString = String(data: response.identityToken ?? Data(), encoding: .utf8) {
                
                let EMAIL = Utils.decode(jwtToken: tokenString)["email"] as? String ?? ""
                let SUB = Utils.decode(jwtToken: tokenString)["sub"] as? String ?? ""
                
                Firestore.firestore().collection("member").whereField("id", isEqualTo: SUB).whereField("platform", isEqualTo: "apple").getDocuments { document, error in
                    
                    if let document = document {
                        
                        for document in document.documents {
                            
                            if document.data()["secession"] as? String ?? "" != "" {
                                
                                let ALERT = UIAlertController(title: "", message: "회원탈퇴 요청한 계정입니다.\n복구하시겠습니까?", preferredStyle: .alert)
                                ALERT.addAction(UIAlertAction(title: "복구", style: .default, handler: { _ in
                                    Firestore.firestore().collection("member").document(document.documentID).updateData(["secession": FieldValue.delete()]) { error in
                                        if error == nil { self.S_NOTICE("계정 복구됨")
                                            UserDefaults.standard.setValue(document.documentID, forKey: "member_id"); UserDefaults.standard.synchronize()
                                            self.segueViewController(identifier: "LoadingViewController")
                                        }
                                    }
                                }))
                                ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                                self.present(ALERT, animated: true, completion: nil)
                            } else {
                                UserDefaults.standard.setValue(document.documentID, forKey: "member_id"); UserDefaults.standard.synchronize()
                                self.segueViewController(identifier: "LoadingViewController")
                            }; return
                        }
                    }
                    // 회원가입 임시 데이터 추가
                    UIViewController.appDelegate.OBJ_VIRTUAL_USER = API_VIRTUAL_USER(
                        EMAIL: EMAIL,
                        IMG: "",
                        NAME: "\(response.fullName?.familyName ?? "")\(response.fullName?.givenName ?? "")",
                        NICK: response.fullName?.nickname ?? "",
                        TYPE: "apple",
                        USER: SUB
                    ); self.S_NOTICE("APPLE로 등록된 회원정보 없음"); self.segueViewController(identifier: "VC_AGREEMENT")
                }
            } else {
                
            }
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

class Utils {
    
    static func decode(jwtToken jwt: String) -> [String: Any] {
        
        func base64UrlDecode(_ value: String) -> Data? {
            
            var base64 = value.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")

            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 = base64 + padding
            }; return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }

        func decodeJWTPart(_ value: String) -> [String: Any]? {
            guard let bodyData = base64UrlDecode(value), let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else { return nil }; return payload
        }
        
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
}
