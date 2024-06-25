//
//  DataCenter.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/14.
//

import UIKit
import SDWebImage
import Nuke
import FirebaseFirestore

extension UIViewController {
    
    func GET_LEGOUP(NAME: String, AC_TYPE: String) {
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        let STORE_CASH = "\((Int(UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeCash) ?? 0) - 500)"
        let TIMESTAMP = "\(setKoreaTimestamp())"
        
        if (Int(UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeCash) ?? 0) > 0 {
            
            Firestore.firestore().collection(AC_TYPE).document(STORE_ID).setData(["store_cash": STORE_CASH, "use_item_time": TIMESTAMP], merge: true) { _ in
                
                let PARAMETERS: [String: Any] = [
                    "\(TIMESTAMP)": [
                        "lepay_amount": "-500",
                        "lepay_detail": "레고UP",
                        "lepay_time": TIMESTAMP,
                        "lepay_type": "사용"
                    ]
                ]
                
                Firestore.firestore().collection("lepay_history").document(STORE_ID).setData(PARAMETERS, merge: true) { error in
                    
                    if error == nil {
                        
                        if let refresh = UIViewController.LoadingViewControllerDelegate {
                            refresh.loadingData()
                        }
                    }
                }
            }
        } else {
                
//            let ALERT = UIAlertController(title: "", message: "레pay 잔액이 부족합니다.", preferredStyle: .alert)
//
//            ALERT.addAction(UIAlertAction(title: "충전하기", style: .default, handler: { _ in
//                let VC = self.storyboard?.instantiateViewController(withIdentifier: "VC_LEPAY") as! VC_LEPAY
//                self.navigationController?.pushViewController(VC, animated: true, completion: { self.segueViewController(identifier: "VC_PAYMENT") })
//            }))
//            ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
//
//            present(ALERT, animated: true, completion: nil)
            
            S_NOTICE("레pay 잔액 부족")
        }
    }
    
