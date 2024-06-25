//
//  P3_MAIN.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/24.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

extension VC3_MAIN {
    
    func PUT_IMAGE(NAME: String, AC_TYPE: String, TYPE: Int, POSITION: Int) {
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            var IMAGES = UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].imageArray
            let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
            
            if TYPE == 0 {
                Firestore.firestore().collection(AC_TYPE).document(STORE_ID).setData(["store_img": UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].imageArray[POSITION]], merge: true) { error in
                    if error == nil { self.S_NOTICE("대표 이미지 등록됨"); DispatchGroup.leave() }
                }
            } else if TYPE == 1 {
                let REMOVE = IMAGES.remove(at: POSITION); IMAGES.insert(REMOVE, at: 0)
                Firestore.firestore().collection(AC_TYPE).document(STORE_ID).setData(["img_array": IMAGES], merge: true) { error in
                    if error == nil { self.S_NOTICE("첫번째 이미지 등록됨"); DispatchGroup.leave() }
                }
            } else if TYPE == 2 {
                let STORAGE_REF = Storage.storage().reference(forURL: IMAGES[POSITION])
                STORAGE_REF.delete { error in
                    if error == nil { IMAGES.remove(at: POSITION)
                        Firestore.firestore().collection(AC_TYPE).document(STORE_ID).setData(["img_array": IMAGES], merge: true) { error in
                            if error == nil { self.S_NOTICE("해당 이미지 삭제됨"); DispatchGroup.leave() }
                        }
                    }
                }
            }
        }
        
        DispatchGroup.notify(queue: .main) {
            
            if let refresh = UIViewController.LoadingViewControllerDelegate {
                refresh.loadingData()
            }
        }
    }
}
