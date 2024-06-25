//
//  P_PROFILE.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/02/18.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Nuke

extension VC_PROFILE {
    
    func SET_USER(NAME: String, AC_TYPE: String, EDIT_TYPE: Int, STRING: String = "") { print("[\(NAME)], (\(AC_TYPE)) 요청함")
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        if EDIT_TYPE == 0 {
            
            for (_, DATA) in IMAGE_DATA.enumerated() {
                let STORAGE_REF = Storage.storage(url: "gs://legoyangpaju.appspot.com").reference()
                let FILE_REF = STORAGE_REF.child("ProfileImage/\(MEMBER_ID)")
                let META_DATA = StorageMetadata(); META_DATA.contentType = DATA.key.mimeType()
                FILE_REF.putData(DATA.value, metadata: META_DATA).observe(.success) { snapshot in
                    FILE_REF.downloadURL { url, error in
                        Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).setData(["profile_img": "\(url!)"], merge: true) { error in
                            if error == nil {
                                self.S_NOTICE("변경됨"); ImageCache.shared.removeAll()
                                UIViewController.appDelegate.MemberObject.profileImg = "\(url!)"
                            } else {
                                self.S_NOTICE("오류 (!)")
                            }; S_INDICATOR(self.view, animated: false)
                        }
                    }
                }
            }
        } else if EDIT_TYPE == 1 {
            Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).setData(["name": STRING], merge: true) { error in
                if error == nil {
                    self.S_NOTICE("변경됨")
                    UIViewController.appDelegate.MemberObject.name = STRING
                    self.NAME_L.text = STRING
                } else {
                    self.S_NOTICE("오류 (!)")
                }; S_INDICATOR(self.view, animated: false)
            }
        } else if EDIT_TYPE == 2 {
            Firestore.firestore().collection(AC_TYPE).document(MEMBER_ID).setData(["nick": STRING], merge: true) { error in
                if error == nil {
                    self.S_NOTICE("변경됨")
                    UIViewController.appDelegate.MemberObject.nick = STRING
                    self.NICK_L.text = "nick: \(STRING)"
                } else {
                    self.S_NOTICE("오류 (!)")
                }; S_INDICATOR(self.view, animated: false)
            }
        }
    }
}