    func GET_STORE(NAME: String, AC_TYPE: String) {
        // 데이터 삭제
        UIViewController.AD.OBJ_USER.removeAll()
        UIViewController.AD.OBJ_STORE.removeAll()
        
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        let STORE_CATEGORY = UserDefaults.standard.string(forKey: "store_category") ?? ""
        Firestore.firestore().collection(AC_TYPE).document(STORE_ID).getDocument { response, error in
            
            if response?.data() != nil { // print("[\(NAME)] SUCCESS: \(response?.data() as Any)")
                
                UIViewController.AD.LISTENER = Firestore.firestore().collection(AC_TYPE).whereField("store_category", isEqualTo: STORE_CATEGORY).addSnapshotListener { snapshot, error in
                    
                    // 데이터 삭제
                    UIViewController.AD.OBJ_USER.removeAll()
                    UIViewController.AD.OBJ_STORE.removeAll()
                    
                    SDImageCache.shared.clearMemory(); SDImageCache.shared.clearDisk(); ImageCache.shared.removeAll()

                    if let snapshot = snapshot { // print("[\(NAME)] SUCCESS: \(snapshot.documents)")
                        
                        DispatchQueue.global().async {
                            
                            for response in snapshot.documents {
                                
                                let DICT = response.data()
                                let AP_VALUE = API_USER()
                                
                                AP_VALUE.SET_DELIVERY_TIME(DELIVERY_TIME: DICT["delivery_time"] as Any)
                                AP_VALUE.SET_FCM_ID(FCM_ID: DICT["fcm_id"] as Any)
                                AP_VALUE.SET_FOOD_TYPE(FOOD_TYPE: DICT["food_type"] as Any)
                                AP_VALUE.SET_ITEM_STAMP(ITEM_STAMP: DICT["item_stamp"] as Any)
                                AP_VALUE.SET_LAT(LAT: DICT["lat"] as Any)
                                AP_VALUE.SET_LEDELIVERY_FEE(LEDELIVERY_FEE: DICT["ledelivery_fee"] as Any)
                                AP_VALUE.SET_LEDELIVERY_TIME(LEDELIVERY_TIME: DICT["ledelivery_time"] as Any)
                                AP_VALUE.SET_LIKE_COUNT(LIKE_COUNT: DICT["like_count"] as Any)
                                AP_VALUE.SET_LON(LON: DICT["lon"] as Any)
                                AP_VALUE.SET_MG_NAME(MG_NAME: DICT["manager_name"] as Any)
                                AP_VALUE.SET_MG_PHONE(MG_PHONE: DICT["manager_number"] as Any)
                                AP_VALUE.SET_ON_BIRTH(ON_BIRTH: DICT["on_birth"] as Any)
                                AP_VALUE.SET_ON_NAME(ON_NAME: DICT["owner_name"] as Any)
                                AP_VALUE.SET_ON_PHONE(ON_PHONE: DICT["owner_number"] as Any)
                                AP_VALUE.SET_PP_IMAGE(PP_IMAGE: DICT["pangpang_image"] as Any)
                                AP_VALUE.SET_PP_MENU(PP_MENU: DICT["pangpang_menu"] as Any)
                                AP_VALUE.SET_PP_REMAIN(PP_REMAIN: DICT["pangpang_remain"] as Any)
                                AP_VALUE.SET_POINT_COUNT(POINT_COUNT: DICT["point_count"] as Any)
                                AP_VALUE.SET_ST_ADDRESS(ST_ADDRESS: DICT["store_address"] as Any)
                                AP_VALUE.SET_ST_CASH(ST_CASH: DICT["store_cash"] as Any)
                                AP_VALUE.SET_ST_CATEGORY(ST_CATEGORY: DICT["store_category"] as Any)
                                AP_VALUE.SET_ST_COLOR(ST_COLOR: DICT["store_color"] as Any)
                                AP_VALUE.SET_ST_EMAIL(ST_EMAIL: DICT["store_email"] as Any)
                                AP_VALUE.SET_ST_ETC(ST_ETC: DICT["store_etc"] as Any)
                                AP_VALUE.SET_ST_ID(ST_ID: DICT["store_id"] as Any)
                                AP_VALUE.SET_ST_IMAGE(ST_IMAGE: DICT["store_img"] as Any)
                                AP_VALUE.SET_ST_IMAGES(ST_IMAGES: DICT["img_array"] as Any)
                                AP_VALUE.SET_ST_LASTORDER(ST_LASTORDER: DICT["store_lastorder"] as Any)
                                AP_VALUE.SET_ST_MENU(ST_MENU: self.SET_ST_MENU(ARRAY: DICT["store_menu"] as? [Any] ?? []))
                                AP_VALUE.SET_ST_NAME(ST_NAME: DICT["store_name"] as Any)
                                AP_VALUE.SET_ST_OPEN(ST_OPEN: DICT["store_openingtime"] as Any)
                                AP_VALUE.SET_ST_PW(ST_PW: DICT["store_password"] as Any)
                                AP_VALUE.SET_ST_POINT(ST_POINT: DICT["store_point"] as Any)
                                AP_VALUE.SET_ST_REGNUM(ST_REGNUM: DICT["store_regnum"] as Any)
                                AP_VALUE.SET_ST_RESTDAY(ST_RESTDAY: DICT["store_restday"] as Any)
                                AP_VALUE.SET_ST_SUB_TITLE(ST_SUB_TITLE: DICT["store_sub_title"] as Any)
                                AP_VALUE.SET_ST_TAG(ST_TAG: DICT["store_tag"] as Any)
                                AP_VALUE.SET_ST_TAX_EMAIL(ST_TAX_EMAIL: DICT["store_tax_email"] as Any)
                                AP_VALUE.SET_ST_TEL(ST_TEL: DICT["store_tel"] as Any)
                                AP_VALUE.SET_ST_TIME(ST_TIME: DICT["store_time"] as Any)
                                AP_VALUE.SET_USE_ITEM_TIME(USE_ITEM_TIME: DICT["use_item_time"] as Any)
                                AP_VALUE.SET_USE_PANGPANG(USE_PANGPANG: DICT["use_pangpang"] as Any)
                                AP_VALUE.SET_VIEW_COUNT(VIEW_COUNT: DICT["view_count"] as Any)
                                AP_VALUE.SET_WAITING_STEP(WAITING_STEP: DICT["waiting_step"] as Any)
                                // 데이터 추가
                                if DICT["store_id"] as? String ?? "" == STORE_ID {
                                    UserDefaults.standard.setValue(DICT["waiting_step"] as? String ?? "0", forKey: "waiting_step")
                                    UIViewController.AD.OBJ_USER.append(AP_VALUE)
                                }
                                
                                if UserDefaults.standard.bool(forKey: "first") {
                                    UIViewController.AD.OBJ_STORE.append(AP_VALUE)
                                    UIViewController.AD.OBJ_STORE.sort { front, behind in front.USE_ITEM_TIME > behind.USE_ITEM_TIME }
                                    UserDefaults.standard.setValue(false, forKey: "first")
                                    UserDefaults.standard.synchronize()
                                }
                            }
                            
                            DispatchQueue.main.async {
                                if UIViewController.AD.OBJ_USER.count == 0 {
                                    self.segueViewController(identifier: "VC_LOGIN"); return
                                } else if UserDefaults.standard.bool(forKey: "first") {
                                    if UserDefaults.standard.string(forKey: "waiting_step") ?? "" == "2" {
                                        self.PRESENT_TBC(IDENTIFIER: "TBC", INDEX: 2)
                                    } else {
                                        self.segueViewController(identifier: "VC_JUDGE")
                                    }
                                } else {
                                    if let RVC1 = UIViewController.VC0_MAIN_DEL { RVC1.TABLEVIEW.reloadData() }
                                    if let RVC2 = UIViewController.VC1_MAIN_DEL { RVC2.NUKE(IV: RVC2.COUPON_I, IU: UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].pangpangImage, PH: UIImage(), RD: 10, CM: .scaleAspectFill)//; RVC2.COUNT_TF.text = "\(UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].pangpangRemain)"
                                    }
                                    if let RVC3 = UIViewController.VC_QRSCAN_DEL {
                                        if UIViewController.AD.OBJ_USER.count > 0, UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].pangpangRemain == 0 {
                                            RVC3.S_NOTICE("레고팡팡 개수 (!)"); RVC3.navigationController?.popViewController(animated: true)
                                        }
                                    }
                                    if let RVC4 = UIViewController.VC2_MAIN_DEL { RVC4.TABLEVIEW.reloadData() }
                                    if let RVC5 = UIViewController.VC3_MAIN_DEL { RVC5.viewDidLoad() }
                                }
                            }
                        }
                    } else { print("[\(NAME)] FAILURE: \(error as Any)")
                        self.S_NOTICE("응답 에러"); self.segueViewController(identifier: "VC_LOGIN")
                    }
                }
            } else {
                self.S_NOTICE("응답 에러"); self.segueViewController(identifier: "VC_LOGIN")
            }
        }
    }
    
    func SET_ST_MENU(ARRAY: [Any]) -> [API_ST_MENU] {
        
        var OBJ_ST_MENU: [API_ST_MENU] = []
        
        for (_, DATA) in ARRAY.enumerated() {
            
            let DICT = DATA as? [String: Any]
            let AP_VALUE = API_ST_MENU()
            
            AP_VALUE.SET_MENU_NAME(MENU_NAME: DICT?["menu_name"] as Any)
            AP_VALUE.SET_MENU_PRICE(MENU_PRICE: DICT?["menu_price"] as Any)
            // 데이터 추가
            OBJ_ST_MENU.append(AP_VALUE)
        }
        
        return OBJ_ST_MENU
    }
}

