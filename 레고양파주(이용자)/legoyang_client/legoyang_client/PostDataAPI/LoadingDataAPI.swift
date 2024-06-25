//
//  LoadingDataAPI.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/03.
//

import UIKit
import FirebaseFirestore
import FirebaseMessaging
import UserNotifications

extension LoadingViewController {
    
    func loadingData(mainUpdate: Bool = false, popup: Bool = false) { print("loading - collection: app_lego, member, member_pangpang_history, store, legonggu_item")
        // 데이터 초기화
        UIViewController.appDelegate.listener = nil
        UIViewController.appDelegate.MemberId = UserDefaults.standard.string(forKey: "member_id") ?? ""
        UIViewController.appDelegate.AppLegoObject = AppLegoData(appCheck: "", checkContent: "", community: [], logoImage: "", mainContents: [], versionCode: "", versionName: "", versionUrl: "")
        UIViewController.appDelegate.CategoryObject.removeAll()
        if !mainUpdate { UIViewController.appDelegate.MemberObject = MemberData(benefitPoint: "0", code: "", deliveryAddress: [], email: "", fcmId: "", freeDeliveryCoupon: 0, grade: "1", id: "", lat: "0.0", legongguTopic: "", lon: "0.0", mylikeStore: [], name: "", nick: "", noticeList: [], number: "", osPlatform: "ios", pangpangTopic: "", password: "", platform: "", point: "0", profileImg: "", signupTime: "0") }
        UIViewController.appDelegate.MemberPangpangHistoryObject.removeAll()
        UIViewController.appDelegate.MainPangpangStoreObject.removeAll()
        UIViewController.appDelegate.MainLegongguObject.removeAll()
        UIViewController.appDelegate.NoticeListObject.removeAll()
        UIViewController.appDelegate.noticeCount = 0
        
        let DispatchGroup = DispatchGroup()
        // 메인
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("app_lego").document("ios").getDocument { response, error in
                
                guard let response = response else { return }
                
                let dict = response.data() ?? [:]
                
                // 데이터 추가
                UIViewController.appDelegate.AppLegoObject = AppLegoData(
                    appCheck: dict["app_check"] as? String ?? "",
                    checkContent: dict["check_content"] as? String ?? "",
                    community: self.setCommunity(forKey: dict["community"] as? [Any] ?? []),
                    logoImage: dict["logo_img"] as? String ?? "",
                    mainContents: self.setMainContents(forKey: dict["main_contents"] as? [Any] ?? []),
                    versionCode: dict["version_code"] as? String ?? "",
                    versionName: dict["version_name"] as? String ?? "",
                    versionUrl: dict["version_url"] as? String ?? ""
                )
                
                if let refresh_1 = UIViewController.MainViewControllerDelegate {
//                    refresh_1.listView.reloadSections(IndexSet(integer: 0), with: .none)
                    refresh_1.listView.reloadData()
                }
                
                DispatchGroup.leave()
            }
        }
        
