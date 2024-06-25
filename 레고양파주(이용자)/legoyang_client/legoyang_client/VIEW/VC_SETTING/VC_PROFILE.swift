//
//  VC_PROFILE.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/02/17.
//

import UIKit
import BSImagePicker
import Photos

class VC_PROFILE: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var IMAGE_DATA: [String: Data] = [:]
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var BACKGROUND_V: UIView!
    @IBOutlet weak var CHECK_I: UIImageView!
    @IBOutlet weak var PROFILE_I: UIImageView!
    @IBOutlet weak var NAME_L: UILabel!
    @IBOutlet weak var NICK_L: UILabel!
    @IBOutlet weak var PHONE_L: UILabel!
    
    @IBOutlet weak var TYPE_L: UILabel!
    @IBOutlet weak var GRADE_I: UIImageView!
    
    @IBOutlet weak var PROFILE_B: UIButton!
    @IBOutlet weak var NAME_V: UIView!
    @IBOutlet weak var NAME_B: UIButton!
    @IBOutlet weak var NICK_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        let data = UIViewController.appDelegate.MemberObject
        
        BACKGROUND_V.roundShadows(color: .black, offset: CGSize(width: 0, height: 5), opcity: 0.1, radius1: 5, radius2: 12.5)
        if data.profileImg != "" { CHECK_I.isHidden = false; NUKE(IV: PROFILE_I, IU: data.profileImg, RD: 12.5, CM: .scaleAspectFill) } else { CHECK_I.isHidden = true }
        NAME_L.text = "\(data.name)님 :D"
        NICK_L.text = "nick: \(data.nick)"
        PHONE_L.text = "phone: \(setHyphen("phone", data.number))"
        
        TYPE_L.text = "\(data.platform)로 로그인됨"
        GRADE_I.image = UIImage(named: "lv\(data.grade)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PROFILE_B.tag = 0; PROFILE_B.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        NAME_B.tag = 1; NAME_B.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
        NICK_B.tag = 2; NICK_B.addTarget(self, action: #selector(BUTTON(_:)), for: .touchUpInside)
    }
    
    @objc func BUTTON(_ sender: UIButton) {
        
        if sender.tag == 0 { IMAGE_DATA.removeAll()
            
            let IMAGEPICKER = ImagePickerController()
//            let options = IMAGEPICKER.settings.fetch.album.options
//            IMAGEPICKER.settings.fetch.album.fetchResults = [
//                PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options),
//                PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: options),
//                PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: options),
//                PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: options),
//                PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: options),
//                PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: options),
//                PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumPanoramas, options: options),
//            ]
            IMAGEPICKER.settings.selection.max = 1
            IMAGEPICKER.settings.theme.selectionStyle = .checked
            IMAGEPICKER.settings.fetch.assets.supportedMediaTypes = [.image]
            if #available(iOS 13.0, *) {
                IMAGEPICKER.settings.theme.backgroundColor = .systemBackground
            } else {
                IMAGEPICKER.settings.theme.backgroundColor = .white
            }
            IMAGEPICKER.settings.list.cellsPerRow = {(verticalSize: UIUserInterfaceSizeClass, horizontalSize: UIUserInterfaceSizeClass) -> Int in
                switch (verticalSize, horizontalSize) {
                case (.compact, .regular): // iPhone5-6 portrait
                    return 4
                case (.compact, .compact): // iPhone5-6 landscape
                    return 4
                case (.regular, .regular): // iPad portrait/landscape
                    return 4
                default:
                    return 4
                }
            }

            presentImagePicker(IMAGEPICKER, select: { asset in
                
            }, deselect: { asset in
                
            }, cancel: { assets in
                
            }, finish: { assets in
                for asset in assets {
                    let options = PHImageRequestOptions(); options.isSynchronous = true
                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 1024, height: 1024), contentMode: .aspectFill, options: options) { image, _ in
                        if let IMAGE = image { self.IMAGE_DATA["\(IMAGE)"] = IMAGE.pngData(); self.PROFILE_I.image = IMAGE; self.SET_USER(NAME: "프로필변경(사진)", AC_TYPE: "member", EDIT_TYPE: 0) }; S_INDICATOR(self.view, text: "적용중...", animated: true)
                    }
                }
            })
        } else if sender.tag == 1 {
            
            let ALERT = UIAlertController(title: "", message: "이름 변경", preferredStyle: .alert)
            ALERT.addTextField() { (textField) in textField.placeholder = "이름을 입력해주세요." }
            ALERT.addAction(UIAlertAction(title: "수정", style: .default, handler: { _ in
                if (ALERT.textFields?[0].text ?? "").trimmingCharacters(in: [" "]) == "" {
                    self.S_NOTICE("이름 (!)"); return
                } else {
                    self.SET_USER(NAME: "프로필변경(이름)", AC_TYPE: "member", EDIT_TYPE: 1, STRING: ALERT.textFields?[0].text ?? ""); S_INDICATOR(self.view, text: "적용중...", animated: true)
                }
            }))
            ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            present(ALERT, animated: true, completion: nil)
        } else if sender.tag == 2 {
            
            let ALERT = UIAlertController(title: "", message: "닉네임 변경", preferredStyle: .alert)
            ALERT.addTextField() { (textField) in textField.placeholder = "닉네임을 입력해주세요." }
            ALERT.addAction(UIAlertAction(title: "수정", style: .default, handler: { _ in
                if (ALERT.textFields?[0].text ?? "").trimmingCharacters(in: [" "]) == "" {
                    self.S_NOTICE("닉네임 (!)")
                } else {
                    self.SET_USER(NAME: "프로필변경(닉네임)", AC_TYPE: "member", EDIT_TYPE: 2, STRING: ALERT.textFields?[0].text ?? ""); S_INDICATOR(self.view, text: "적용중...", animated: true)
                }
            }))
            ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            present(ALERT, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}
