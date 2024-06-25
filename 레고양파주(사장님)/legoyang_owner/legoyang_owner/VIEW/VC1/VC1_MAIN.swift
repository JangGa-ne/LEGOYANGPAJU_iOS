//
//  VC1_MAIN.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/19.
//

import UIKit
import BSImagePicker
import Photos
import FirebaseFirestore

class TC1_MAIN: UITableViewCell {
    
    var PROTOCOL: VC1_MAIN?
    
    var OBJ_PANGPANG: [API_PANGPANG_HISTORY] = []
    var OBJ_POSITION: Int = 0
    
    @IBOutlet weak var DATETIME_L: UILabel!
    @IBOutlet weak var DELETE_L: UILabel!
    @IBOutlet weak var DELETE_B: UIButton!
    @IBOutlet weak var USE_I: UIImageView!
    @IBOutlet weak var USE_L1: UILabel!
    @IBOutlet weak var USE_L2: UILabel!
    @IBOutlet weak var COUPON_L: UILabel!
    @IBOutlet weak var REVIEW_L: UILabel!
    @IBOutlet weak var REVIEW_B: UIButton!
    @IBOutlet weak var PRICE_TF: UITextField!
    @IBOutlet weak var PRICE_B: UIButton!
    
    @objc func PRICE_B(_ sender: UIButton) { PRICE_TF.resignFirstResponder()
        SET_PRICE(NAME: "판매금액 등록", AC_TYPE: "pangpang_history")
    }
}