        // 카테고리
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("store_category").getDocuments { responses, error in
                
                guard let responses = responses else { return }
                
                for response in responses.documents {
                    
                    let dict = response.data()
                    let apiValue = CategoryData()
                    
                    apiValue.setCateName(forKey: dict["cate_name"] as Any)
                    apiValue.setCount(forKey: dict["count"] as Any)
                    apiValue.setImageUrl(forKey: dict["img_url"] as Any)
                    apiValue.setPangpangCount(forKey: dict["pangpang_count"] as Any)
                    // 데이터 추가
                    UIViewController.appDelegate.CategoryObject.append(apiValue)
                }
                
                UIViewController.appDelegate.CategoryObject.sort(by: { front, behind in front.count > behind.count })
                
                if let refresh_1 = UIViewController.LocationAuthorityViewControllerDelegate {
                    refresh_1.gridView.reloadData()
                }
                if let refresh_2 = UIViewController.CategoryViewControllerDelegate {
                    refresh_2.gridView.reloadData()
                }
                
                DispatchGroup.leave()
            }
        }
        
        // 회원정보
        if !mainUpdate {
            
            DispatchGroup.enter()
            DispatchQueue.global().async {
                
                if UIViewController.appDelegate.MemberId != "" {
                    
                    Firestore.firestore().collection("member").document(UIViewController.appDelegate.MemberId).setData(["fcm_id": UserDefaults.standard.string(forKey: "fcm_id") ?? "", "os_platform": "ios"], merge: true)
                    
                    Firestore.firestore().collection("member").document(UIViewController.appDelegate.MemberId).getDocument { response, error in
                        
                        guard let response = response else { return }
                        
                        let dict = response.data() ?? [:]
                        
                        // 데이터 추가
                        UIViewController.appDelegate.MemberObject = MemberData(
                            benefitPoint: dict["benefit_point"] as? String ?? "",
                            code: dict["code"] as? String ?? "",
                            deliveryAddress: dict["delivery_address"] as? [String] ?? [],
                            email: dict["email"] as? String ?? "",
                            fcmId: dict["fcm_id"] as? String ?? "",
                            freeDeliveryCoupon: dict["free_delivery_coupon"] as? Int ?? 0,
                            grade: dict["grade"] as? String ?? "",
                            id: dict["id"] as? String ?? "",
                            lat: dict["lat"] as? String ?? "",
                            legongguTopic: dict["legonggu_topic"] as? String ?? "",
                            lon: dict["lon"] as? String ?? "",
                            mylikeStore: dict["mylike_store"] as? [String] ?? [],
                            name: dict["name"] as? String ?? "",
                            nick: dict["nick"] as? String ?? "",
                            noticeList: self.setNoticeListData(forKey: dict["noti_list"] as? [String: Any] ?? [:]),
                            number: dict["number"] as? String ?? "",
                            osPlatform: dict["os_platform"] as? String ?? "",
                            pangpangTopic: dict["pangpang_topic"] as? String ?? "",
                            password: dict["password"] as? String ?? "",
                            platform: dict["platform"] as? String ?? "",
                            point: dict["point"] as? String ?? "",
                            profileImg: dict["profile_img"] as? String ?? "",
                            signupTime: dict["signup_time"] as? String ?? ""
                        )
                        
                        if (dict["legonggu_topic"] as? String ?? "") == "true" {
                            Messaging.messaging().unsubscribe(fromTopic: "inform_gonggu_ios") { error in
                                if error == nil { Messaging.messaging().subscribe(toTopic: "inform_gonggu_ios") }
                            }
                            if UIViewController.appDelegate.MemberId == "01031853309" {
                                Messaging.messaging().unsubscribe(fromTopic: "gonggu_test_ios") { error in
                                    if error == nil { Messaging.messaging().subscribe(toTopic: "gonggu_test_ios") }
                                }
                            }
                        } else {
                            Messaging.messaging().unsubscribe(fromTopic: "inform_gonggu_ios")
                            Messaging.messaging().unsubscribe(fromTopic: "gonggu_test_ios")
                        }
                        if (dict["pangpang_topic"] as? String ?? "") == "true" {
                            Messaging.messaging().unsubscribe(fromTopic: "legopangpang_ios") { error in
                                if error == nil { Messaging.messaging().subscribe(toTopic: "legopangpang_ios") }
                            }
                            if UIViewController.appDelegate.MemberId == "01031853309" {
                                Messaging.messaging().unsubscribe(fromTopic: "around_test_ios") { error in
                                    if error == nil { Messaging.messaging().subscribe(toTopic: "around_test_ios") }
                                }
                            }
                        } else {
                            Messaging.messaging().unsubscribe(fromTopic: "legopangpang_ios")
                            Messaging.messaging().unsubscribe(fromTopic: "around_test_ios")
                        }
                        
                        if let refresh_1 = UIViewController.MainViewControllerDelegate {
//                            refresh_1.listView.reloadSections(IndexSet(integer: 0), with: .none)
                            refresh_1.listView.reloadData()
                        }
                        if let refresh_2 = UIViewController.MyPageViewController2Delegate {
                            refresh_2.listView.reloadData()
                        }
                    }
                    
                    DispatchGroup.leave()
                } else {
                    DispatchGroup.leave()
                }
            }
        }
        
        // 쿠폰
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            if UIViewController.appDelegate.MemberId != "" {
                
                UIViewController.appDelegate.listener = Firestore.firestore().collection("member_pangpang_history").document(UIViewController.appDelegate.MemberId).addSnapshotListener { response, error in
                    
                    guard let response = response else { return }
                    // 데이터 초기화
                    UIViewController.appDelegate.MemberPangpangHistoryObject.removeAll()
                    
                    let _: [()]? = response.data()?.compactMap({ (key: String, value: Any) in
                        
                        let dict = response.data()?[key] as? [String: Any] ?? [:]
                        let apiValue = MemberPangpangHistoryData()
                        
                        if (dict["use_time"] as? String ?? "0") != "0" && (dict["write_review"] as? String ?? "false") == "true" {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [dict["use_time"] as? String ?? ""])
                        }
                        
                        apiValue.setReceiveTime(forKey: dict["receive_time"] as Any)
                        apiValue.setReviewIdx(forKey: dict["review_idx"] as Any)
                        apiValue.setUseMenu(forKey: dict["use_menu"] as Any)
                        apiValue.setUseStoreId(forKey: dict["use_store_id"] as Any)
                        apiValue.setUseStoreName(forKey: dict["use_store_name"] as Any)
                        apiValue.setUseTime(forKey: dict["use_time"] as Any)
                        apiValue.setWriteReview(forKey: dict["write_review"] as Any)
                        // 데이터 추가
                        UIViewController.appDelegate.MemberPangpangHistoryObject.append(apiValue)
                    })
                    
                    if let refresh_1 = UIViewController.MainViewControllerDelegate {
//                        refresh_1.listView.reloadSections(IndexSet(integer: 0), with: .none)
                        refresh_1.listView.reloadData()
                    }
                    if let refresh_2 = UIViewController.CouponViewControllerDelegate {
                        
//                        if let refresh_3 = UIViewController.PangpangCouponViewControllerDelegate {
//
//                            if (refresh_3.type == "qrcode") || (refresh_3.type == "password") {
//
//                                let timestamp = "\(self.setKoreaTimestamp())"
//                                let params: [String: Any] = [
//                                    "noti_list": [
//                                        timestamp: [
//                                            "body": "매장 서비스는 어떠셨나요?\n다음 방문을 위해서 후기를 작성해 주세요 :)",
//                                            "data": "",
//                                            "readornot": "false",
//                                            "receive_time": timestamp,
//                                            "title": refresh_3.StoreObject.storeName,
//                                            "type": "review"
//                                        ]
//                                    ]
//                                ]
//                                Firestore.firestore().collection("member").document(UIViewController.appDelegate.MemberId).setData(params, merge: true)
//                                refresh_3.setReviewPush(pushId: refresh_3.StoreObject.storeId, title: "레고양파주", body: "매장 서비스는 어떠셨나요?\n다음 방문을 위해서 후기를 작성해 주세요 :)", userInfo: ["type": "use_coupon_ios"])
//                                refresh_3.S_NOTICE("레고팡팡 사용됨"); refresh_3.dismiss(animated: false, completion: nil); refresh_2.position = 1
//                            }
//                        }
                        
                        if let refresh_3 = UIViewController.CouponPasswordViewControllerDelegate {
                            
                            let timestamp = "\(self.setKoreaTimestamp())"
                            let params: [String: Any] = [
                                "noti_list": [
                                    timestamp: [
                                        "body": "매장 서비스는 어떠셨나요?\n다음 방문을 위해서 후기를 작성해 주세요 :)",
                                        "data": "",
                                        "readornot": "false",
                                        "receive_time": timestamp,
                                        "title": refresh_3.StoreObject.storeName,
                                        "type": "review"
                                    ]
                                ]
                            ]
                            Firestore.firestore().collection("member").document(UIViewController.appDelegate.MemberId).setData(params, merge: true)
                            refresh_3.setReviewPush(pushId: timestamp, title: "레고양파주", body: "매장 서비스는 어떠셨나요?\n다음 방문을 위해서 후기를 작성해 주세요 :)", userInfo: ["type": "use_coupon_ios"])
                            refresh_3.S_NOTICE("레고팡팡 사용됨"); refresh_3.dismiss(animated: false, completion: nil); refresh_2.position = 1
                        }
                        
                        refresh_2.loadingData()
                    }
                }
                
                DispatchGroup.leave()
            } else {
                DispatchGroup.leave()
            }
        }
        
        // 레고팡팡
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("store").order(by: "use_item_time", descending: true).limit(to: 20).getDocuments { responses, error in
                
                guard let responses = responses else { return }
                
                for response in responses.documents {
                    
                    let dict = response.data()
                    let apiValue = StoreData()
                    
                    apiValue.setEnteringTime(forKey: dict["entering_time"] as Any)
                    apiValue.setImageArray(forKey: dict["img_array"] as Any)
                    apiValue.setLat(forKey: dict["lat"] as Any)
                    apiValue.setLikeCount(forKey: dict["like_count"] as Any)
                    apiValue.setLon(forKey: dict["lon"] as Any)
                    apiValue.setOwnerName(forKey: dict["owner_name"] as Any)
                    apiValue.setOwnerNumber(forKey: dict["owner_number"] as Any)
                    apiValue.setPangpangImage(forKey: dict["pangpang_image"] as Any)
                    apiValue.setPangpangMenu(forKey: dict["pangpang_menu"] as Any)
                    apiValue.setPangpangRemain(forKey: dict["pangpang_remain"] as Any)
                    apiValue.setStoreAddress(forKey: dict["store_address"] as Any)
                    apiValue.setStoreCategory(forKey: dict["store_category"] as Any)
                    apiValue.setStoreColor(forKey: dict["store_color"] as Any)
                    apiValue.setStoreEtc(forKey: dict["store_etc"] as Any)
                    apiValue.setStoreId(forKey: dict["store_id"] as Any)
                    apiValue.setStoreImage(forKey: dict["store_img"] as Any)
                    apiValue.setStoreLastOrder(forKey: dict["store_lastorder"] as Any)
                    apiValue.setStoreMenu(forKey: dict["store_menu"] as Any)
                    apiValue.setStoreName(forKey: dict["store_name"] as Any)
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
                    UIViewController.appDelegate.MainPangpangStoreObject.append(apiValue)
                }
                
                if let refresh_1 = UIViewController.MainViewControllerDelegate {
//                    refresh_1.listView.reloadSections(IndexSet(integer: 1), with: .none)
                    refresh_1.listView.reloadData()
                }
                
                DispatchGroup.leave()
            }
        }
        
        // 레공구
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("legonggu_item").limit(to: 10).getDocuments { responses, error in
                
                guard let responses = responses else { return }
                
                for response in responses.documents {
                    
                    let dict = response.data()
                    let apiValue = LegongguData()
                    
                    apiValue.setEndTime(forKey: dict["end_time"] as Any)
                    apiValue.setItemBasePrice(forKey: dict["item_baseprice"] as Any)
                    apiValue.setItemContent(forKey: dict["item_content"] as Any)
                    apiValue.setItemImage(forKey: dict["item_img"] as Any)
                    apiValue.setItemMainImage(forKey: dict["item_mainimg"] as Any)
                    apiValue.setItemName(forKey: dict["item_name"] as Any)
                    apiValue.setItemPrice(forKey: dict["item_price"] as Any)
                    apiValue.setItemSaleInfo(forKey: dict["item_saleinfo"] as Any)
                    apiValue.setRemainCount(forKey: dict["remain_count"] as Any)
                    
                    if Int(dict["end_time"] as? String ?? "") ?? 0 > (self.setKoreaTimestamp()/1000) {
                        // 데이터 추가
                        UIViewController.appDelegate.MainLegongguObject.append(apiValue)
                    }
                }
                
                UIViewController.appDelegate.MainLegongguObject.sort { front, behind in front.endTime > behind.endTime }
                
                if let refresh_1 = UIViewController.MainViewControllerDelegate {
//                    refresh_1.listView.reloadSections(IndexSet(integer: 2), with: .none)
                    refresh_1.listView.reloadData()
                }
                
                DispatchGroup.leave()
            }
        }
        
        // 스토어
        self.loadingData2()
        // 레공구
        self.loadingData3()
        // 알림
        self.loadingData4()
        
        DispatchGroup.notify(queue: .main) {
            
            if mainUpdate, let refresh = UIViewController.MainViewControllerDelegate {
                
                if popup, refresh.view.window != nil { refresh.loadingData() }
                refresh.listView.reloadData()
                refresh.refreshControl.endRefreshing()
                
                return
            }
            
            UIViewController.appDelegate.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
            UIViewController.appDelegate.appBuildCode = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1") ?? 1
            UIViewController.appDelegate.storeVersion = UIViewController.appDelegate.AppLegoObject.versionName
            UIViewController.appDelegate.storeBuildCode = Int(UIViewController.appDelegate.AppLegoObject.versionCode) ?? 1
            
            print("version - 앱: \(UIViewController.appDelegate.appVersion)(\(UIViewController.appDelegate.appBuildCode)) / 스토어: \(UIViewController.appDelegate.storeVersion)(\(UIViewController.appDelegate.storeBuildCode))")
            
            if UIViewController.appDelegate.storeBuildCode > UIViewController.appDelegate.appBuildCode {
                
                let alert = UIAlertController(title: "소프트웨어 업데이트", message: "레고양파주 \(UIViewController.appDelegate.storeVersion)을(를) 사용자의 iPhone에서 사용할 수 있으며 설치할 준비가 되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "지금 설치", style: .default, handler: { _ in
                    UIApplication.shared.open(URL(string: UIViewController.appDelegate.AppLegoObject.versionUrl)!) { success in
                        if success { exit(0) }
                    }
                }))
                alert.addAction(UIAlertAction(title: "나중에 설치", style: .cancel, handler: { _ in
                    let segue = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                    segue.selectedIndex = 2
                    self.navigationController?.pushViewController(segue, animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else if UIViewController.appDelegate.AppLegoObject.appCheck == "true" {
                self.present(UIAlertController(title: "", message: UIViewController.appDelegate.AppLegoObject.checkContent, preferredStyle: .alert), animated: true, completion: nil)
            } else {
                
                let segue = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                segue.selectedIndex = 2
                self.navigationController?.pushViewController(segue, animated: true)
            }
        }
    }
    
    func setCommunity(forKey: [Any]) -> [CommunityData] {
        
        var CommunityObject: [CommunityData] = []
        
        for response in forKey {
            
            let dict = response as? [String: Any] ?? [:]
            let apiValue = CommunityData()
            
            apiValue.setDate(forKey: dict["date"] as Any)
            apiValue.setLike(forKey: dict["like"] as Any)
            apiValue.setTitle(forKey: dict["title"] as Any)
            apiValue.setUrl(forKey: dict["url"] as Any)
            apiValue.setView(forKey: dict["view"] as Any)
            apiValue.setWriter(forKey: dict["writer"] as Any)
            // 데이터 추가
            CommunityObject.append(apiValue)
        }
        
        return CommunityObject
    }
    
    func setMainContents(forKey: [Any]) -> [MainContentsData] {
        
        var MainContentsObject: [MainContentsData] = []
        
        for response in forKey {
            
            let dict = response as? [String: Any] ?? [:]
            let apiValue = MainContentsData()
            
            apiValue.setLinkUrl(forKey: dict["link_url"] as Any)
            apiValue.setType(forKey: dict["type"] as Any)
            apiValue.setUrl(forKey: dict["url"] as Any)
            // 데이터 추가
            MainContentsObject.append(apiValue)
        }
        
        return MainContentsObject
    }
    
    func setNoticeListData(forKey: [String: Any]) -> [NoticeListData] {
        
        var NoticeListObject: [NoticeListData] = []
        
        let _: [()] = forKey.compactMap { (key: String, value: Any) in
            
            let dict = forKey[key] as? [String: Any] ?? [:]
            let apiValue = NoticeListData()
            
            apiValue.setBody(forKey: dict["body"] as Any)
            apiValue.setData(forKey: dict["data"] as Any)
            apiValue.setReadOrNot(forKey: dict["readornot"] as Any)
            apiValue.setReceiveTime(forKey: dict["receive_time"] as Any)
            apiValue.setTitle(forKey: dict["title"] as Any)
            apiValue.setType(forKey: dict["type"] as Any)
            // 데이터 추가
            NoticeListObject.append(apiValue)
        }
        
        NoticeListObject.sort { front, behind in front.receiveTime > behind.receiveTime }
        
        return NoticeListObject
    }
}

// func set<#name#>(forKey: Any) { self.<#name#> = forKey as? String ?? "" }

struct AppLegoData {
    
    var appCheck: String = ""
    var checkContent: String = ""
    var community: [CommunityData] = []
    var logoImage: String = ""
    var mainContents: [MainContentsData] = []
    var versionCode: String = ""
    var versionName: String = ""
    var versionUrl: String = ""
}
class CommunityData {
    
    var date: String = ""
    var like: String = ""
    var title: String = ""
    var url: String = ""
    var view: String = ""
    var writer: String = ""
    
    func setDate(forKey: Any) { self.date = forKey as? String ?? "" }
    func setLike(forKey: Any) { self.like = forKey as? String ?? "" }
    func setTitle(forKey: Any) { self.title = forKey as? String ?? "" }
    func setUrl(forKey: Any) { self.url = forKey as? String ?? "" }
    func setView(forKey: Any) { self.view = forKey as? String ?? "" }
    func setWriter(forKey: Any) { self.writer = forKey as? String ?? "" }
}
class MainContentsData {
    
    var linkUrl: String = ""
    var type: String = ""
    var url: String = ""
    
    func setLinkUrl(forKey: Any) { self.linkUrl = forKey as? String ?? "" }
    func setType(forKey: Any) { self.type = forKey as? String ?? "" }
    func setUrl(forKey: Any) { self.url = forKey as? String ?? "" }
}

class CategoryData {
    
    var cateName: String = ""
    var count: Int = 0
    var imageUrl: String = ""
    var pangpangCount: Int = 0
    
    func setCateName(forKey: Any) { self.cateName = forKey as? String ?? "" }
    func setCount(forKey: Any) { self.count = forKey as? Int ?? 0 }
    func setImageUrl(forKey: Any) { self.imageUrl = forKey as? String ?? "" }
    func setPangpangCount(forKey: Any) { self.pangpangCount = forKey as? Int ?? 0 }
}

struct MemberData {
    
    var benefitPoint: String = "0"
    var code: String = ""
    var deliveryAddress: [String] = []
    var email: String = ""
    var fcmId: String = ""
    var freeDeliveryCoupon: Int = 0
    var grade: String = "1"
    var id: String = ""
    var lat: String = ""
    var legongguTopic: String = "true"
    var lon: String = ""
    var mylikeStore: [String] = []
    var name: String = ""
    var nick: String = ""
    var noticeList: [NoticeListData] = []
    var number: String = ""
    var osPlatform: String = "ios"
    var pangpangTopic: String = "true"
    var password: String = ""
    var platform: String = "lego"
    var point: String = "0"
    var profileImg: String = ""
    var signupTime: String = ""
}
class NoticeListData {
    
    var body: String = ""
    var data: String = ""
    var readOrNot: String = "false"
    var receiveTime: String = ""
    var title: String = ""
    var type: String = ""
    
    func setBody(forKey: Any) { self.body = forKey as? String ?? "" }
    func setData(forKey: Any) { self.data = forKey as? String ?? "" }
    func setReadOrNot(forKey: Any) { self.readOrNot = forKey as? String ?? "" }
    func setReceiveTime(forKey: Any) { self.receiveTime = forKey as? String ?? "" }
    func setTitle(forKey: Any) { self.title = forKey as? String ?? "" }
    func setType(forKey: Any) { self.type = forKey as? String ?? "" }
}

class MemberPangpangHistoryData {
    
    var receiveTime: String = ""
    var reviewIdx: String = ""
    var useMenu: String = ""
    var useStoreId: String = ""
    var useStoreName: String = ""
    var useTime: String = ""
    var writeReview: String = ""
    
    func setReceiveTime(forKey: Any) { self.receiveTime = forKey as? String ?? "" }
    func setReviewIdx(forKey: Any) { self.reviewIdx = forKey as? String ?? "" }
    func setUseMenu(forKey: Any) { self.useMenu = forKey as? String ?? "" }
    func setUseStoreId(forKey: Any) { self.useStoreId = forKey as? String ?? "" }
    func setUseStoreName(forKey: Any) { self.useStoreName = forKey as? String ?? "" }
    func setUseTime(forKey: Any) { self.useTime = forKey as? String ?? "" }
    func setWriteReview(forKey: Any) { self.writeReview = forKey as? String ?? "" }
}

class StoreData {
    
    var enteringTime: String = ""
    var imageArray: [String] = []
    var lat: String = ""
    var likecount: Int = 0
    var lon: String = ""
    var ownerName: String = ""
    var ownerNumber: String = ""
    var pangpangImage: String = ""
    var pangpangMenu: String = ""
    var pangpangRemain: Int = 0
    var storeAddress: String = ""
    var storeCategory: String = ""
    var storeColor: String = ""
    var storeEtc: String = ""
    var storeId: String = ""
    var storeImage: String = ""
    var storeLastOrder: String = ""
    var storeMenu: [StoreMenuData] = []
    var storeName: String = ""
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
    func setOwnerName(forKey: Any) { self.ownerName = forKey as? String ?? "" }
    func setOwnerNumber(forKey: Any) { self.ownerNumber = forKey as? String ?? "" }
    func setPangpangImage(forKey: Any) { self.pangpangImage = forKey as? String ?? "" }
    func setPangpangMenu(forKey: Any) { self.pangpangMenu = forKey as? String ?? "" }
    func setPangpangRemain(forKey: Any) { self.pangpangRemain = forKey as? Int ?? 0 }
    func setStoreAddress(forKey: Any) { self.storeAddress = forKey as? String ?? "" }
    func setStoreCategory(forKey: Any) { self.storeCategory = forKey as? String ?? "" }
    func setStoreColor(forKey: Any) { self.storeColor = forKey as? String ?? "" }
    func setStoreEtc(forKey: Any) { self.storeEtc = forKey as? String ?? "" }
    func setStoreId(forKey: Any) { self.storeId = forKey as? String ?? "" }
    func setStoreImage(forKey: Any) { self.storeImage = forKey as? String ?? "" }
    func setStoreLastOrder(forKey: Any) { self.storeLastOrder = forKey as? String ?? "" }
    func setStoreMenu(forKey: Any) { self.storeMenu = forKey as? [StoreMenuData] ?? [] }
    func setStoreName(forKey: Any) { self.storeName = forKey as? String ?? "" }
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

class LegongguData {
    
    var endTime: String = ""
    var itemBasePrice: String = ""
    var itemContent: String = ""
    var itemImage: [String] = []
    var itemMainImage: String = ""
    var itemName: String = ""
    var itemPrice: String = ""
    var itemSaleInfo: String = ""
    var remainCount: Int = 0
    var basket: [ItemArrayData] = []

    func setEndTime(forKey: Any) { self.endTime = forKey as? String ?? "" }
    func setItemBasePrice(forKey: Any) { self.itemBasePrice = forKey as? String ?? "" }
    func setItemContent(forKey: Any) { self.itemContent = forKey as? String ?? "" }
    func setItemImage(forKey: Any) { self.itemImage = forKey as? [String] ?? [] }
    func setItemMainImage(forKey: Any) { self.itemMainImage = forKey as? String ?? "" }
    func setItemName(forKey: Any) { self.itemName = forKey as? String ?? "" }
    func setItemPrice(forKey: Any) { self.itemPrice = forKey as? String ?? "" }
    func setItemSaleInfo(forKey: Any) { self.itemSaleInfo = forKey as? String ?? "" }
    func setRemainCount(forKey: Any) { self.remainCount = forKey as? Int ?? 0 }
    func setBasket(forKey: [Any]) { self.basket = forKey as? [ItemArrayData] ?? [] }
}
