//
//  LegongguViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/10.
//

import UIKit
import ImageSlideshow

class LegongguGridCell: UICollectionViewCell {
    
    var timer: Timer? = nil
    
    @IBOutlet weak var itemCloseTimeLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemBasePriceLabel: UILabel!
    @IBOutlet weak var itemSaleInfoImageView: UIImageView!
    @IBOutlet weak var itemSaleInfoLabel: UILabel!
    @IBOutlet weak var shareView: UIView!
}

class LegongguViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var detail: Bool = false
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var backView: UIView!
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var gridView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.isHidden = !detail
        
        if detail {
            if let refresh = UIViewController.LoadingViewControllerDelegate {
                refresh.loadingData3()
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical; layout.minimumLineSpacing = 20; layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        gridView.setCollectionViewLayout(layout, animated: true, completion: nil)
        gridView.delegate = self; gridView.dataSource = self
        
        refreshControl.backgroundColor = .clear; refreshControl.tintColor = .H_00529C
        refreshControl.addTarget(self, action: #selector(refreshControl(_:)), for: .valueChanged)
        gridView.refreshControl = refreshControl
    }
    
    @objc func refreshControl(_ sender: UIRefreshControl) {
        if let refresh = UIViewController.LoadingViewControllerDelegate {
            refresh.loadingData3()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIViewController.LegongguViewControllerDelegate = self
        
        setBackSwipeGesture(detail)
    }
}

extension LegongguViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UIViewController.appDelegate.LegongguObject.count > 0 { return UIViewController.appDelegate.LegongguObject.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = UIViewController.appDelegate.LegongguObject[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LegongguGridCell_1", for: indexPath) as! LegongguGridCell
        
        var timestamp: Int = (Int(data.endTime) ?? 0) - (self.setKoreaTimestamp()/1000)
        cell.itemCloseTimeLabel.text = FM_TIMER(TIMESTAMP: timestamp)
        cell.timer = nil
        cell.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timestamp = timestamp-1; cell.itemCloseTimeLabel.text = self.FM_TIMER(TIMESTAMP: timestamp)
        }
        if FM_TIMER(TIMESTAMP: timestamp) == "마감" { cell.timer?.invalidate() } else { RunLoop.current.add(cell.timer ?? Timer(), forMode: .common) }
        cell.itemCountLabel.text = "\(data.remainCount)"
        
        if data.itemMainImage != "" {
            setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.itemMainImage, cornerRadius: 10, contentMode: .scaleAspectFill)
        } else if data.itemImage.count > 0 {
            setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.itemImage[0], cornerRadius: 10, contentMode: .scaleAspectFill)
        } else {
            cell.itemImageView.image = UIImage(named: "logo2")
        }
        cell.itemNameLabel.text = data.itemName
        cell.itemPriceLabel.text = data.itemPrice
        cell.itemBasePriceLabel.text = "\(NF.string(from: (Int(data.itemBasePrice) ?? 0) as NSNumber) ?? "0")원"
        if data.itemSaleInfo.contains("적립") { cell.itemSaleInfoImageView.isHidden = false } else { cell.itemSaleInfoImageView.isHidden = true }
        cell.itemSaleInfoLabel.text = data.itemSaleInfo
        
        cell.shareView.tag = indexPath.row; cell.shareView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareGongguTap(_:))))
        
        return cell
    }
    
    @objc func shareGongguTap(_ sender: UITapGestureRecognizer) {
        
        guard let sender = sender.view else { return }
        
        let data = UIViewController.appDelegate.LegongguObject[sender.tag]
        
        var image: String = ""
        if data.itemImage.count > 0 { image = data.itemImage[0] } else { image = UIViewController.appDelegate.AppLegoObject.logoImage }
        
        setShare(title: data.itemName, description: data.itemPrice, imageUrl: image, params: "item_name=\(data.itemName)&type=legonggu")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let segue = storyboard?.instantiateViewController(withIdentifier: "LegongguDetailViewController") as! LegongguDetailViewController
        segue.LegongguObject = UIViewController.appDelegate.LegongguObject; segue.row = indexPath.row
        navigationController?.pushViewController(segue, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-40, height: (collectionView.frame.width-40)+160)
    }
}
