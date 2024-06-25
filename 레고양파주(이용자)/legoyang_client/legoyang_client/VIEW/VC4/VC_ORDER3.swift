//
//  VC_ORDER3.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/02/23.
//

import UIKit
import BSImagePicker
import Photos

class CC_ORDER3: UICollectionViewCell {
    
    @IBOutlet weak var CONFIRM_I: UIImageView!
}

class VC_ORDER3: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var TITLE1: String = ""
    var TITLE2: String = ""
    
    var OBJ_ORDER_DETAIL: [API_ORDER_DETAIL] = []
    var OBJ_POSITION: Int = 0
    
    var WRONG_TYPE: [String] = []
    var ORDER_WRONG_TYPE: String = ""
    var IMAGE_DATA: [String: Data] = [:]
    
    @IBOutlet weak var HEADER_L: UILabel!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var TITLE_L1: UILabel!
    @IBOutlet weak var TITLE_L2: UILabel!
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    
    @IBOutlet weak var ITEM_I: UIImageView!
    @IBOutlet weak var GRADE_L: UILabel!
    @IBOutlet weak var ITEM_L: UILabel!
    @IBOutlet weak var OPTION_SV_HEIGHT: NSLayoutConstraint!
    @IBOutlet weak var OPTION_SV: UIStackView!
    @IBOutlet weak var PRICE_L: UILabel!
    
    @IBOutlet weak var LINE_V: UIView!
    @IBOutlet weak var CHOICE_B1: UIButton!
    @IBOutlet weak var CHOICE_B2: UIButton!
    @IBOutlet weak var CHOICE_B3: UIButton!
    @IBOutlet weak var CHOICE_B4: UIButton!
    
    @IBOutlet weak var BACKGROUND_V: UIView!
    @IBOutlet weak var CONTENTS_TV: UITextView!
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    
    @IBOutlet weak var SUBMIT_L: UILabel!
    @IBOutlet weak var SUBMIT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        setKeyboard()
        
        HEADER_L.text = TITLE1
        
        TITLE_L1.text = TITLE2
        if TITLE2 == "상품은 잘 받으셨나요?" {
            TITLE_L2.isHidden = false; LINE_V.isHidden = true; BACKGROUND_V.isHidden = true
        } else {
            TITLE_L2.isHidden = true; LINE_V.isHidden = false; BACKGROUND_V.isHidden = false
        }
        
        SCROLLVIEW.keyboardDismissMode = .onDrag
        
        loadView2()
        
        CONTENTS_TV.text = "내용을 입력해주세요."; CONTENTS_TV.textColor = .lightGray
        
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.scrollDirection = .horizontal; LAYOUT.minimumLineSpacing = 10; LAYOUT.minimumInteritemSpacing = 0
        COLLECTIONVIEW.setCollectionViewLayout(LAYOUT, animated: false, completion: nil)
    }
    
    func loadView2() {
        
        let DATA = OBJ_ORDER_DETAIL[OBJ_POSITION]
        
        if DATA.ITEM_MAINIMG != "" {
            NUKE(IV: ITEM_I, IU: DATA.ITEM_MAINIMG, RD: 12.5, CM: .scaleAspectFill)
        } else if DATA.ITEM_IMG.count > 0 {
            NUKE(IV: ITEM_I, IU: DATA.ITEM_IMG[0], RD: 12.5, CM: .scaleAspectFill)
        } else {
            ITEM_I.image = UIImage()
        }
        GRADE_L.text = DT_CHECK(DATA.ORDER_STATE)
        ITEM_L.text = DT_CHECK(DATA.ITEM_NAME)
        
        var OPTION: String = ""
        var COUNT: Int = 0
        let PRICE = (Int(DATA.ORDER_TOTALPRICE) ?? 0) - (Int(DATA.ORDER_TOTALDISCOUNT) ?? 0)
        for (I, DATA) in DATA.ORDER_ITEMARRAY.enumerated() {
            if I != (OBJ_ORDER_DETAIL[OBJ_POSITION].ORDER_ITEMARRAY.count-1) {
                OPTION.append("\(DATA.ITEM_OPTION) / ")
            } else {
                OPTION.append(DATA.ITEM_OPTION)
            }
            COUNT += Int(DATA.ITEM_COUNT) ?? 0
        }
        PRICE_L.text = "\(NF.string(from: PRICE as NSNumber) ?? "0")원"
        
        OPTION_SV.removeAllArrangedSubviews()
        
        for (_, DATA) in DATA.ORDER_ITEMARRAY.enumerated() {
            
            let OPTION_L1 = UILabel()
            OPTION_L1.font = UIFont.systemFont(ofSize: 12)
            OPTION_L1.lineBreakMode = .byTruncatingMiddle
            OPTION_L1.textAlignment = .left
            OPTION_L1.textColor = .black
            OPTION_L1.text = DATA.ITEM_OPTION
            
            let OPTION_L2 = UILabel()
            OPTION_L2.font = UIFont.systemFont(ofSize: 12)
            OPTION_L2.lineBreakMode = .byTruncatingMiddle
            OPTION_L2.textAlignment = .right
            OPTION_L2.textColor = .black
            OPTION_L2.text = "수량: \(DATA.ITEM_COUNT)개"
            
            let BACKGROUND_SV = UIStackView(arrangedSubviews: [OPTION_L1, OPTION_L2])
            BACKGROUND_SV.translatesAutoresizingMaskIntoConstraints = false
            BACKGROUND_SV.addConstraints([NSLayoutConstraint(item: BACKGROUND_SV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)])
            BACKGROUND_SV.axis = .horizontal
            BACKGROUND_SV.spacing = 5
            OPTION_SV.addArrangedSubview(BACKGROUND_SV)
        }
        
        if TITLE2 != "상품은 잘 받으셨나요?" { for (I, BUTTON) in [CHOICE_B1, CHOICE_B2, CHOICE_B3, CHOICE_B4].enumerated() { BUTTON?.setTitle(WRONG_TYPE[I], for: .normal) } }
        
        SUBMIT_L.text = TITLE1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        COLLECTIONVIEW.delegate = self; COLLECTIONVIEW.dataSource = self
        
        CHOICE_B1.tag = 0; CHOICE_B1.addTarget(self, action: #selector(CHOICE_B(_:)), for: .touchUpInside)
        CHOICE_B2.tag = 1; CHOICE_B2.addTarget(self, action: #selector(CHOICE_B(_:)), for: .touchUpInside)
        CHOICE_B3.tag = 2; CHOICE_B3.addTarget(self, action: #selector(CHOICE_B(_:)), for: .touchUpInside)
        CHOICE_B4.tag = 3; CHOICE_B4.addTarget(self, action: #selector(CHOICE_B(_:)), for: .touchUpInside)
        
        CONTENTS_TV.delegate = self
        
        SUBMIT_B.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
    }
    
    @objc func CHOICE_B(_ sender: UIButton) {
        
        for (I, BUTTON) in [CHOICE_B1, CHOICE_B2, CHOICE_B3, CHOICE_B4].enumerated() {
            if sender.tag == I {
                BUTTON?.backgroundColor = .H_00529C; BUTTON?.setTitleColor(.white, for: .normal); ORDER_WRONG_TYPE = WRONG_TYPE[I]
            } else {
                BUTTON?.backgroundColor = .H_F4F4F4; BUTTON?.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    @objc func SUBMIT_B(_ sender: UIButton) {
        
        if TITLE2 == "상품은 잘 받으셨나요?" {
            let ALERT = UIAlertController(title: "구매확정 하시겠습니까?", message: "구매확정시 반품/교환/취소가 안되며 포인트가 적립됩니다.", preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.SET_CONFIRMATION(NAME: "구매확정", AC_TYPE: "legonggu_order_detail", PRICE: Int(self.PRICE_L.text!.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")) ?? 0)
            }))
            ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            present(ALERT, animated: true, completion: nil)
        } else {
            if ORDER_WRONG_TYPE == "" {
                S_NOTICE("타입 (!)")
            } else if (CONTENTS_TV.text == "") || (CONTENTS_TV.text == "내용을 입력해 주세요.") {
                S_NOTICE("상세사유 (!)")
            } else {
//                let ALERT = UIAlertController(title: self.TITLE1, message: "판매자가 이미 상품을 발송한 경우 취소요청이 철회될 수 있습니다. 취소 요청을 진행하시겠습니까?", preferredStyle: .alert)
//                ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
//                    self.SET_PROTEST(NAME: self.TITLE1, AC_TYPE: "legonggu_order_detail")
//                }))
//                present(ALERT, animated: true, completion: nil)
                SET_PROTEST(NAME: TITLE1, AC_TYPE: "legonggu_order_detail")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension VC_ORDER3: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray { textView.text = nil; textView.textColor = .black }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == CONTENTS_TV { textView.text = "내용을 입력해 주세요." }; textView.textColor = .lightGray
        }
    }
}

extension VC_ORDER3: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if IMAGE_DATA.count > 0 { return IMAGE_DATA.count } else { return 0 }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "CC_ORDER3_1", for: indexPath) as! CC_ORDER3
        } else if indexPath.section == 1 {
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC_ORDER3_2", for: indexPath) as! CC_ORDER3
            for (I, DATA) in IMAGE_DATA.enumerated() { if indexPath.item == I { CELL.CONFIRM_I.image = UIImage(data: DATA.value) } }
            return CELL
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let IMAGEPICKER = ImagePickerController()
            IMAGEPICKER.settings.selection.max = 10
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
                        if let IMAGE = image { self.IMAGE_DATA["\(IMAGE)"] = IMAGE.pngData(); self.COLLECTIONVIEW.reloadData() }
                    }
                }
            })
        } else if indexPath.section == 1 {
            for (I, DATA) in IMAGE_DATA.enumerated() { if indexPath.item == I { IMAGE_DATA.removeValue(forKey: DATA.key); COLLECTIONVIEW.reloadData() } }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
