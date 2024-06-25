//
//  CouponViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/11.
//

import UIKit
import FirebaseFirestore

class CouponListCell: UITableViewCell {
    
    var delegate: CouponViewController!
    
    var MemberPangpangHistoryObject: [MemberPangpangHistoryData] = []
    var row: Int = 0
    
    @IBOutlet weak var receiveTimeLabel: UILabel!
    @IBOutlet weak var couponButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var quoteLeftImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var quoteRightImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var pangpangView: UIView!
    @IBOutlet weak var pangpangImageView: UIImageView!
    @IBOutlet weak var pangpangMenuLabel: UILabel!
    @IBOutlet weak var pangpangReviewStackView: UIStackView!
    @IBOutlet weak var pangpangReviewTextField: UITextField!
    @IBOutlet weak var reviewUploadButton: UIButton!
    
    @IBOutlet weak var shareView_1: UIView!
    @IBOutlet weak var shareButton_1: UIButton!
    @IBOutlet weak var shareView_2: UIView!
    @IBOutlet weak var shareButton_2: UIButton!
    
    @objc func pangpangReviewTextField(_ sender: UITextField) {
        if sender.text!.rangeOfCharacter(from: CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`~!@#$%^&*()_+[]{};:,.<>/?\'\"| 1234567890").inverted) != nil { sender.text = "" }
    }
    
    @objc func reviewUploadButton(_ sender: UIButton) {
        
        delegate.view.endEditing(true)
        
        if pangpangReviewTextField.text == "" { delegate.S_NOTICE("후기 Link (!)"); return }
        
        var writeReview: Bool = false
        var reviewLinkUrl: String = ""
        if reviewUploadButton.titleLabel?.text == "등록하기" { writeReview = true; reviewLinkUrl = pangpangReviewTextField.text! }
        
        let params: [String: Any] = [
            "\(MemberPangpangHistoryObject[row].receiveTime)": [
                "review_idx": pangpangReviewTextField.text!,
                "write_review": "true"
            ]
        ]
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("member_pangpang_history").document(UIViewController.appDelegate.MemberId).setData(params, merge: true) { _ in
                DispatchGroup.leave()
            }
        }
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("pangpang_history").document(self.MemberPangpangHistoryObject[self.row].useStoreId).setData(params, merge: true) { _ in
                self.delegate.S_NOTICE("후기 등록됨"); DispatchGroup.leave()
            }
        }
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("event").document("event_reward").getDocument { response, error in
                if response?.data()?["proceeding"] as? String ?? "" == "true" { DispatchGroup.leave() } else { return }
            }
        }
        
        var inviterFrom: String = ""
        let timestamp = "\(self.delegate.setKoreaTimestamp()+32400000)"

        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            let ref = Firestore.firestore().collection("event_reward").document(UIViewController.appDelegate.MemberId)
            
            ref.getDocument { response, error in
                
                if !(response?.exists ?? false) { return }
                
                inviterFrom = response?.data()?["inviter_from"] as? String ?? ""
                let writeCount = response?.data()?["write_count"] as? Int ?? 0
                var reviewUrl = response?.data()?["review_url"] as? [String] ?? []
                reviewUrl.append(reviewLinkUrl)
                
                if !writeReview || (writeCount == 2) { return }
                
                ref.updateData(["write_count": writeCount+1, "review_url": reviewUrl]) { _ in
                    if writeCount == 1 {
                        ref.updateData(["progress_step": "1", "finish_time": timestamp]) { _ in DispatchGroup.leave() }
                    } else {
                        DispatchGroup.leave()
                    }
                }
            }
        }
        
        DispatchGroup.notify(queue: .main) {

            let firestore = Firestore.firestore()
            let ref = firestore.collection("event_reward").document(inviterFrom)

            firestore.runTransaction { transaction, error in

                let response = try! transaction.getDocument(ref)

                guard var inviteTo = response.data()?["invite_to"] as? [[String: Any]] else { return }

                for (i, dict) in inviteTo.enumerated() {

                    if dict["invitee_id"] as? String ?? "" == UIViewController.appDelegate.MemberId {

                        var updatedDict = dict
                        updatedDict["write_count"] = (updatedDict["write_count"] as? Int ?? 0)+1
                        if dict["write_count"] as? Int ?? 0 == 1 {
                            updatedDict["progress_step"] = "1"
                            updatedDict["finish_time"] = timestamp
                        }
                        
                        inviteTo[i] = updatedDict

                        break
                    }
                }

                transaction.updateData(["invite_to": inviteTo], forDocument: ref)
                
                return nil

            } completion: { result, error in
                if error == nil {
                    print("성공")
                } else {
                    print("실패: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
}

class CouponViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var tutorial: Bool = false
    var position: Int = 0
    
    var FilterObject: [String] = ["쿠폰 사용하기", "후기 작성하기"]
    var MemberPangpangHistoryObject: [MemberPangpangHistoryData] = []
    var StoreObject: [StoreData] = []
    var storeNames: [String] = []
    
    @IBAction func backButton(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true) {
            
            if !self.tutorial { return }
            
            if let delegate_1 = UIViewController.StoreDetailViewControllerDelegate {
                delegate_1.navigationController?.popViewController(animated: false)
            }
            if let delegate_2 = UIViewController.StoreViewControllerDelegate {
                delegate_2.navigationController?.popViewController(animated: false)
            }
            if let delegate_3 = UIViewController.TabBarControllerDelegate {
                delegate_3.selectedIndex = 4
            }
        }
    }
    
    @IBOutlet weak var explainReviewView: UIView!
    @IBOutlet weak var gridView: UICollectionView!
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboard()
        
        UIViewController.CouponViewControllerDelegate = self
        
        explainReviewView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(explainReviewView(_:))))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        gridView.setCollectionViewLayout(layout, animated: true, completion: nil)
        gridView.delegate = self; gridView.dataSource = self
        
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        listView.delegate = self; listView.dataSource = self
        
        loadingData()
    }
    
    func loadingData() {
        
        storeNames.removeAll(); MemberPangpangHistoryObject.removeAll()
        
        for data in UIViewController.appDelegate.MemberPangpangHistoryObject {
            if (position == 0) && (data.useTime == "0") {
                self.MemberPangpangHistoryObject.append(data)
            } else if (position == 1) && (data.useTime != "0") {
                self.MemberPangpangHistoryObject.append(data)
            }
        }; MemberPangpangHistoryObject.sort { front, behind in front.receiveTime > behind.receiveTime }
        
        gridView.reloadData(); listView.reloadData(); listView.contentOffset = CGPoint(x: 0, y: -10)
    }
    
    @objc func explainReviewView(_ sender: UITapGestureRecognizer) {
        setPipMediaPlayer(linkUrl: "https://dl.dropboxusercontent.com/s/56dgqm8dr57ccso/review_guide.mp4", width: 40*5, height: 50*5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension CouponViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if FilterObject.count > 0 { return FilterObject.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NaviBarGridCell_1", for: indexPath) as! NaviBarGridCell
        
        if indexPath.row == position {
            cell.mainTitleLabel.layer.borderColor = UIColor.H_FF6F00.cgColor
            cell.mainTitleLabel.textColor = .H_FF6F00
            cell.mainTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        } else {
            cell.mainTitleLabel.layer.borderColor = UIColor.darkGray.cgColor
            cell.mainTitleLabel.textColor = .black
            cell.mainTitleLabel.font = UIFont.systemFont(ofSize: 14)
        }
        cell.mainTitleLabel.layer.borderWidth = 0.5
        cell.mainTitleLabel.text = FilterObject[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true); position = indexPath.row; loadingData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: stringWidth(text: FilterObject[indexPath.row], fontSize: 14)+40, height: 40)
    }
}

extension CouponViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MemberPangpangHistoryObject.count > 0 { return MemberPangpangHistoryObject.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = MemberPangpangHistoryObject[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponListCell_1", for: indexPath) as! CouponListCell
        cell.delegate = self; cell.MemberPangpangHistoryObject = MemberPangpangHistoryObject; cell.row = indexPath.row
        
        cell.receiveTimeLabel.text = FM_TIMESTAMP(Int(data.receiveTime) ?? 0, "yy.MM.dd E HH:mm:ss")
        if position == 0 {
            cell.couponButton.isHidden = false
            cell.reviewButton.isHidden = true
            cell.shareView_1.isHidden = false
            cell.shareView_2.isHidden = true
        } else if position == 1 {
            cell.couponButton.isHidden = true
            cell.reviewButton.isHidden = false
            cell.shareView_1.isHidden = true
            cell.shareView_2.isHidden = false
        }
        
        cell.pangpangView.isHidden = false
        
        cell.couponButton.tag = indexPath.row; cell.couponButton.addTarget(self, action: #selector(couponButton(_:)), for: .touchUpInside)
        cell.reviewButton.tag = indexPath.row; cell.reviewButton.addTarget(self, action: #selector(reviewButton(_:)), for: .touchUpInside)
        
        for (i, storeData) in UIViewController.appDelegate.StoreObject.enumerated() {
            
            if data.useStoreId == storeData.storeId {
                
                StoreObject.append(storeData)
                
                if storeData.storeImage != "" {
                    setImageNuke(imageView: cell.storeImageView, placeholder: UIImage(named: "logo2"), imageUrl: storeData.storeImage, cornerRadius: 10, contentMode: .scaleAspectFill)
                } else if storeData.imageArray.count > 0 {
                    setImageNuke(imageView: cell.storeImageView, placeholder: UIImage(named: "logo2"), imageUrl: storeData.imageArray[0], cornerRadius: 10, contentMode: .scaleAspectFill)
                } else {
                    cell.storeImageView.image = UIImage(named: "logo2")
                }
                
                cell.quoteLeftImageView.image = UIImage(named: quoteLeftImages[storeData.storeColor] ?? "quote_left0")
                cell.storeNameLabel.text = " \(storeData.storeName) "
                cell.quoteRightImageView.image = UIImage(named: quoteRightImages[storeData.storeColor] ?? "quote_right0")
                cell.mainTitleLabel.text = storeData.storeSubTitle
                cell.subTitleLabel.text = storeData.storeEtc
                
                if storeData.pangpangImage != "" {
                    setImageNuke(imageView: cell.pangpangImageView, placeholder: UIImage(named: "logo3"), imageUrl: storeData.pangpangImage, cornerRadius: 5, contentMode: .scaleAspectFill)
                } else {
                    cell.pangpangImageView.image = UIImage(named: "logo3")
                }
                cell.pangpangMenuLabel.text = "\(storeData.pangpangMenu) 무료쿠폰"
                if position == 0 {
                    
                    cell.pangpangReviewStackView.layer.borderWidth = 0
                    cell.pangpangReviewStackView.layer.borderColor = UIColor.clear.cgColor
                    cell.pangpangReviewTextField.paddingLeft(0)
                    cell.pangpangReviewTextField.paddingRight(0)
                    cell.pangpangReviewTextField.placeholder("사용 가능한 기간: 금일 23:59:59까지", COLOR: .darkGray)
                    cell.pangpangReviewTextField.isEnabled = false
                    cell.pangpangReviewTextField.text?.removeAll()
                    cell.reviewUploadButton.isHidden = true
                    
                } else if position == 1 {
                    
                    cell.pangpangReviewStackView.layer.borderWidth = 1
                    cell.pangpangReviewStackView.layer.borderColor = UIColor.H_FF6F00.cgColor
                    cell.pangpangReviewTextField.paddingLeft(10)
                    cell.pangpangReviewTextField.paddingRight(10)
                    cell.pangpangReviewTextField.isEnabled = true
                    cell.pangpangReviewTextField.addTarget(cell, action: #selector(cell.pangpangReviewTextField(_:)), for: .editingChanged)
                    cell.reviewUploadButton.isHidden = false
                    
                    if data.writeReview != "true" {
                        cell.reviewButton.isHidden = false
                        cell.pangpangReviewTextField.placeholder("작성한 후기의 Link를 넣어주세요.", COLOR: .lightGray)
                        cell.pangpangReviewTextField.text?.removeAll()
                        cell.reviewUploadButton.setTitle("등록하기", for: .normal)
                    } else {
                        cell.reviewButton.isHidden = true
                        cell.pangpangReviewTextField.placeholder("", COLOR: .lightGray)
                        cell.pangpangReviewTextField.text = data.reviewIdx
                        cell.reviewUploadButton.setTitle("수정하기", for: .normal)
                    }
                }
                cell.reviewUploadButton.addTarget(cell, action: #selector(cell.reviewUploadButton(_:)), for: .touchUpInside)
                
                cell.shareButton_1.tag = i; cell.shareButton_1.addTarget(self, action: #selector(shareStoreButton(_:)), for: .touchUpInside)
                cell.shareButton_2.tag = i; cell.shareButton_2.addTarget(self, action: #selector(shareStoreButton(_:)), for: .touchUpInside)
                
                break
            }
        }
        
        if indexPath.row == 0, let delegate = UIViewController.TutorialViewControllerDelegate {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { delegate.loadingData(level: 6, image: cell.toImage(), imageHeight: cell.bounds.height) }
        } else if data.useStoreId == "01099999999" {
            
            cell.shareView_2.isHidden = true
            cell.reviewButton.isHidden = true
            
            if position == 0 {
                
                let params: [String: Any] = [
                    "\(data.receiveTime)": [
                        "receive_time": data.receiveTime,
                        "review_idx": "",
                        "use_menu": data.useMenu,
                        "use_time": "\(setKoreaTimestamp())",
                        "use_store_id": data.useStoreId,
                        "use_store_name": data.useStoreName,
                        "write_review": "true"
                    ]
                ]
                
                Firestore.firestore().collection("member_pangpang_history").document(UIViewController.appDelegate.MemberId).updateData(params)
                
            } else if position == 1 {
                cell.pangpangView.isHidden = true
            }
        }
        
        return cell
    }
    
    @objc func couponButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        var review: Bool = true
        
        for data in UIViewController.appDelegate.MemberPangpangHistoryObject {
            if (data.useTime != "0") && (data.writeReview == "false") && (data.useStoreId != "01099999999") { review = false; break }
        }
        
        if review || (UIViewController.appDelegate.MemberId == "01034231219") || (UIViewController.appDelegate.MemberId == "01031853309") || (MemberPangpangHistoryObject[sender.tag].useStoreId == "01099999999") {
            
//            let segue = storyboard?.instantiateViewController(withIdentifier: "PangpangCouponViewController") as! PangpangCouponViewController
//            segue.modalPresentationStyle = .overFullScreen
//            segue.type = "password"
//            segue.StoreObject = StoreObject[sender.tag]; segue.MemberPangpangHistoryObject = MemberPangpangHistoryObject[sender.tag]
//            present(segue, animated: false, completion: nil)
            
            let segue = storyboard?.instantiateViewController(withIdentifier: "CouponPasswordViewController") as! CouponPasswordViewController
            segue.StoreObject = StoreObject[sender.tag]; segue.row = sender.tag; segue.MemberPangpangHistoryObject = MemberPangpangHistoryObject[sender.tag]
            navigationController?.pushViewController(segue, animated: true)
            
        } else {
            
            let segue = storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
            segue.modalPresentationStyle = .overFullScreen
            segue.type = "coupon_review2"
            present(segue, animated: false, completion: nil)
        }
    }
    
    @objc func reviewButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        let segue = storyboard?.instantiateViewController(withIdentifier: "SafariViewController") as! SafariViewController
        segue.titleName = "후기 작성하기"; segue.linkUrl = "https://m.cafe.naver.com/ca-fe/web/cafes/20237461/menus/90/articles/write"; segue.storeName = StoreObject[sender.tag].storeName
        navigationController?.pushViewController(segue, animated: true)
    }
    
    @objc func shareStoreButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        let data = UIViewController.appDelegate.StoreObject[sender.tag]
        
        var tag: String = ""
        for hashtag in data.storeTag { tag.append("#\(hashtag) ") }
        
        var image: String = ""
        if data.imageArray.count > 0 { image = data.imageArray[0] } else { image = UIViewController.appDelegate.AppLegoObject.logoImage }
        
        setShare(title: data.storeName, description: tag, imageUrl: image, params: "store_id=\(data.storeId)&type=store")
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        view.endEditing(true)
//
//        if position == 0 {
//
//            var review: Bool = true
//
//            for data in UIViewController.appDelegate.MemberPangpangHistoryObject {
//                if (data.useTime != "0") && (data.writeReview == "false") { review = false; break }
//            }
//
//            if review || (UIViewController.appDelegate.MemberId == "01034231219") || (UIViewController.appDelegate.MemberId == "01031853309") {
//
//                let segue = storyboard?.instantiateViewController(withIdentifier: "PangpangCouponViewController") as! PangpangCouponViewController
//                segue.modalPresentationStyle = .overFullScreen
//                segue.type = "qrcode"; segue.storeName = storeNames[indexPath.row]; segue.MemberPangpangHistoryObject = MemberPangpangHistoryObject[indexPath.row]
//                present(segue, animated: false, completion: nil)
//
//            } else {
//
//                let segue = storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
//                segue.modalPresentationStyle = .overFullScreen
//                segue.type = "coupon_review2"
//                present(segue, animated: false, completion: nil)
//            }
//        }
//    }
}
