//
//  StoreDetailViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/07.
//

import UIKit
import FirebaseFirestore
import ImageSlideshow
import SDWebImage
import MapKit

class StoreDetailGridCell: UICollectionViewCell {
    
    @IBOutlet weak var hashtagLabel: UILabel!
}

class StoreDetailViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var storeId: String = ""
    
    var StoreObject: [StoreData] = []
    var row: Int = 0
    
    @IBOutlet weak var headerView: UIView!
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var storeImageSlideView: ImageSlideshow!
    @IBOutlet weak var storeImagePositionLabel: UILabel!
    @IBOutlet weak var wantView: UIView!
    @IBOutlet weak var wantImageView: UIImageView!
    @IBOutlet weak var wantCountLabel: UILabel!
    @IBOutlet weak var pangpangView: UIView!
    @IBOutlet weak var pangpangStackView: UIStackView!
    @IBOutlet weak var pangpangCountLabel: UILabel!
    @IBOutlet weak var quoteLeftImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var quoteRightImageView: UIImageView!
    @IBOutlet weak var storeCategoryLabel: UILabel!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var subContentLabel: UILabel!
    @IBOutlet weak var gridView: UICollectionView!
    @IBOutlet weak var storeTelButton: UIButton!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeAddressButton: UIButton!
    @IBOutlet weak var storeOpenTimeLabel: UILabel!
    @IBOutlet weak var storeLastOrderLabel: UILabel!
    @IBOutlet weak var storeRestdayLabel: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuLabel: UILabel!
    
    @IBOutlet weak var infoOwnerNameLabel: UILabel!
    @IBOutlet weak var infoOwnerNameButton: UIButton!
    @IBOutlet weak var infoStoreNameLabel: UILabel!
    @IBOutlet weak var infoStoreNameButton: UIButton!
    @IBOutlet weak var infoStoreAddressLabel: UILabel!
    @IBOutlet weak var infoStoreTelLabel: UILabel!
    @IBOutlet weak var infoStoreRegnumLabel: UILabel!
    @IBOutlet weak var infoStoreRegnumButton: UIButton!
    @IBOutlet weak var infoStoreCategoryLabel: UILabel!
    @IBOutlet weak var infoStoreCategoryButton: UIButton!
    @IBOutlet weak var infoStoreTaxEmailStackView: UIStackView!
    @IBOutlet weak var infoStoreTaxEmailLabel: UILabel!
    @IBOutlet weak var infoStoreTaxEmailButton: UIButton!
    @IBOutlet weak var documentIdStackView: UIStackView!
    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var documentIdButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findDirectionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.StoreDetailViewControllerDelegate = self
        
        headerView.backgroundColor = .H_F4F4F4.withAlphaComponent(0.0)
        
        scrollView.delegate = self
        
        pangpangView.isHidden = true
        gridView.isHidden = true
        
        mapView.showsScale = true; mapView.isRotateEnabled = false
        if #available(iOS 13.0, *) { mapView.overrideUserInterfaceStyle = .light }
        
        if StoreObject.count > 0 {
            loadingData()
        } else {
            for data in UIViewController.appDelegate.StoreObject {
                if data.storeId == storeId { StoreObject.append(data); row = 0; loadingData(); break }
            }
        }
    }
    
    func loadingData() {
        
        let data = StoreObject[row]
        
        titleLabel.text = data.storeName
        
        storeImageSlideView.slideshowInterval = 5
        storeImageSlideView.pageIndicator = nil
        setImageSlider(imageView: storeImageSlideView, imageUrls: data.imageArray, cornerRadius: 0, contentMode: .scaleAspectFill)
        storeImageSlideView.delegate = self
        
        if data.imageArray.count > 1 {
            storeImagePositionLabel.isHidden = false
            storeImagePositionLabel.text = "1 / \(data.imageArray.count)"
        } else {
            storeImagePositionLabel.isHidden = true
            storeImagePositionLabel.text = "-"
        }
        
        var like: Bool = false
        for want in UIViewController.appDelegate.MemberObject.mylikeStore {
            if want == data.storeId { like = true }
        }
        if like { wantImageView.image = UIImage(named: "like_on") } else { wantImageView.image = UIImage(named: "like_off") }
        wantCountLabel.text = "찜 \(data.likecount)"
        wantView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(wantTap(_:))))
        
        if data.usePangpang == "true" { pangpangView.isHidden = false } else { pangpangView.isHidden = true }
        pangpangCountLabel.text = "\(data.pangpangRemain)"
        Firestore.firestore().collection("store").document(data.storeId).getDocument { response, error in
            self.StoreObject[self.row].pangpangRemain = response?.data()?["pangpang_remain"] as? Int ?? 0
            self.pangpangCountLabel.text = "\(data.pangpangRemain)"
        }
        pangpangView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pangpangCouponTap(_:))))
        
        quoteLeftImageView.image = UIImage(named: quoteLeftImages[data.storeColor] ?? "quote_left0")
        storeNameLabel.text = " \(data.storeName) "
        quoteRightImageView.image = UIImage(named: quoteRightImages[data.storeColor] ?? "quote_right0")
        storeCategoryLabel.text = data.storeCategory
        shareView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareStoreTap(_:))))
        subTitleLabel.text = data.storeSubTitle
        subContentLabel.attributedText = lineSpacing(text: data.storeEtc, lineSpacing: 5)
        storeTelButton.setTitle("📞 문의: \(setHyphen("phone", data.storeTel))", for: .normal)
        storeTelButton.addTarget(self, action: #selector(storeTelButton(_:)), for: .touchUpInside)
        storeAddressLabel.text = "📍 주소: \(data.storeAddress)"
        storeOpenTimeLabel.text = "🕰️ 영업시간: \(data.storeTime)"
        storeLastOrderLabel.text = "🕙 라스트오더: \(data.storeLastOrder)"
        storeRestdayLabel.text = "📆 휴무일: \(data.storeRestday)"
        
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//        gridView.setCollectionViewLayout(layout, animated: true, completion: nil)
//        gridView.delegate = self; gridView.dataSource = self
//
//        if data.storeTag.count > 0 { gridView.isHidden = false } else { gridView.isHidden = true }
        
        var menu: String = ""
        for data in data.storeMenu {
            if data.menuName.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567890").inverted) != nil {
                menu.append("#\(data.menuName)(\(data.menuPrice)) ")
            } else {
                menu.append("#\(data.menuName)(\(NF.string(from: (Int(data.menuPrice) ?? 0) as NSNumber) ?? "0")원) ")
            }
        }; if data.storeMenu.count > 0 { menuView.isHidden = false; menuLabel.text = menu } else { menuView.isHidden = true }
        
        infoOwnerNameLabel.text = data.ownerName
        infoStoreNameLabel.text = data.storeName
        infoStoreAddressLabel.text = data.storeAddress
        infoStoreTelLabel.text = setHyphen("phone", data.storeTel)
        infoStoreRegnumLabel.text = setHyphen("company", data.storeRegnum)
        infoStoreCategoryLabel.text = data.storeCategory
        infoStoreTaxEmailLabel.text = data.storeTaxEmail
        documentIdLabel.text = data.storeId
        
        if UIViewController.appDelegate.MemberId == "01031853309" {
            infoOwnerNameButton.isHidden = false
            infoStoreNameButton.isHidden = false
            infoStoreRegnumButton.isHidden = false
            infoStoreCategoryButton.isHidden = false
            infoStoreTaxEmailStackView.isHidden = false
            documentIdStackView.isHidden = false
        } else {
            infoOwnerNameButton.isHidden = true
            infoStoreNameButton.isHidden = true
            infoStoreRegnumButton.isHidden = true
            infoStoreCategoryButton.isHidden = true
            infoStoreTaxEmailStackView.isHidden = true
            documentIdStackView.isHidden = true
        }
        
        for (i, button) in [storeAddressButton, infoOwnerNameButton, infoStoreNameButton, infoStoreRegnumButton, infoStoreCategoryButton, infoStoreTaxEmailButton, documentIdButton].enumerated() {
            button?.tag = i; button?.addTarget(self, action: #selector(clipboardSaveButton(_:)), for: .touchUpInside)
        }
        
        mapView.removeAnnotations(mapView.annotations)
        
        if (data.lat != "") && (data.lon != "") && (data.lat != "0.0") && (data.lon != "0.0") {
            
            let annotation = MKPointAnnotation()
            annotation.title = data.storeName
            annotation.subtitle = data.storeAddress
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(data.lat) ?? 0.0, longitude: Double(data.lon) ?? 0.0)
            mapView.addAnnotation(annotation)
            
            let coordinate = CLLocationCoordinate2D(latitude: Double(data.lat) ?? 0.0, longitude: Double(data.lon) ?? 0.0)
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: false)
        }
        
        findDirectionButton.addTarget(self, action: #selector(findDirectionButton(_:)), for: .touchUpInside)
        
        Firestore.firestore().collection("store").document(data.storeId).getDocument { response, error in
            Firestore.firestore().collection("store").document(data.storeId).setData(["view_count": (response?.data()?["view_count"] as? Int ?? 0)+1], merge: true)
        }
        
        if let delegate = UIViewController.TutorialViewControllerDelegate {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { delegate.loadingData(level: 3, image: self.pangpangStackView.toImage(), y: UIApplication.shared.statusBarFrame.height+UIScreen.main.bounds.width+7.5) }
        }
    }
    
    @objc func wantTap(_ sender: UITapGestureRecognizer) {
        
        if UIViewController.appDelegate.MemberId == "" {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else {
            
            Firestore.firestore().collection("store").document(documentIdLabel.text!).getDocument { response, error in
                
                self.StoreObject[self.row].likecount = response?.data()?["like_count"] as? Int ?? 0
                    
                if self.wantImageView.image == UIImage(named: "like_off") {
                    self.StoreObject[self.row].likecount += 1
                    self.wantImageView.image = UIImage(named: "like_on")
                    self.wantCountLabel.text = "찜 \(self.StoreObject[self.row].likecount)"
                    UIViewController.appDelegate.MemberObject.mylikeStore.append(self.documentIdLabel.text!)
                } else {
                    self.StoreObject[self.row].likecount -= 1
                    self.wantImageView.image = UIImage(named: "like_off")
                    self.wantCountLabel.text = "찜 \(self.StoreObject[self.row].likecount)"
                    if let index = UIViewController.appDelegate.MemberObject.mylikeStore.firstIndex(of:  self.documentIdLabel.text!) {
                        UIViewController.appDelegate.MemberObject.mylikeStore.remove(at: index)
                    }
                }
                
                Firestore.firestore().collection("member").document(UIViewController.appDelegate.MemberId).setData(["mylike_store": UIViewController.appDelegate.MemberObject.mylikeStore], merge: true)
                Firestore.firestore().collection("store").document(self.documentIdLabel.text!).setData(["like_count": self.StoreObject[self.row].likecount], merge: true)
                
                if let refresh_1 = UIViewController.MainViewControllerDelegate {
//                    refresh_1.listView.reloadSections(IndexSet(integer: 0), with: .none)
                    refresh_1.listView.reloadData()
                }
                if let refresh_2 = UIViewController.WantViewControllerDelegate {
                    refresh_2.loadingData()
                }
            }
        }
    }
    
    @objc func pangpangCouponTap(_ sender: UITapGestureRecognizer) {
        
        if UIViewController.appDelegate.MemberId == "" {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else {
            
            Firestore.firestore().collection("store").document(self.documentIdLabel.text!).getDocument { response, error in
                
                let pangpangRemain = response?.data()?["pangpang_remain"] as? Int ?? 0
                
                if let refresh_1 = UIViewController.MainViewControllerDelegate, UIViewController.appDelegate.MemberPangpangHistoryObject.count > self.row {
                    UIViewController.appDelegate.MainPangpangStoreObject[self.row].pangpangRemain = pangpangRemain; refresh_1.listView.reloadData()
                }
                if let refresh_2 = UIViewController.StoreViewControllerDelegate {
                    UIViewController.appDelegate.StoreObject[self.row].pangpangRemain = pangpangRemain
                }
                if let refresh_3 = UIViewController.StoreDetailViewControllerDelegate {
                    refresh_3.StoreObject[refresh_3.row].pangpangRemain = pangpangRemain
                }
                
                self.pangpangCountLabel.text = "\(pangpangRemain)"
                
                if self.StoreObject[self.row].pangpangRemain == 0 {
                    self.setAlert(title: nil, body: "현재 받을 수 있는 쿠폰이 없습니다.", style: .actionSheet, time: 2)
                } else {
                    let segue = self.storyboard?.instantiateViewController(withIdentifier: "PangpangCouponViewController") as! PangpangCouponViewController
                    segue.modalPresentationStyle = .overFullScreen
                    segue.type = "download"; segue.StoreObject = self.StoreObject[self.row]
                    self.present(segue, animated: false, completion: nil)
                }
            }
        }
    }
    
    @objc func shareStoreTap(_ sender: UITapGestureRecognizer) {
        
        let data = StoreObject[row]
        
        var tag: String = ""
        for hashtag in data.storeTag { tag.append("#\(hashtag) ") }
        
        var image: String = ""
        if data.imageArray.count > 0 { image = data.imageArray[0] } else { image = UIViewController.appDelegate.AppLegoObject.logoImage }
        
        setShare(title: data.storeName, description: tag, imageUrl: image, params: "store_id=\(data.storeId)&type=store")
    }
    
    @objc func storeTelButton(_ sender: UIButton) {
        if StoreObject[row].storeTel != "", let telUrl = URL(string: "tel://\(StoreObject[row].storeTel)") {
            UIApplication.shared.open(telUrl)
        }
    }
    
    @objc func clipboardSaveButton(_ sender: UIButton) {
        S_NOTICE("클립보드에 복사됨")
        if sender.tag == 0 {
            UIPasteboard.general.string = StoreObject[row].storeAddress
        } else if sender.tag == 1 {
            UIPasteboard.general.string = StoreObject[row].ownerName
        } else if sender.tag == 2 {
            UIPasteboard.general.string = StoreObject[row].storeName
        } else if sender.tag == 3 {
            UIPasteboard.general.string = setHyphen("company", StoreObject[row].storeRegnum)
        } else if sender.tag == 4 {
            UIPasteboard.general.string = StoreObject[row].storeCategory
        } else if sender.tag == 5 {
            UIPasteboard.general.string = StoreObject[row].storeTaxEmail
        } else if sender.tag == 6 {
            UIPasteboard.general.string = StoreObject[row].storeId
        }
    }
    
    @objc func findDirectionButton(_ sender: UIButton) {
        
        let data = StoreObject[row]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "\'네이버 지도\'(으)로 길찾기", style: .default, handler: { _ in
            if let schemaUrl = URL(string: "nmap://search?query=\(data.storeAddress)&appname=A1.blink.legoyang-client".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!) {
                UIApplication.shared.open(schemaUrl, options: [:]) { success in
                    if !success {
                        if let storeUrl = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") {
                            UIApplication.shared.open(storeUrl, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "\'카카오 맵\'(으)로 길찾기", style: .default, handler: { _ in
            if let schemaUrl = URL(string: "kakaomap://search?q=\(data.storeAddress)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!) {
                UIApplication.shared.open(schemaUrl, options: [:]) { success in
                    if !success {
                        if let storeUrl = URL(string: "http://itunes.apple.com/app/id304608425?mt=8") {
                            UIApplication.shared.open(storeUrl, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
        
        UIViewController.CouponViewControllerDelegate = nil
        
        Firestore.firestore().collection("store").document(self.documentIdLabel.text!).getDocument { response, error in
            
            let pangpangRemain = response?.data()?["pangpang_remain"] as? Int ?? 0
            
            if let refresh_1 = UIViewController.MainViewControllerDelegate, UIViewController.appDelegate.MemberPangpangHistoryObject.count > self.row {
                UIViewController.appDelegate.MainPangpangStoreObject[self.row].pangpangRemain = pangpangRemain; refresh_1.listView.reloadData()
            }
            if let refresh_2 = UIViewController.StoreViewControllerDelegate {
                UIViewController.appDelegate.StoreObject[self.row].pangpangRemain = pangpangRemain
            }
            if let refresh_3 = UIViewController.StoreDetailViewControllerDelegate {
                refresh_3.StoreObject[self.row].pangpangRemain = pangpangRemain
            }
            
            self.pangpangCountLabel.text = "\(self.StoreObject[self.row].pangpangRemain)"
        }
    }
}

extension StoreDetailViewController: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        storeImagePositionLabel.text = "\(page+1) / \(StoreObject[row].imageArray.count)"
    }
}

extension StoreDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if StoreObject[row].storeTag.count > 0 { return StoreObject[row].storeTag.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreDetailGridCell_1", for: indexPath) as! StoreDetailGridCell
        
        cell.hashtagLabel.text = "#\(StoreObject[row].storeTag[indexPath.row])"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: stringWidth(text: StoreObject[row].storeTag[indexPath.row], fontSize: 12)+25, height: 25)
    }
}

extension StoreDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
}
