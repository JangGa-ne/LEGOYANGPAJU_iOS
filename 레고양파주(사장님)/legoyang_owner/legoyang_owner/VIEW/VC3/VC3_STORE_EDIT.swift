//
//  VC3_STORE_EDIT.swift
//  legoyang_owner
//
//  Created by Busan Dynamic on 2023/02/22.
//

import UIKit
import ImageSlideshow
import BSImagePicker
import Photos

class CC3_STORE_EDIT: UICollectionViewCell {
    
    @IBOutlet weak var HASHTAG_L: UILabel!
}

class VC3_STORE_EDIT: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var COLOR: String = ""
    var OBJ_SELECT: [Int: [String: Data]] = [:]
    var HASHTAGS: [String] = []
    
    var LAT: String = "0.0"
    var LON: String = "0.0"
    var ADDRESS: String = ""
    
    @IBOutlet weak var BACK_B: UIButton!
    
    @IBOutlet weak var SLIDER_I: ImageSlideshow!
    @IBOutlet weak var POSITION_L: UILabel!
    
    @IBOutlet weak var QUOTE_COLOR_B: UIButton!
    @IBOutlet weak var QUOTE_LEFT_I: UIImageView!
    @IBOutlet weak var NAME_L: UILabel!
    @IBOutlet weak var QUOTE_RIGHT_I: UIImageView!
    
    @IBOutlet weak var HASHTAG_TF: UITextField!
    @IBOutlet weak var HASHTAG_B: UIButton!
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    
    @IBOutlet weak var SUBJECT_TF: UITextField!
    @IBOutlet weak var CONTENTS_TV: UITextView!
    
    @IBOutlet weak var TEL_TF: UITextField!
    @IBOutlet weak var ADDRESS_TF: UITextField!
    @IBOutlet weak var ADDRESS_B: UIButton!
    
    @IBOutlet weak var OPENTIME_TF: UITextField!
    @IBOutlet weak var LASTORDER_TF: UITextField!
    @IBOutlet weak var HOLIDAY_TF: UITextField!
    
    @IBOutlet weak var MN_NAME1_TF: UITextField!
    @IBOutlet weak var MN_AMOUNT1_TF: UITextField!
    @IBOutlet weak var MN_NAME2_TF: UITextField!
    @IBOutlet weak var MN_AMOUNT2_TF: UITextField!
    @IBOutlet weak var MN_NAME3_TF: UITextField!
    @IBOutlet weak var MN_AMOUNT3_TF: UITextField!
    @IBOutlet weak var MN_NAME4_TF: UITextField!
    @IBOutlet weak var MN_AMOUNT4_TF: UITextField!
    
    @IBOutlet weak var EDIT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC3_STORE_EDIT_DEL = self
        
        S_KEYBOARD()
        
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.scrollDirection = .horizontal; LAYOUT.minimumLineSpacing = 10; LAYOUT.minimumInteritemSpacing = 10
        COLLECTIONVIEW.setCollectionViewLayout(LAYOUT, animated: true, completion: nil)
        COLLECTIONVIEW.isHidden = true
        
        let PLACEHOLDERS: [String] = ["10글자 이내로 입력해 주세요.", "제목을 입력해 주세요.", "-를 빼고 입력해 주세요.", "주소를 입력해 주세요.", "00:00 ~ 00:00", "00:00", "일요일", "메뉴명1", "가격1", "메뉴명2", "가격2", "메뉴명3", "가격3", "메뉴명4", "가격4"]
        let TEXTFIELDS: [UITextField] = [HASHTAG_TF, SUBJECT_TF, TEL_TF, ADDRESS_TF, OPENTIME_TF, LASTORDER_TF, HOLIDAY_TF, MN_NAME1_TF, MN_AMOUNT1_TF, MN_NAME2_TF, MN_AMOUNT2_TF, MN_NAME3_TF, MN_AMOUNT3_TF, MN_NAME4_TF, MN_AMOUNT4_TF]
        
        for i in 0 ..< PLACEHOLDERS.count {
            TEXTFIELDS[i].placeholder(PLACEHOLDERS[i], COLOR: .lightGray)
            if i > 1 { TEXTFIELDS[i].paddingLeft(10); TEXTFIELDS[i].paddingRight(10) }
        }//; TEXTFIELDS[i].delegate = self }
        
        CONTENTS_TV.delegate = self; CONTENTS_TV.text = "내용을 입력해주세요."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BACK_B.addTarget(self, action: #selector(BACK_B(_:)), for: .touchUpInside)
        
        HASHTAG_TF.tag = 10; HASHTAG_TF.addTarget(self, action: #selector(MAX_TEXT(_:)), for: .editingChanged)
        HASHTAG_B.addTarget(self, action: #selector(HASHTAG_B(_:)), for: .touchUpInside)
        
        SUBJECT_TF.tag = 30; SUBJECT_TF.addTarget(self, action: #selector(MAX_TEXT(_:)), for: .editingChanged)
        
        viewDidLoad2()
        
        ADDRESS_B.addTarget(self, action: #selector(ADDRESS_B(_:)), for: .touchUpInside)
        
        EDIT_B.addTarget(self, action: #selector(EDIT_B(_:)), for: .touchUpInside)
    }
    
    @objc func BACK_B(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: "", message: "나가기 하면 변경사항은 저장되지 않습니다.\n정말 나가시겠습니까?", preferredStyle: .alert)
        
        ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(ALERT, animated: true, completion: nil)
    }
    
    @objc func HASHTAG_B(_ sender: UIButton) {
        UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeTag.append(HASHTAG_TF.text!); HASHTAG_TF.resignFirstResponder(); HASHTAG_TF.text!.removeAll(); COLLECTIONVIEW.isHidden = false; COLLECTIONVIEW.reloadData()
    }
    
    func viewDidLoad2() {
        
        let DATA = UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row]
        
        IMAGESLIDER(IV: SLIDER_I, IU: DATA.imageArray, PH: UIImage(), RD: 0, CM: .scaleAspectFill)
        SLIDER_I.delegate = self
        SLIDER_I.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(VC_PHOTO_B(_:))))
        if DATA.imageArray.count > 0 { POSITION_L.text = "1 / \(DATA.imageArray.count)" }
        
        COLOR = DATA.storeColor
        QUOTE_COLOR_B.addTarget(self, action: #selector(VC_POPUP2_B(_:)), for: .touchUpInside)
        QUOTE_LEFT_I.image = UIImage(named: QUOTE_REFT[DATA.storeColor] ?? "quote_left0")
        NAME_L.attributedText = NSAttributedString(string: DATA.storeName, attributes: [.strokeColor: UIColor.black, .strokeWidth: -6, .foregroundColor: UIColor.clear])
        QUOTE_RIGHT_I.image = UIImage(named: QUOTE_RIGHT[DATA.storeColor] ?? "quote_right0")
        
        if DATA.storeTag.count > 0 { HASHTAGS = DATA.storeTag; COLLECTIONVIEW.isHidden = false } else { COLLECTIONVIEW.isHidden = true }
        COLLECTIONVIEW.delegate = self; COLLECTIONVIEW.dataSource = self
        
        SUBJECT_TF.text = DATA.storeSubTitle
        CONTENTS_TV.text = DATA.storeEtc
        TEL_TF.text = DATA.storeTel
        ADDRESS_TF.text = DATA.storeAddress
        OPENTIME_TF.text = DATA.storeTime
        LASTORDER_TF.text = DATA.storeLastOrder
        HOLIDAY_TF.text = DATA.storeRestday
        for i in 0 ..< DATA.storeMenu.count {
            [MN_NAME1_TF, MN_NAME2_TF, MN_NAME3_TF, MN_NAME4_TF][i]?.text = DATA.storeMenu[i].menuName
            [MN_AMOUNT1_TF, MN_AMOUNT2_TF, MN_AMOUNT3_TF, MN_AMOUNT4_TF][i]?.text = DATA.storeMenu[i].menuPrice
        }
    }
    
    @objc func VC_PHOTO_B(_ sender: UITapGestureRecognizer) {
        // 데이터 삭제
        OBJ_SELECT.removeAll()
        
        let TEXTFIELDS: [UITextField] = [SUBJECT_TF, TEL_TF, ADDRESS_TF, OPENTIME_TF, LASTORDER_TF, HOLIDAY_TF, MN_NAME1_TF, MN_AMOUNT1_TF, MN_NAME2_TF, MN_AMOUNT2_TF, MN_NAME3_TF, MN_AMOUNT3_TF, MN_NAME4_TF, MN_AMOUNT4_TF]
        for TF in TEXTFIELDS { TF.resignFirstResponder() }; CONTENTS_TV.resignFirstResponder()
        
        PHPhotoLibrary.requestAuthorization({ status in
            
            if status == .authorized {
                // 이미지 여러개 선택
                let IMAGEPICKER = ImagePickerController()
                IMAGEPICKER.settings.selection.max = 10
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
                    var images: [ImageSource] = []
                    for (i, asset) in assets.enumerated() {
                        let options = PHImageRequestOptions(); options.isSynchronous = true
                        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 1024, height: 1024), contentMode: .aspectFill, options: options) { image, _ in
                            // 데이터 추가
                            if let IMAGE = image { self.OBJ_SELECT[i] = ["\(IMAGE)": IMAGE.pngData() ?? Data()]; images.append(ImageSource(image: IMAGE)) }
                        }
                    }; self.SLIDER_I.setImageInputs(images); self.POSITION_L.text = "1 / \(images.count)"
                }, completion: nil)
            } else {
                
                DispatchQueue.main.async {
                    
                    let ALERT = UIAlertController(title: "\'레고양파주 파트너\'에서 \'설정\'을(를) 열려고 합니다.", message: nil, preferredStyle: .alert)
                    ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        if let URL = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(URL) }
                    }))
                    ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    self.present(ALERT, animated: true, completion: nil)
                }
            }
        })
    }
    
    @objc func ADDRESS_B(_ sender: UIButton) {
        
        let TEXTFIELDS: [UITextField] = [SUBJECT_TF, TEL_TF, ADDRESS_TF, OPENTIME_TF, LASTORDER_TF, HOLIDAY_TF, MN_NAME1_TF, MN_AMOUNT1_TF, MN_NAME2_TF, MN_AMOUNT2_TF, MN_NAME3_TF, MN_AMOUNT3_TF, MN_NAME4_TF, MN_AMOUNT4_TF]
        for TF in TEXTFIELDS { TF.resignFirstResponder() }; CONTENTS_TV.resignFirstResponder()
        
        segueViewController(identifier: "VC_ADDRESS")
    }
    
    @objc func VC_POPUP2_B(_ sender: UIButton) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_POPUP2") as! VC_POPUP2
        VC.modalPresentationStyle = .overCurrentContext; VC.transitioningDelegate = self
        present(VC, animated: true, completion: nil)
    }
    
    @objc func EDIT_B(_ sender: UIButton) {
        
        let TEXTFIELDS: [UITextField] = [SUBJECT_TF, TEL_TF, ADDRESS_TF, OPENTIME_TF, LASTORDER_TF, HOLIDAY_TF, MN_NAME1_TF, MN_AMOUNT1_TF, MN_NAME2_TF, MN_AMOUNT2_TF, MN_NAME3_TF, MN_AMOUNT3_TF, MN_NAME4_TF, MN_AMOUNT4_TF]
        for TF in TEXTFIELDS { TF.resignFirstResponder() }; CONTENTS_TV.resignFirstResponder()
        
        if (ADDRESS != "") && !ADDRESS.contains("고양") && !ADDRESS.contains("파주") {
            S_NOTICE("타지역 (!)")
        } else {
            PUT_STORE(NAME: "내사업장수정", AC_TYPE: "store")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
        
        if ADDRESS != "" { SET_GEOCORDER(NAME: "지오코더", AC_TYPE: "geocorder")
                
            let ALERT = UIAlertController(title: "", message: "상세주소", preferredStyle: .alert)
            ALERT.addTextField() { (textField) in textField.placeholder = "이름을 입력해주세요." }
            ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.ADDRESS_TF.text!.append(" \(ALERT.textFields?[0].text ?? "")")
            }))
            ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            present(ALERT, animated: true, completion: nil)
        }
    }
}

extension VC3_STORE_EDIT: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        POSITION_L.text = "\(page+1) / \(UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].imageArray.count)"
    }
}

extension VC3_STORE_EDIT: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray { textView.text = nil; textView.textColor = .black }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty { if textView == CONTENTS_TV { textView.text = "내용을 입력해주세요." }; textView.textColor = .lightGray }
    }
}

extension VC3_STORE_EDIT: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeTag.count > 0 { return UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeTag.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC3_STORE_EDIT_1", for: indexPath) as! CC3_STORE_EDIT
        CELL.HASHTAG_L.text = "#\(UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeTag[indexPath.item])"
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let ALERT = UIAlertController(title: "", message: "\'#\(UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeTag[indexPath.item])\' 태그를 삭제하시겠습니까?", preferredStyle: .alert)
        ALERT.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeTag.remove(at: indexPath.item); self.COLLECTIONVIEW.reloadData()
            if UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeTag.count == 0 { self.COLLECTIONVIEW.isHidden = true }
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(ALERT, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: stringWidth(text: "#\(UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeTag[indexPath.item])", fontSize: 14)+10, height: 20)
    }
}