extension VC_LOADING {
    
    func loadingData(update: Bool = false) { print("loading - collcetion: app, store")
        // 데이터 초기화
        UIViewController.appDelegate.AppObject = AppData(versionCode: "", versionName: "", versionUrl: "")
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("app").document("ios").getDocument { response, error in
                
                guard let response = response else { return }
                
                let dict = response.data() ?? [:]
                
                // 데이터 추가
                UIViewController.appDelegate.AppObject = AppData(
                    versionCode: dict["version_code"] as? String ?? "",
                    versionName: dict["version_name"] as? String ?? "",
                    versionUrl: dict["version_url"] as? String ?? ""
                )
                
                DispatchGroup.leave()
            }
        }
        
        var loginCheck: Bool = false
        var storeCategory: String = ""
            
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            let StoreId = UserDefaults.standard.string(forKey: "store_id") ?? ""
            
            if StoreId != "" {
                
                Firestore.firestore().collection("store").document(StoreId).getDocument { response, error in
                    
                    guard let response = response else { return }
                    
                    let dict = response.data() ?? [:]
                    
                    if StoreId == (dict["store_id"] as? String ?? "") {
                        loginCheck = true
                        storeCategory = dict["store_category"] as? String ?? ""
                    }
                    
                    DispatchGroup.leave()
                }
                
            } else {
                DispatchGroup.leave()
            }
        }
        
        DispatchGroup.notify(queue: .main) {
            
            let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
            let appBuildCode: Int = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1") ?? 1
            let storeVersion: String = UIViewController.appDelegate.AppObject.versionName
            let storeBuildCode: Int = Int(UIViewController.appDelegate.AppObject.versionCode) ?? 1
            
            print("version - 앱: \(appVersion)(\(appBuildCode)) / 스토어: \(storeVersion)(\(storeBuildCode))")
            
            if storeBuildCode > appBuildCode {
                let alert = UIAlertController(title: "소프트웨어 업데이트", message: "레고양파주 파트너 \(storeVersion)을(를) 사용자의 iPhone에서 사용할 수 있으며 설치할 준비가 되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "지금 설치", style: .default, handler: { _ in
                    UIApplication.shared.open(URL(string: UIViewController.appDelegate.AppObject.versionUrl)!)
                }))
                self.present(alert, animated: true, completion: nil)
            } else if loginCheck {
                self.loadingData2(update: update, storeCategory: storeCategory)
            } else {
                self.segueViewController(identifier: "VC_LOGIN")
            }
        }
    }
    
    func loadingData2(update: Bool = false, storeCategory: String) {
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            let StoreId = UserDefaults.standard.string(forKey: "store_id") ?? ""
            Firestore.firestore().collection("store").whereField("store_category", isEqualTo: storeCategory).getDocuments { responses, error in
                // 데이터 초기화
                UIViewController.appDelegate.StoreObject.removeAll()
                UIViewController.appDelegate.row = 0
                
                guard let responses = responses else { return }
                
                for response in responses.documents {
                    
                    let dict = response.data()
                    let apiValue = StoreData()
                    
                    apiValue.setEnteringTime(forKey: dict["entering_time"] as Any)
                    apiValue.setImageArray(forKey: dict["img_array"] as Any)
                    apiValue.setLat(forKey: dict["lat"] as Any)
                    apiValue.setLikeCount(forKey: dict["like_count"] as Any)
                    apiValue.setLon(forKey: dict["lon"] as Any)
                    apiValue.setManagerName(forKey: dict["manager_name"] as Any)
                    apiValue.setManagerNumber(forKey: dict["manager_number"] as Any)
                    apiValue.setOwnerBirth(forKey: dict["owner_birth"] as Any)
                    apiValue.setOwnerName(forKey: dict["owner_name"] as Any)
                    apiValue.setOwnerNumber(forKey: dict["owner_number"] as Any)
                    apiValue.setPangpangImage(forKey: dict["pangpang_image"] as Any)
                    apiValue.setPangpangMenu(forKey: dict["pangpang_menu"] as Any)
                    apiValue.setPangpangPassword(forKey: dict["pangpang_pw"] as Any)
                    apiValue.setPangpangRemain(forKey: dict["pangpang_remain"] as Any)
                    apiValue.setStoreEmail(forKey: dict["store_email"] as Any)
                    apiValue.setStoreAddress(forKey: dict["store_address"] as Any)
                    apiValue.setStoreCategory(forKey: dict["store_category"] as Any)
                    apiValue.setStoreCash(forKey: dict["store_cash"] as Any)
                    apiValue.setStoreColor(forKey: dict["store_color"] as Any)
                    apiValue.setStoreEtc(forKey: dict["store_etc"] as Any)
                    apiValue.setStoreId(forKey: dict["store_id"] as Any)
                    apiValue.setStoreImage(forKey: dict["store_img"] as Any)
                    apiValue.setStoreLastOrder(forKey: dict["store_lastorder"] as Any)
                    apiValue.setStoreMenu(forKey: self.setStoreMenu(forKey: dict["store_menu"] as? [Any] ?? []))
                    apiValue.setStoreName(forKey: dict["store_name"] as Any)
                    apiValue.setStorePassword(forKey: dict["store_password"] as Any)
                    apiValue.setStoreRegnum(forKey: dict["store_regnum"] as Any)
                    apiValue.setStoreRestday(forKey: dict["store_restday"] as Any)
                    apiValue.setStoreSubTitle(forKey: dict["store_sub_title"] as Any)
                    apiValue.setStoreTag(forKey: dict["store_tag"] as Any)
                    apiValue.setStoreTaxEmail(forKey: dict["store_tax_email"] as Any)
                    apiValue.setStoreTel(forKey: dict["store_tel"] as Any)
                    apiValue.setStoreTime(forKey: dict["store_time"] as Any)
                    apiValue.setUseItemTime(forKey: dict["use_item_time"] as Any)
                    apiValue.setUsePangpang(forKey: dict["use_pangpang"] as Any)
                    apiValue.setViewCount(forKey: dict["view_count"] as Any)
                    apiValue.setWaitingStep(forKey: dict["waiting_step"] as Any)
                    // 데이터 추가
                    UIViewController.appDelegate.StoreObject.append(apiValue)
                }
                
                UIViewController.appDelegate.StoreObject.sort { front, behind in front.useItemTime > behind.useItemTime }
                
                for (i, data) in UIViewController.appDelegate.StoreObject.enumerated() {
                    if StoreId == data.storeId { UIViewController.appDelegate.row = i; break }
                }
                
                DispatchGroup.leave()
            }
        }
        
        DispatchGroup.notify(queue: .main) {
            
            if !UserDefaults.standard.bool(forKey: "first") {
                if let refresh_1 = UIViewController.MarketViewControllerDelegate {
                    refresh_1.TABLEVIEW.reloadData()
                }
//                if let refresh_2 = UIViewController.PangpangViewControllerDelegate {
//                    refresh_2.COUNT_TF.text = "\(UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].pangpangRemain)"
//                }
                if let refresh_3 = UIViewController.StoreViewControllerDelegate {
                    refresh_3.TABLEVIEW.reloadData()
                }
                if let refresh_4 = UIViewController.StoreEditViewControllerDelegate {
                    refresh_4.viewDidLoad()
                }
            } else if update {
                if let refresh = UIViewController.StoreViewControllerDelegate {
                    refresh.TABLEVIEW.reloadData(); refresh.refreshControl.endRefreshing()
                }
                return
            } else if UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].waitingStep == "2" {
                self.PRESENT_TBC(IDENTIFIER: "TBC", INDEX: 2)
            } else {
                self.segueViewController(identifier: "VC_JUDGE")
            }
        }
    }
    
    func setStoreMenu(forKey: [Any]) -> [StoreMenuData] {
        
        var StoreMenuObject: [StoreMenuData] = []
        
        for response in forKey {
            
            let dict = response as? [String: Any] ?? [:]
            let apiValue = StoreMenuData()
            
            apiValue.setMenuName(forKey: dict["menu_name"] as Any)
            apiValue.setMenuPrice(forKey: dict["menu_price"] as Any)
            // 데이터 추가
            StoreMenuObject.append(apiValue)
        }
        
        return StoreMenuObject
    }
}

