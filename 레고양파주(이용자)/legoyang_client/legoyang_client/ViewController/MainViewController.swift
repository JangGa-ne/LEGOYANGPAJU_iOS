//
//  MainViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/03/31.
//

import UIKit
import Gifu
import ImageSlideshow
import FirebaseFirestore

class MainViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var MediaPlayMode: Bool = false
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var eventImageView: GIFImageView!
    @IBAction func eventButton(_ sender: UIButton) {
        if MediaPlayMode {
            setAlert(title: "", body: "동영상 재생중에는 '이벤트'를 할 수 없습니다.", style: .alert, time: 2)
        } else {
            segueViewController(identifier: "EventDetail2ViewController")
        }
    }
    
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var tutorialImageView: GIFImageView!
    @IBAction func tutorialButton(_ sender: UIButton) {
        
        if MediaPlayMode {
            setAlert(title: "", body: "동영상 재생중에는 '튜토리얼'을 할 수 없습니다.", style: .alert, time: 2)
        } else if let delegate = UIViewController.TabBarControllerDelegate {
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
            segue.modalPresentationStyle = .overFullScreen
            delegate.present(segue, animated: false, completion: nil)
        }
    }
    
    @IBOutlet weak var noticeCountLabel: UILabel!
    @IBOutlet weak var noticeCountLabelWidth: NSLayoutConstraint!
    @IBAction func noticeButton(_ sender: UIButton) { segueViewController(identifier: "NoticeViewController") }
    @IBAction func settingButton(_ sender: UIButton) {
        if UIViewController.appDelegate.MemberId == "" {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else {
            segueViewController(identifier: "SettingViewController")
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchSegue: UIButton!
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.MainViewControllerDelegate = self
        
        eventView.isHidden = true
        if UIViewController.appDelegate.MemberId == "" {
            eventView.isHidden = true
            tutorialView.isHidden = true
        } else {
            eventView.isHidden = false
            eventImageView.animate(withGIFNamed: "reward")
            tutorialView.isHidden = false
            tutorialImageView.animate(withGIFNamed: "tutorial")
        }
        
        if UIViewController.appDelegate.MemberObject.nick == "" { UIViewController.appDelegate.MemberObject.nick = UIViewController.appDelegate.MemberObject.name }
        
        if UIViewController.appDelegate.noticeCount > 0 {
            noticeCountLabel.isHidden = false
            noticeCountLabel.text = "\(UIViewController.appDelegate.noticeCount)"
            noticeCountLabelWidth.constant = stringWidth(text: "\(UIViewController.appDelegate.noticeCount)", fontSize: 10)+10
        } else {
            noticeCountLabel.isHidden = true
        }
        
        searchTextField.paddingLeft(10); searchTextField.paddingRight(5)
        searchTextField.placeholder("#고양맛집 #파주맛집 #감성카페 ...", COLOR: .lightGray)
        
        searchSegue.addTarget(self, action: #selector(searchSegue(_:)), for: .touchUpInside)
        
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        listView.delegate = self; listView.dataSource = self
        
        refreshControl.backgroundColor = .clear; refreshControl.tintColor = .H_00529C
        refreshControl.addTarget(self, action: #selector(refreshControl(_:)), for: .valueChanged)
        listView.refreshControl = refreshControl
        
        loadingData()
        
// 7.20 ~ 7.22 레고팡팡 리뷰까지 쓴사람 리스트
        Firestore.firestore().collection("member_pangpang_history").getDocuments { responses, error in
            
            guard let responses = responses else { return }
            
            for response in responses.documents {
                
                let _: [()]? = response.data().compactMap({ (key: String, value: Any) in
                    
                    let dict = response.data()[key] as? [String: Any] ?? [:]
                    let useTime = Int(dict["use_time"] as? String ?? "0") ?? 0
                    let writeReview = dict["write_review"] as? String ?? "false"
                    let useStoreName = dict["use_store_name"] as? String ?? ""
                    let useStoreId = dict["use_store_id"] as? String ?? ""
                    
                    let time = self.FM_TIMESTAMP(useTime, "yy-MM-dd HH:mm:ss")
                    
                    if (useStoreName != "튜토리얼 매장") && (useTime != 0) && (useTime > 1689811200000) && (useTime < 1690070400000) {
                        
                        Firestore.firestore().collection("member").whereField("number", isEqualTo: response.documentID).getDocuments { responses, error in
                            
                            guard let responses = responses else { return }
                            
                            for response in responses.documents {
                                if useStoreId == "01000001000" {
                                    print(self.setHyphen("phone", response.data()["number"] as? String ?? ""), response.data()["name"] as? String ?? "", response.data()["nick"] as? String ?? "", time)
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    
    func loadingData() {
        
        if (UIViewController.appDelegate.MemberId != "") && !UserDefaults.standard.bool(forKey: "tutorial") {
            
            DispatchQueue.main.async {
                let segue = self.storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
                segue.modalPresentationStyle = .overFullScreen
                segue.type = "tutorial_start"
                self.present(segue, animated: false) { UserDefaults.standard.setValue(true, forKey: "tutorial") }
            }
            
        } else if UserDefaults.standard.integer(forKey: "today_hidden_time") < setKoreaTimestamp() {
            
            DispatchQueue.main.async {
                let segue = self.storyboard?.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
                segue.modalPresentationStyle = .overFullScreen
                self.present(segue, animated: false, completion: nil)
            }
        }
    }
    
    @objc func refreshControl(_ sender: UIRefreshControl) {
        if let refresh = UIViewController.LoadingViewControllerDelegate {
            refresh.loadingData(mainUpdate: true)
        }
    }
    
    @objc func searchSegue(_ sender: UIButton) {
        segueViewController(identifier: "SearchViewController", animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
        
        UIViewController.PopupViewControllerDelegate = nil
        UIViewController.SearchViewControllerDelegate = nil
        UIViewController.StoreViewControllerDelegate = nil
        UIViewController.EventDetailViewControllerDelegate = nil
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let memeberData = UIViewController.appDelegate.MemberObject
            let memberPangpangHistoryData = UIViewController.appDelegate.MemberPangpangHistoryObject
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainListCell_1", for: indexPath) as! MainListCell
            cell.delegate = self
            
            for (i, view) in [cell.pangpangView, cell.explainPangpangView, cell.explainReviewView, cell.loginView, cell.couponView, cell.wantView, cell.reviewView].enumerated() {
                view?.tag = i; view?.addGestureRecognizer(UITapGestureRecognizer(target: cell, action: #selector(cell.segueButton(_:))))
            }
            
            cell.imageSliderView.slideshowInterval = 10
            cell.imageSliderView.pageIndicator = cell.imageSliderPageControl
            cell.imageSliderView.setImageInputs([ImageSource(image: UIImage(named: "mainImage0")!)])
            
            var coupons: Int = 0
            var review: Bool = true
            for data in memberPangpangHistoryData {
                if (data.useTime == "0") && (data.useStoreId != "01099999999") {
                    coupons += 1
                } else if (data.writeReview == "false") && (data.useStoreId != "01099999999") {
                    review = false
                }
            }
            
            if UIViewController.appDelegate.MemberId == "" {
                cell.loginView.isHidden = false; cell.couponWantView.isHidden = true; cell.reviewView.isHidden = true
            } else {
                cell.loginView.isHidden = true; cell.couponWantView.isHidden = false; cell.reviewView.isHidden = review
            }
            
            cell.couponLabel.text = "\(coupons)매"; cell.wantLabel.text = "\(memeberData.mylikeStore.count)매"
            
            return cell
            
        } else if (indexPath.row == 1) || (indexPath.row == 2) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainListCell_2", for: indexPath) as! MainListCell
            cell.delegate = self; cell.row = indexPath.row
            
            cell.mainTitleLabel.text = ["", "오늘의 레고팡팡", "진행중인 레공구"][indexPath.row]
            cell.subTitleLabel.text = ["", "레고팡팡 매장을 확인해 보세요!", "팡팡하게 할인받는 레공구"][indexPath.row]
            cell.moreButton.tag = indexPath.row; cell.moreButton.addTarget(self, action: #selector(moreButton(_:)), for: .touchUpInside)
            
            cell.viewDidLoad()
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func moreButton(_ sender: UIButton) {
        
        guard let delegate = UIViewController.TabBarControllerDelegate else { return }
        
        if sender.tag == 1 {
                
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
            segue.detail = true
            delegate.navigationController?.pushViewController(segue, animated: true)
            
        } else if sender.tag == 2 {
            
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "LegongguViewController") as! LegongguViewController
            segue.detail = true
            delegate.navigationController?.pushViewController(segue, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        } else if indexPath.row == 1 {
            return 240
        } else if indexPath.row == 2 {
            return 255
        } else {
            return 0
        }
    }
}




////
////  MainViewController.swift
////  legoyang_client
////
////  Created by Busan Dynamic on 2023/03/31.
////
//
//import UIKit
//import ImageSlideshow
//
//class MainGridCell: UICollectionViewCell {
//
//    @IBOutlet weak var itemImageView: UIImageView!
//    @IBOutlet weak var countLabel: UILabel!
//    @IBOutlet weak var mainTitleLabel: UILabel!
//    @IBOutlet weak var subTitleLabel: UILabel!
//}
//
//class MainListCell: UITableViewCell {
//
//    var delegate: MainViewController!
//
//    @IBOutlet weak var imageSliderView: ImageSlideshow!
//    @IBOutlet weak var imageSliderPageControl: UIPageControl!
//
//    @IBOutlet weak var pangpangView: UIView!
//    @IBOutlet weak var explainPangpangView: UIView!
//    @IBOutlet weak var loginView: UIView!
//    @IBOutlet weak var couponWantView: UIView!
//    @IBOutlet weak var couponView: UIView!
//    @IBOutlet weak var couponLabel: UILabel!
//    @IBOutlet weak var wantView: UIView!
//    @IBOutlet weak var wantLabel: UILabel!
//    @IBOutlet weak var reviewView: UIView!
//
//    @IBOutlet weak var mainTitleLabel: UILabel!
//    @IBOutlet weak var subTitleLabel: UILabel!
//    @IBOutlet weak var moreButton: UIButton!
//    @IBOutlet weak var gridBackgroundView: UIView!
//    @IBOutlet weak var gridView: UICollectionView!
//    @IBOutlet weak var gridViewHeight: NSLayoutConstraint!
//
//    func viewDidLoad() {
//
//        gridView.delegate = nil; gridView.dataSource = nil
//
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//        gridView.setCollectionViewLayout(layout, animated: true, completion: nil)
//        gridView.delegate = self; gridView.dataSource = self
//    }
//
//    @objc func segueButton(_ sender: UITapGestureRecognizer) {
//
//        guard let sender = sender.view else { return }
//
//        if sender.tag == 0 {
//
//            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
//            segue.detail = true
//            delegate.navigationController?.pushViewController(segue, animated: true)
//
//        } else if sender.tag == 1 {
//
//            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "SafariViewController") as! SafariViewController
//            segue.titleName = "레고팡팡 쿠폰 사용방법"; segue.linkUrl = "https://blinkcorpad.creatorlink.net/mcp"
//            delegate.navigationController?.pushViewController(segue, animated: true)
//
//        } else if sender.tag == 2 {
//            delegate.segueViewController(identifier: "LoginAAViewController")
//        } else if sender.tag == 3 {
//            delegate.segueViewController(identifier: "CouponViewController")
//        } else if sender.tag == 4 {
//            delegate.segueViewController(identifier: "WantViewController")
//        } else if sender.tag == 5 {
//
//            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "CouponViewController") as! CouponViewController
//            segue.position = 1
//            delegate.navigationController?.pushViewController(segue, animated: true)
//
//        }
//    }
//}
//
//extension MainListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if UIViewController.appDelegate.MainPangpangStoreObject.count > 0 { return UIViewController.appDelegate.MainPangpangStoreObject.count } else { return 0 }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let data = UIViewController.appDelegate.MainPangpangStoreObject[indexPath.row]
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGridCell_1", for: indexPath) as! MainGridCell
//
//        if data.pangpangImage != "" {
//            delegate.setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.pangpangImage, cornerRadius: 10, contentMode: .scaleAspectFill)
//        } else if data.storeImage != "" {
//            delegate.setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.storeImage, cornerRadius: 10, contentMode: .scaleAspectFill)
//        } else if data.imageArray.count > 0 {
//            delegate.setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.imageArray[0], cornerRadius: 10, contentMode: .scaleAspectFill)
//        } else {
//            cell.itemImageView.image = UIImage(named: "logo2")
//        }
//        cell.countLabel.text = "\(data.pangpangRemain)"
//        cell.mainTitleLabel.text = data.storeName
//        cell.subTitleLabel.text = "\(data.pangpangMenu) 무료쿠폰"
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if UIViewController.appDelegate.MemberId == "" {
//            delegate.S_NOTICE("로그인 (!)"); delegate.segueViewController(identifier: "LoginAAViewController")
//        } else {
//            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
//            segue.StoreObject = UIViewController.appDelegate.MainPangpangStoreObject; segue.row = indexPath.row
//            delegate.navigationController?.pushViewController(segue, animated: true)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        gridViewHeight.constant = 165; return CGSize(width: 120, height: 165)
//    }
//}
//
//class MainViewController: UIViewController {
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//
//    var refreshControl = UIRefreshControl()
//
//    @IBAction func noticeButton(_ sender: UIButton) { segueViewController(identifier: "NoticeViewController") }
//    @IBAction func settingButton(_ sender: UIButton) { segueViewController(identifier: "SettingViewController") }
//    @IBOutlet weak var searchTextField: UITextField!
//    @IBOutlet weak var searchButton: UIButton!
//    @IBOutlet weak var searchSegue: UIButton!
//    @IBOutlet weak var listView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        UIViewController.MainViewControllerDelegate = self
//
//        if UIViewController.appDelegate.MemberObject.nick == "" { UIViewController.appDelegate.MemberObject.nick = UIViewController.appDelegate.MemberObject.name }
//
//        searchTextField.paddingLeft(10); searchTextField.paddingRight(5)
//        searchTextField.placeholder("#고양맛집 #파주맛집 #감성카페 ...", COLOR: .lightGray)
//
//        searchSegue.addTarget(self, action: #selector(searchSegue(_:)), for: .touchUpInside)
//
//        listView.separatorStyle = .none
//        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
//        listView.delegate = self; listView.dataSource = self
//
//        refreshControl.backgroundColor = .clear; refreshControl.tintColor = .H_00529C
//        refreshControl.addTarget(self, action: #selector(refreshControl(_:)), for: .valueChanged)
//        listView.refreshControl = refreshControl
//
//        if UserDefaults.standard.integer(forKey: "today_hidden_time") < setKoreaTimestamp() {
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
//                let segue = self.storyboard?.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
//                segue.modalPresentationStyle = .overFullScreen
//                self.present(segue, animated: false, completion: nil)
//            }
//        }
//    }
//
//    @objc func refreshControl(_ sender: UIRefreshControl) {
//        if let refresh = UIViewController.LoadingViewControllerDelegate {
//            refresh.loadingData(update: true)
//        }
//    }
//
//    @objc func searchSegue(_ sender: UIButton) {
//        segueViewController(identifier: "SearchViewController", animated: false)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        setBackSwipeGesture(false)
//    }
//}
//
//extension MainViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        } else if section == 1 {
//            return 2
//        } else if section == 2 {
//            if UIViewController.appDelegate.MainLegongguObject.count > 0 { return UIViewController.appDelegate.MainLegongguObject.count } else { return 0 }
//        } else {
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.section == 0 {
//
//            let memeberData = UIViewController.appDelegate.MemberObject
//            let memberPangpangHistoryData = UIViewController.appDelegate.MemberPangpangHistoryObject
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MainListCell_1", for: indexPath) as! MainListCell
//            cell.delegate = self
//
//            for (i, view) in [cell.pangpangView, cell.explainPangpangView, cell.loginView, cell.couponView, cell.wantView, cell.reviewView].enumerated() {
//                view?.tag = i; view?.addGestureRecognizer(UITapGestureRecognizer(target: cell, action: #selector(cell.segueButton(_:))))
//            }
//
//            cell.imageSliderView.slideshowInterval = 10
//            cell.imageSliderView.pageIndicator = cell.imageSliderPageControl
//            cell.imageSliderView.setImageInputs([ImageSource(image: UIImage(named: "mainImage0")!)])
//
//            var coupons: Int = 0
//            var review: Bool = true
//            for data in memberPangpangHistoryData {
//                if data.useTime == "0" {
//                    coupons += 1
//                } else if data.writeReview == "false" {
//                    review = false
//                }
//            }
//
//            if UIViewController.appDelegate.MemberId != "" {
//                cell.loginView.isHidden = true; cell.couponWantView.isHidden = false; cell.reviewView.isHidden = review
//            } else {
//                cell.loginView.isHidden = false; cell.couponWantView.isHidden = true; cell.reviewView.isHidden = true
//            }
//
//            cell.couponLabel.text = "\(coupons)매"; cell.wantLabel.text = "\(memeberData.mylikeStore.count)매"
//
//            return cell
//
//        } else if indexPath.section == 1 {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MainListCell_2", for: indexPath) as! MainListCell
//            cell.delegate = self
//
//            cell.mainTitleLabel.text = ["오늘의 레고팡팡", "진행중인 레공구"][indexPath.row]
//            cell.subTitleLabel.text = ["레고팡팡 매장을 확인해 보세요!", "팡팡하게 할인받는 레공구"][indexPath.row]
//            cell.moreButton.tag = indexPath.row; cell.moreButton.addTarget(self, action: #selector(moreButton(_:)), for: .touchUpInside)
//
//            if indexPath.row == 0 {
//                cell.gridBackgroundView.isHidden = false
//                cell.viewDidLoad()
//            } else if indexPath.row == 1 {
//                cell.gridBackgroundView.isHidden = true
//            }
//
//            return cell
//
//        } else if indexPath.section == 2 {
//
//            let data = UIViewController.appDelegate.MainLegongguObject[indexPath.row]
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MainListCell_3", for: indexPath) as! MainListCell
//            cell.delegate = self
//
//
//            return cell
//
//        } else {
//            return UITableViewCell()
//        }
//    }
//
//    @objc func moreButton(_ sender: UIButton) {
//
//        guard let delegate = UIViewController.TabBarControllerDelegate else { return }
//
//        if sender.tag == 1 {
//
//            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
//            segue.detail = true
//            delegate.navigationController?.pushViewController(segue, animated: true)
//
//        } else if sender.tag == 2 {
//
//            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "LegongguViewController") as! LegongguViewController
//            segue.detail = true
//            delegate.navigationController?.pushViewController(segue, animated: true)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (indexPath.section == 1) && (indexPath.row == 0) {
//            return 230
//        } else {
//            return UITableView.automaticDimension
//        }
//    }
//}
