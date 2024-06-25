//
//  LegongguDetailViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/10.
//

import UIKit
import ImageSlideshow
import FirebaseFirestore
import PanModal

class LegongguDetailViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var itemName: String = ""
    
    var LegongguObject: [LegongguData] = []
    var row: Int = 0
    
    var LegongguOptionObject: [LegongguOptionData] = []
    
    @IBOutlet weak var headerView: UIView!
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itemImageSlideView: ImageSlideshow!
    @IBOutlet weak var itemImagePositionLabel: UILabel!
    @IBOutlet weak var closeTimeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var subContentLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemBasePriceLabel: UILabel!
    @IBOutlet weak var itemSaleInfoImageView: UIImageView!
    @IBOutlet weak var itemSaleInfoLabel: UILabel!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var segueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.LegongguDetailViewControllerDelegate = self
        
        headerView.backgroundColor = .H_F4F4F4.withAlphaComponent(0.0)
        
        if LegongguObject.count > 0 {
            loadingData()
        } else {
            for data in UIViewController.appDelegate.LegongguObject {
                if data.itemName == itemName { LegongguObject.append(data); row = 0; loadingData(); break }
            }
        }
    }
    
    func loadingData() {
        
        let data = LegongguObject[row]
        
        var timestamp: Int = (Int(data.endTime) ?? 0) - (self.setKoreaTimestamp()/1000)
        closeTimeLabel.text = FM_TIMER(TIMESTAMP: timestamp)
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timestamp = timestamp-1; self.closeTimeLabel.text = self.FM_TIMER(TIMESTAMP: timestamp)
        }
        if closeTimeLabel.text == "마감" { timer.invalidate() }
        countLabel.text = "\(data.remainCount)"
        
        itemImageSlideView.slideshowInterval = 5
        itemImageSlideView.pageIndicator = nil
        setImageSlider(imageView: itemImageSlideView, imageUrls: data.itemImage, cornerRadius: 0, contentMode: .scaleAspectFill)
        itemImageSlideView.delegate = self
        
        if data.itemImage.count > 1 {
            itemImagePositionLabel.isHidden = false
            itemImagePositionLabel.text = "1 / \(data.itemImage.count)"
        } else {
            itemImagePositionLabel.isHidden = true
            itemImagePositionLabel.text = "-"
        }
        
        Firestore.firestore().collection("legonggu_item").document(data.itemName).getDocument { response, error in
            self.LegongguObject[self.row].remainCount = response?.data()?["remain_count"] as? Int ?? 0
            self.countLabel.text = "\(data.remainCount)"
        }
        
        subTitleLabel.text = data.itemName
        subContentLabel.text = data.itemContent
        itemPriceLabel.text = data.itemPrice
        itemBasePriceLabel.text = "\(NF.string(from: (Int(data.itemBasePrice) ?? 0) as NSNumber) ?? "0")원"
        if data.itemSaleInfo.contains("적립") { itemSaleInfoImageView.isHidden = false } else { itemSaleInfoImageView.isHidden = true }
        itemSaleInfoLabel.text = data.itemSaleInfo
        
        shareView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareGongguTap(_:))))
        
        loadingData2()
        
        segueButton.addTarget(self, action: #selector(segueButton(_:)), for: .touchUpInside)
    }
    
    @objc func shareGongguTap(_ sender: UITapGestureRecognizer) {
        
        let data = LegongguObject[row]
        
        var image: String = ""
        if data.itemImage.count > 0 { image = data.itemImage[0] } else { image = UIViewController.appDelegate.AppLegoObject.logoImage }
        
        setShare(title: data.itemName, description: data.itemPrice, imageUrl: image, params: "item_name=\(data.itemName)&type=legonggu")
    }
    
    @objc func segueButton(_ sender: UIButton) {
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            Firestore.firestore().collection("legonggu_item").document(self.LegongguObject[self.row].itemName).getDocument { response, error in
                self.LegongguObject[self.row].remainCount = response?.data()?["remain_count"] as? Int ?? 0
                self.countLabel.text = "\(self.LegongguObject[self.row].remainCount)"
                DispatchGroup.leave()
            }
        }
        
        DispatchGroup.notify(queue: .main) {
            if ((self.closeTimeLabel.text == "마감") || (self.countLabel.text == "0")) && !(UIViewController.appDelegate.MemberId == "01031853309") {
                self.setAlert(title: nil, body: "공동구매 마감되었습니다.", style: .actionSheet, time: 2)
            } else {
                let segue = self.storyboard?.instantiateViewController(withIdentifier: "LegongguOptionViewController") as! LegongguOptionViewController
                segue.modalPresentationStyle = .overFullScreen
                segue.LegongguObject = self.LegongguObject; segue.row = self.row; segue.LegongguOptionObject = self.LegongguOptionObject
                self.presentPanModal(segue)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension LegongguDetailViewController: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        itemImagePositionLabel.text = "\(page+1) / \(LegongguObject[row].itemImage.count)"
    }
}