struct AppData {
    
    var versionCode: String = ""
    var versionName: String = ""
    var versionUrl: String = ""
}

class StoreData {
    
    var enteringTime: String = ""
    var imageArray: [String] = []
    var lat: String = ""
    var likecount: Int = 0
    var lon: String = ""
    var managerName: String = ""
    var managerNumber: String = ""
    var ownerBirth: String = ""
    var ownerName: String = ""
    var ownerNumber: String = ""
    var pangpangImage: String = ""
    var pangpangMenu: String = ""
    var pangpangPassword: String = ""
    var pangpangRemain: Int = 0
    var storeAddress: String = ""
    var storeCategory: String = ""
    var storeCash: String = ""
    var storeColor: String = ""
    var storeEmail: String = ""
    var storeEtc: String = ""
    var storeId: String = ""
    var storeImage: String = ""
    var storeLastOrder: String = ""
    var storeMenu: [StoreMenuData] = []
    var storeName: String = ""
    var storePassword: String = ""
    var storeRegnum: String = ""
    var storeRestday: String = ""
    var storeSubTitle: String = ""
    var storeTag: [String] = []
    var storeTaxEmail: String = ""
    var storeTel: String = ""
    var storeTime: String = ""
    var useItemTime: String = ""
    var usePangpang: String = ""
    var viewCount: Int = 0
    var waitingStep: String = ""
    
