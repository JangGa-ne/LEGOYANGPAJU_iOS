//
//  VC_SIGNUP.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/11/18.
//

import UIKit
import BSImagePicker
import Photos
import MobileCoreServices

class VC_SIGNUP: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var DATE_DATA: String = ""
    var IMAGE_DATA: [String: Data] = [:]
    var FILE_DATA: [String: String] = [:]
    var LAT: String = "0.0"
    var LON: String = "0.0"
    
    @IBOutlet weak var NAVI_L: UILabel!
    @IBOutlet weak var LINE_V: UIView!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    @IBOutlet weak var US_NAME_TF: UITextField!
    @IBOutlet weak var US_BIRTH_TF: UITextField!
    @IBOutlet weak var US_BIRTH_B: UIButton!
    @IBOutlet weak var US_PHONE_TF: UITextField!
    @IBOutlet weak var US_PHONE_B1: UIButton!
    @IBOutlet weak var US_PHONE_B2: UIButton!
    
    @IBOutlet weak var US_ID_TF: UITextField!
    @IBOutlet weak var US_ID_B: UIButton!
    @IBOutlet weak var US_PW_TF1: UITextField!
    @IBOutlet weak var US_PW_TF2: UITextField!
    @IBOutlet weak var US_PW_L2: UILabel!
    @IBOutlet weak var US_EMAIL_TF: UITextField!
    
    @IBOutlet weak var BS_CATE_TF: UITextField!
    @IBOutlet weak var BS_CATE_B: UIButton!
    @IBOutlet weak var BS_NAME_TF: UITextField!
    @IBOutlet weak var BS_ADDRESS_TF1: UITextField!
    @IBOutlet weak var BS_ADDRESS_TF2: UITextField!
    @IBOutlet weak var BS_ADDRESS_B: UIButton!
    @IBOutlet weak var BS_CEO_TF: UITextField!
    @IBOutlet weak var BS_NUMBER_TF: UITextField!
    @IBOutlet weak var BS_NUMBER_B: UIButton!
    @IBOutlet weak var BS_FILE_SV: UIStackView!
    @IBOutlet weak var BS_FILE_L: UILabel!
    @IBOutlet weak var BS_FILE_B: UIButton!
    @IBOutlet weak var BS_EMAIL_TF: UITextField!
    
    @IBOutlet weak var VC_JUDGE_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_SIGNUP_DEL = self
        
        S_KEYBOARD()
        
        NAVI_L.alpha = 0.0; LINE_V.alpha = 0.0
        
        US_NAME_TF.placeholder("이름을 입력해 주세요.", COLOR: .lightGray)
        US_BIRTH_TF.placeholder("생년월일을 입력해 주세요.", COLOR: .lightGray)
        US_PHONE_TF.placeholder("휴대전화를 입력해 주세요.", COLOR: .lightGray)
        
        US_ID_TF.placeholder("아이디 (본인인증시 자동 입력됩니다.)", COLOR: .lightGray)
        US_PW_TF1.placeholder("비밀번호", COLOR: .lightGray)
        US_PW_TF2.placeholder("비밀번호 확인", COLOR: .lightGray); US_PW_L2.isHidden = true
        US_EMAIL_TF.placeholder("이메일", COLOR: .lightGray)
        
        BS_CATE_TF.placeholder("카테고리", COLOR: .lightGray)
        BS_NAME_TF.placeholder("상호명", COLOR: .lightGray)
        BS_ADDRESS_TF1.placeholder("주소", COLOR: .lightGray)
        BS_ADDRESS_TF2.placeholder("상세주소", COLOR: .lightGray)
        BS_CEO_TF.placeholder("대표명", COLOR: .lightGray)
        BS_NUMBER_TF.placeholder("사업자등록번호", COLOR: .lightGray); BS_FILE_SV.isHidden = true
        BS_EMAIL_TF.placeholder("세금계산서 수취 이메일", COLOR: .lightGray)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCROLLVIEW.delegate = self
        
        US_BIRTH_B.tag = 1; US_BIRTH_B.addTarget(self, action: #selector(VC_POPUP1_B(_:)), for: .touchUpInside)
        US_PHONE_B1.tag = 2; US_PHONE_B1.addTarget(self, action: #selector(VC_POPUP1_B(_:)), for: .touchUpInside)
        US_PHONE_B2.addTarget(self, action: #selector(SIGNCHECK_B(_:)), for: .touchUpInside)
        
        //        US_ID_B.tag = 3; US_ID_B.addTarget(self, action: #selector(VC_POPUP1_B(_:)), for: .touchUpInside)
        US_PW_TF2.addTarget(self, action: #selector(US_PW_TF2(_:)), for: .editingChanged)
        
        BS_CATE_B.tag = 7; BS_CATE_B.addTarget(self, action: #selector(VC_POPUP1_B(_:)), for: .touchUpInside)
        BS_ADDRESS_B.addTarget(self, action: #selector(ADDRESS_B(_:)), for: .touchUpInside)
        BS_NUMBER_TF.delegate = self; BS_NUMBER_B.addTarget(self, action: #selector(FILE_B(_:)), for: .touchUpInside)
        BS_FILE_B.addTarget(self, action: #selector(DELETE_B(_:)), for: .touchUpInside)
        
        VC_JUDGE_B.addTarget(self, action: #selector(SIGNUP_B(_:)), for: .touchUpInside)
    }
    
    @objc func US_PW_TF2(_ sender: UITextField) {
        if US_PW_TF1.text! != US_PW_TF2.text! { US_PW_L2.isHidden = false } else { US_PW_L2.isHidden = true }
    }
    
    @objc func VC_POPUP1_B(_ sender: UIButton) {
        
        for TF in [US_NAME_TF, US_BIRTH_TF, US_PHONE_TF, US_ID_TF, US_PW_TF1, US_PW_TF2, US_EMAIL_TF, BS_CATE_TF, BS_NAME_TF, BS_ADDRESS_TF1, BS_ADDRESS_TF2, BS_CEO_TF, BS_NUMBER_TF, BS_EMAIL_TF] { TF?.resignFirstResponder() }
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_POPUP1") as! VC_POPUP1
        VC.modalPresentationStyle = .overCurrentContext; VC.transitioningDelegate = self
        if sender.tag == 1 {
            VC.TYPE = "birth"
        } else if sender.tag == 2 {
            VC.TYPE = "phone"
        } else if sender.tag == 3 {
            VC.TYPE = "id"
        } else if sender.tag == 7 {
            VC.TYPE = "category"
        }
        present(VC, animated: true, completion: nil)
    }
    
    @objc func ADDRESS_B(_ sender: UIButton) {
        segueViewController(identifier: "VC_ADDRESS")
    }
    
    @objc func SIGNCHECK_B(_ sender: UIButton) {
        
        for TF in [US_NAME_TF, US_BIRTH_TF, US_PHONE_TF, US_ID_TF, US_PW_TF1, US_PW_TF2, US_EMAIL_TF, BS_CATE_TF, BS_NAME_TF, BS_ADDRESS_TF1, BS_ADDRESS_TF2, BS_CEO_TF, BS_NUMBER_TF, BS_EMAIL_TF] { TF?.resignFirstResponder() }
        
        if (US_PHONE_TF.text?.count ?? 0) < 11 {
            S_NOTICE("휴대전화 (!)")
        } else {
            PUT_BOOTPAY(NAME: "휴대전화 본인인증", AC_TYPE: "", US_PHONE: US_PHONE_TF.text!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == BS_NUMBER_TF {
            if (strcmp(string.cString(using: String.Encoding.utf8), "\\b") == -92) || (textField.text!.count < 10) { return true } else { return false }
        } else {
            return true
        }
    }
    
    @objc func FILE_B(_ sender: UIButton) {
        
        for TF in [US_NAME_TF, US_BIRTH_TF, US_PHONE_TF, US_ID_TF, US_PW_TF1, US_PW_TF2, US_EMAIL_TF, BS_CATE_TF, BS_NAME_TF, BS_ADDRESS_TF1, BS_ADDRESS_TF2, BS_CEO_TF, BS_NUMBER_TF, BS_EMAIL_TF] { TF?.resignFirstResponder() }
        
        let ALERT = UIAlertController(title: nil, message: "사업자등록증 첨부파일", preferredStyle: .actionSheet)
        
        ALERT.addAction(UIAlertAction(title: "사진 가져오기", style: .default, handler: { _ in
            
            PHPhotoLibrary.requestAuthorization({ status in
                
                if status == .authorized {
                    
                    let IMAGEPICKER = ImagePickerController()
                    IMAGEPICKER.settings.selection.max = 1
                    IMAGEPICKER.settings.theme.selectionStyle = .numbered
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

                    self.presentImagePicker(IMAGEPICKER, select: { asset in
                        
                    }, deselect: { asset in
                        
                    }, cancel: { assets in
                        
                    }, finish: { assets in
                        // 데이터 삭제
                        self.IMAGE_DATA.removeAll(); self.FILE_DATA.removeAll(); self.BS_FILE_SV.isHidden = true; self.BS_FILE_L.text?.removeAll()
                        
                        DispatchQueue.main.async {
                            for asset in assets {
                                let options = PHImageRequestOptions(); options.isSynchronous = true
                                PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 1024, height: 1024), contentMode: .aspectFit, options: options) { image, _ in
                                    if let IMAGE = image {
                                        self.BS_FILE_SV.isHidden = false; self.BS_FILE_L.text = "image1.\(self.detectImageType(from: image?.pngData() ?? Data()))"
                                        // 데이터 추가
                                        self.IMAGE_DATA["\(IMAGE)"] = IMAGE.pngData()
                                    }
                                }
                            }
                        }
                    })
                } else {
                    
                    DispatchQueue.main.async {
                        
                        let ALERT = UIAlertController(title: "\'레고양파주\'에서 \'설정\'을(를) 열려고 합니다.", message: nil, preferredStyle: .alert)
                        ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            if let URL = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(URL) }
                        }))
                        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                        self.present(ALERT, animated: true, completion: nil)
                    }
                }
            })
        }))
        ALERT.addAction(UIAlertAction(title: "파일 가져오기", style: .default, handler: { _ in
            
            let DOCUMENTPICKER: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
            DOCUMENTPICKER.delegate = self; DOCUMENTPICKER.modalPresentationStyle = .formSheet
            self.present(DOCUMENTPICKER, animated: true, completion: nil)
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(ALERT, animated: true, completion: nil)
    }
    
//    @objc func SIGNUP_B(_ sender: UIButton) {
//        self.FirebaseStoragePutData()
//    }
    
    @objc func SIGNUP_B(_ sender: UIButton) {

        if US_NAME_TF.text! == "" {
            S_NOTICE("이름 (!)")
//        } else if US_BIRTH_TF.text! == "" {
//            S_NOTICE("생년월일 (!)")
        } else if !(UserDefaults.standard.bool(forKey: "phonecheck")) {
            S_NOTICE("휴대전화 (!)")
        } else if US_PW_TF1.text! == "" {
            S_NOTICE("비밀번호 (!)")
        } else if (US_PW_TF2.text! == "") || !(US_PW_L2.isHidden) {
            S_NOTICE("비밀번호 확인 (!)")
        } else if US_EMAIL_TF.text! == "" {
            S_NOTICE("이메일 (!)")
        } else if BS_CATE_TF.text! == "" {
            S_NOTICE("카테고리 (!)")
        } else if BS_NAME_TF.text! == "" {
            S_NOTICE("상호명 (!)")
        } else if (BS_ADDRESS_TF1.text! == "") || (BS_ADDRESS_TF2.text! == "") {
            S_NOTICE("주소 (!)")
        } else if BS_CEO_TF.text! == "" {
            S_NOTICE("대표명 (!)")
        } else if BS_NUMBER_TF.text! == "" {
            S_NOTICE("사업자등록번호 (!)")
        } else if BS_FILE_SV.isHidden {
            S_NOTICE("사업자등록증 (!)")
        } else if BS_EMAIL_TF.text! == "" {
            S_NOTICE("세금계산서 수취 이메일 (!)")
        } else if !BS_ADDRESS_TF1.text!.contains("고양") && !BS_ADDRESS_TF1.text!.contains("파주") {
            S_NOTICE("타지역 (!)")
        } else { S_INDICATOR(view, text: "회원가입 처리중...", animated: true)
            PUT_SIGNUP(NAME: "회원가입", AC_TYPE: "store")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
        
        if BS_ADDRESS_TF1.text != "" { SET_GEOCORDER(NAME: "위치변환", AC_TYPE: "geocorder") }
        
        if UserDefaults.standard.bool(forKey: "phonecheck") { US_ID_TF.text = US_PHONE_TF.text! } else { US_ID_TF.text?.removeAll() }
    }
}

extension VC_SIGNUP: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        // 데이터 삭제
        IMAGE_DATA.removeAll(); FILE_DATA.removeAll(); self.BS_FILE_SV.isHidden = true; self.BS_FILE_L.text?.removeAll()
        
        DispatchQueue.main.async {
            self.BS_FILE_SV.isHidden = false; self.BS_FILE_L.text = "\(url.path)".components(separatedBy: "/")["\(url.path)".components(separatedBy: "/").count-1]
            // 데이터 추가
            self.FILE_DATA.removeAll(); self.FILE_DATA["\(url)"] = "\(url)"
        }
    }
    
    @objc func DELETE_B(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: "", message: "파일을 삭제하시겠습니까?", preferredStyle: .alert)
        ALERT.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.BS_FILE_SV.isHidden = true; self.BS_FILE_L.text = ""; self.FILE_DATA.removeAll()
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(ALERT, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension VC_SIGNUP: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        if OFFSET_Y > 30 { NAVI_L.alpha = OFFSET_Y/30; LINE_V.alpha = 0.05 } else { NAVI_L.alpha = 0.0; LINE_V.alpha = 0.0 }
    }
}