class VC1_MAIN: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var TOTAL_PRICE: Int = 0
    
    var OBJ_SELECT: [String: Data] = [:]
    var OBJ_PANGPANG: [API_PANGPANG_HISTORY] = []
    
    var StoreObject: [StoreData] = []
    var row: Int = 0
    
    @IBOutlet weak var NAVI_V: UIView!
    @IBOutlet weak var NAVI_L: UILabel!
    @IBAction func VC_SETTING_B(_ sender: UIButton) { segueViewController(identifier: "VC_SETTING") }
    @IBOutlet weak var LINE_V: UIView!
    
    @IBOutlet weak var PANGPANG_V: UIView!
    @IBOutlet weak var COUPON_I: UIImageView!
    @IBOutlet weak var COUPON_B: UIButton!
    @IBOutlet weak var COUNT_TF: UITextField!
    @IBOutlet weak var QRCODE_B: UIButton!
    @IBOutlet weak var PASSWORD_TF: UITextField!
    @IBOutlet weak var COUPON_TF: UITextField!
    @IBOutlet weak var SELECT_B: UIButton!
    
    @IBOutlet weak var VC_POPUP3_B: UIButton!
    @IBOutlet weak var PRICE_L: UILabel!
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        StoreObject = UIViewController.appDelegate.StoreObject
        row = UIViewController.appDelegate.row
        
        UIViewController.VC1_MAIN_DEL = self
        UIViewController.PangpangViewControllerDelegate = self
        
        S_KEYBOARD()
        
        COUPON_TF.placeholder("레고팡팡 메뉴를 입력하세요.", COLOR: .H_FF6F00); COUPON_TF.paddingLeft(10); COUPON_TF.paddingRight(10)
        COUNT_TF.placeholder("수량", COLOR: .white.withAlphaComponent(0.7))
        PASSWORD_TF.placeholder("쿠폰인증용 번호 4자리를 입력하세요.", COLOR: .lightGray); PASSWORD_TF.paddingLeft(10); PASSWORD_TF.paddingRight(10)
        
        let data = StoreObject[row]
        
        if data.usePangpang == "true" {
            PANGPANG_V.isHidden = true
            NUKE(IV: COUPON_I, IU: data.pangpangImage, PH: UIImage(named: "logo2")!, RD: 10, CM: .scaleAspectFill)
            COUPON_TF.text = data.pangpangMenu; COUNT_TF.text = "\(data.pangpangRemain)"
            PASSWORD_TF.text = data.pangpangPassword
        } else {
            PANGPANG_V.isHidden = false
        }
        
        TABLEVIEW.separatorStyle = .none; TABLEVIEW.backgroundColor = .white
        TABLEVIEW.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        if PANGPANG_V.isHidden { GET_PANGPANG(NAME: "레고팡팡", AC_TYPE: "pangpang_history") }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        COUNT_TF.delegate = self
        
        COUPON_B.addTarget(self, action: #selector(COUPON_B(_:)), for: .touchUpInside)
        SELECT_B.addTarget(self, action: #selector(SELECT_B(_:)), for: .touchUpInside)
        QRCODE_B.addTarget(self, action: #selector(QRCODE_B(_:)), for: .touchUpInside)
        
        PASSWORD_TF.delegate = self
        
        VC_POPUP3_B.addTarget(self, action: #selector(VC_POPUP3_B(_:)), for: .touchUpInside)
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
        
        let storeId = UserDefaults.standard.string(forKey: "store_id") ?? ""
        UIViewController.AD.LISTENER = Firestore.firestore().collection("store").document(storeId).addSnapshotListener { response, error in
            UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].pangpangRemain = response?.data()?["pangpang_remain"] as? Int ?? 0
            if let refresh_1 = UIViewController.MarketViewControllerDelegate {
                refresh_1.TABLEVIEW.reloadData()
            }
            self.COUNT_TF.text = "\(response?.data()?["pangpang_remain"] as? Int ?? 0)"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == COUNT_TF {
            if (strcmp(string.cString(using: String.Encoding.utf8), "\\b") == -92) || (textField.text!.count < 3) { return true } else { return false }
        } else if textField == PASSWORD_TF {
            if (strcmp(string.cString(using: String.Encoding.utf8), "\\b") == -92) || (textField.text!.count < 4) { return true } else { return false }
        }
        
        return true
    }
    
    @objc func COUPON_B(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: nil, message: "레고팡팡 사진 설정", preferredStyle: .actionSheet)
        ALERT.addAction(UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: { _ in
            // 데이터 삭제
            self.OBJ_SELECT.removeAll()
            
            let IMAGEPICKER = ImagePickerController()
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

            self.presentImagePicker(IMAGEPICKER, select: { asset in
                
            }, deselect: { asset in
                
            }, cancel: { assets in
                
            }, finish: { assets in
                for asset in assets {
                    let options = PHImageRequestOptions(); options.isSynchronous = true
                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 1024, height: 1024), contentMode: .aspectFill, options: options) { image, _ in
                        // 데이터 추가
                        if let IMAGE = image { self.OBJ_SELECT["\(IMAGE)"] = IMAGE.pngData(); self.COUPON_I.image = IMAGE }
                    }
                }
            })
        }))
        ALERT.addAction(UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: { _ in
            // 데이터 삭제
            self.OBJ_SELECT.removeAll()
            // 데이터 추가
            self.OBJ_SELECT["background"] = UIImage(named: "logo2")!.pngData(); self.COUPON_I.image = UIImage(named: "logo2")
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(ALERT, animated: true, completion: nil)
    }
    
    @objc func SELECT_B(_ sender: UIButton) {
        
        view.endEditing(true)
        
        UserDefaults.standard.setValue(StoreObject[row].usePangpang, forKey: "use_pangpang")
        
        if UserDefaults.standard.string(forKey: "use_pangpang") ?? "false" == "true" {
            if COUNT_TF.text! == "" {
                S_NOTICE("수량 (!)")
            } else if PASSWORD_TF.text!.count != 4 {
                S_NOTICE("번호 (!)")
            } else {
                S_INDICATOR(view, text: "레고팡팡 적용중...", animated: true)
                PUT_PANGPANG(NAME: "레고팡팡 쿠폰생성", AC_TYPE: "store")
            }
        } else {
            S_NOTICE("레고팡팡 미신청으로 제한됨")
        }
    }
    
    @objc func QRCODE_B(_ sender: UIButton) { COUPON_TF.resignFirstResponder(); COUNT_TF.resignFirstResponder()
        
        let data = StoreObject[row]
        
        if data.pangpangRemain == 0 {
            S_NOTICE("레고팡팡 개수 (!)")
        } else {
            let VC = storyboard?.instantiateViewController(withIdentifier: "VC_QRSCAN") as! VC_QRSCAN
            VC.OBJ_PANGPANG = OBJ_PANGPANG; VC.OBJ_POSITION = 0
            navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @objc func VC_POPUP3_B(_ sender: UIButton) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "VC_POPUP3") as! VC_POPUP3
        VC.modalPresentationStyle = .overCurrentContext; VC.transitioningDelegate = self
        VC.AC_TYPE = "pangpang_history"; VC.DT_TYPE = "receive_time"
        present(VC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
    }
}

extension VC1_MAIN: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if OBJ_PANGPANG.count > 0 { return OBJ_PANGPANG.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = OBJ_PANGPANG[indexPath.item]
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC1_MAIN1", for: indexPath) as! TC1_MAIN
        CELL.PROTOCOL = self; CELL.OBJ_PANGPANG = OBJ_PANGPANG; CELL.OBJ_POSITION = indexPath.item
        
        if DATA.RECEIVE_TIME.count == 13 {
            CELL.DATETIME_L.text = FM_TIMESTAMP((Int(DATA.RECEIVE_TIME) ?? 0)/1000, "yy.MM.dd (E) a hh:mm")
        } else {
            CELL.DATETIME_L.text = FM_TIMESTAMP(Int(DATA.RECEIVE_TIME) ?? 0, "yy.MM.dd (E) a hh:mm")
        }
        CELL.DELETE_B.tag = indexPath.item; CELL.DELETE_B.addTarget(self, action: #selector(DELETE_B(_:)), for: .touchUpInside)
        CELL.USE_L1.text = "\(DATA.USE_NICK)님"
//        if DATA.USE_TIME == "0" {
//            CELL.USE_L2.isHidden = true
//        } else if DATA.USE_TIME.count == 13 {
//            CELL.USE_L2.isHidden = false; CELL.USE_L2.text = FM_TIMESTAMP((Int(DATA.USE_TIME) ?? 0)/1000, "쿠폰 사용시간: yy.MM.dd (E) a hh:mm")
//        } else {
//            CELL.USE_L2.isHidden = false; CELL.USE_L2.text = FM_TIMESTAMP(Int(DATA.USE_TIME) ?? 0, "쿠폰 사용시간: yy.MM.dd (E) a hh:mm")
//        }
        
        if DATA.USE_TIME == "" || DATA.USE_TIME == "0" {
            CELL.DELETE_L.isHidden = false; CELL.DELETE_B.isHidden = false
            CELL.COUPON_L.layer.borderColor = UIColor.lightGray.cgColor; CELL.COUPON_L.textColor = .lightGray
        } else {
            CELL.DELETE_L.isHidden = true; CELL.DELETE_B.isHidden = true
            CELL.COUPON_L.layer.borderColor = UIColor.H_FF6F00.cgColor; CELL.COUPON_L.textColor = .H_FF6F00
        }
        if DATA.WRITE_REVIEW == "" || DATA.WRITE_REVIEW == "false" {
            CELL.REVIEW_L.layer.borderColor = UIColor.lightGray.cgColor; CELL.REVIEW_L.textColor = .lightGray
            CELL.REVIEW_B.isHidden = true
        } else {
            CELL.REVIEW_L.layer.borderColor = UIColor.H_FF6F00.cgColor; CELL.REVIEW_L.textColor = .H_FF6F00
            CELL.REVIEW_B.isHidden = false; CELL.REVIEW_B.setTitle("  \(DATA.REVIEW_IDX)", for: .normal); CELL.REVIEW_B.addTarget(self, action: #selector(REVIEW_B(_:)), for: .touchUpInside)
        }
        CELL.PRICE_TF.placeholder("금액을 입력해 주세요.", COLOR: .white.withAlphaComponent(0.7))
        if DATA.SALE_PRICE != 0 { CELL.PRICE_TF.text = "\(DATA.SALE_PRICE)" } else { CELL.PRICE_TF.text = "" }
        CELL.PRICE_B.addTarget(CELL, action: #selector(CELL.PRICE_B(_:)), for: .touchUpInside)
        
        return CELL
    }
    
    @objc func DELETE_B(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: "", message: "\(OBJ_PANGPANG[sender.tag].USE_NICK)님의 팡팡내역을 삭제하시겠습니까?", preferredStyle: .alert)
        ALERT.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.PUT_DELETE(NAME: "팡팡내역삭제", AC_TYPE: "pangpang_history", POSITION: sender.tag)
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(ALERT, animated: true, completion: nil)
    }
    
    @objc func REVIEW_B(_ sender: UIButton) {
        if "\(sender.titleLabel?.text! ?? "")".contains("http") {
            if let LINK = sender.titleLabel?.text!.replacingOccurrences(of: " ", with: "") { UIApplication.shared.open(URL(string: LINK)!, options: [:]) }
        }
    }
}