    func setEnteringTime(forKey: Any) { self.enteringTime = forKey as? String ?? "" }
    func setImageArray(forKey: Any) { self.imageArray = forKey as? [String] ?? [] }
    func setLat(forKey: Any) { self.lat = forKey as? String ?? "" }
    func setLikeCount(forKey: Any) { self.likecount = forKey as? Int ?? 0 }
    func setLon(forKey: Any) { self.lon = forKey as? String ?? "" }
    func setManagerName(forKey: Any) { self.managerName = forKey as? String ?? "" }
    func setManagerNumber(forKey: Any) { self.managerNumber = forKey as? String ?? "" }
    func setOwnerBirth(forKey: Any) { self.ownerBirth = forKey as? String ?? "" }
    func setOwnerName(forKey: Any) { self.ownerName = forKey as? String ?? "" }
    func setOwnerNumber(forKey: Any) { self.ownerNumber = forKey as? String ?? "" }
    func setPangpangImage(forKey: Any) { self.pangpangImage = forKey as? String ?? "" }
    func setPangpangMenu(forKey: Any) { self.pangpangMenu = forKey as? String ?? "" }
    func setPangpangPassword(forKey: Any) { self.pangpangPassword = forKey as? String ?? "" }
    func setPangpangRemain(forKey: Any) { self.pangpangRemain = forKey as? Int ?? 0 }
    func setStoreAddress(forKey: Any) { self.storeAddress = forKey as? String ?? "" }
    func setStoreCategory(forKey: Any) { self.storeCategory = forKey as? String ?? "" }
    func setStoreCash(forKey: Any) { self.storeCash = forKey as? String ?? "" }
    func setStoreColor(forKey: Any) { self.storeColor = forKey as? String ?? "" }
    func setStoreEmail(forKey: Any) { self.storeEmail = forKey as? String ?? "" }
    func setStoreEtc(forKey: Any) { self.storeEtc = forKey as? String ?? "" }
    func setStoreId(forKey: Any) { self.storeId = forKey as? String ?? "" }
    func setStoreImage(forKey: Any) { self.storeImage = forKey as? String ?? "" }
    func setStoreLastOrder(forKey: Any) { self.storeLastOrder = forKey as? String ?? "" }
    func setStoreMenu(forKey: Any) { self.storeMenu = forKey as? [StoreMenuData] ?? [] }
    func setStoreName(forKey: Any) { self.storeName = forKey as? String ?? "" }
    func setStorePassword(forKey: Any) { self.storePassword = forKey as? String ?? "" }
    func setStoreRegnum(forKey: Any) { self.storeRegnum = forKey as? String ?? "" }
    func setStoreRestday(forKey: Any) { self.storeRestday = forKey as? String ?? "" }
    func setStoreSubTitle(forKey: Any) { self.storeSubTitle = forKey as? String ?? "" }
    func setStoreTag(forKey: Any) { self.storeTag = forKey as? [String] ?? [] }
    func setStoreTaxEmail(forKey: Any) { self.storeTaxEmail = forKey as? String ?? "" }
    func setStoreTel(forKey: Any) { self.storeTel = forKey as? String ?? "" }
    func setStoreTime(forKey: Any) { self.storeTime = forKey as? String ?? "" }
    func setUseItemTime(forKey: Any) { self.useItemTime = forKey as? String ?? "" }
    func setUsePangpang(forKey: Any) { self.usePangpang = forKey as? String ?? "" }
    func setViewCount(forKey: Any) { self.viewCount = forKey as? Int ?? 0 }
    func setWaitingStep(forKey: Any) { self.waitingStep = forKey as? String ?? "" }
}

class StoreMenuData {
    
    var menuName: String = ""
    var menuPrice: String = ""
    
    func setMenuName(forKey: Any) { self.menuName = forKey as? String ?? "" }
    func setMenuPrice(forKey: Any) { self.menuPrice = forKey as? String ?? "" }
}
