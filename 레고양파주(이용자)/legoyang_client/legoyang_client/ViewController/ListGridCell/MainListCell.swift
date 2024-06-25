//
//  MainListCell.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/05/10.
//

import UIKit
import ImageSlideshow

class MainGridCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var subContentLabel: UILabel!
}

class MainListCell: UITableViewCell {
    
    var delegate: MainViewController!
    var row: Int = 0
    
    @IBOutlet weak var imageSliderView: ImageSlideshow!
    @IBOutlet weak var imageSliderPageControl: UIPageControl!
    
    @IBOutlet weak var pangpangView: UIView!
    @IBOutlet weak var explainPangpangView: UIView!
    @IBOutlet weak var explainReviewView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var couponWantView: UIView!
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var wantView: UIView!
    @IBOutlet weak var wantLabel: UILabel!
    @IBOutlet weak var reviewView: UIView!
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var gridBackgroundView: UIView!
    @IBOutlet weak var gridView: UICollectionView!
    @IBOutlet weak var gridViewHeight: NSLayoutConstraint!
    
    func viewDidLoad() {
        
        gridView.delegate = nil; gridView.dataSource = nil
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        gridView.setCollectionViewLayout(layout, animated: true, completion: nil)
        gridView.delegate = self; gridView.dataSource = self; gridView.reloadData()
    }
    
    @objc func segueButton(_ sender: UITapGestureRecognizer) {
        
        guard let sender = sender.view else { return }
        
        if sender.tag == 0 {
            
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
            segue.detail = true
            delegate.navigationController?.pushViewController(segue, animated: true)
            
        } else if sender.tag == 1 {
//            delegate.setPlayer(linkUrl: "https://dl.dropboxusercontent.com/s/up64m0q65irfn59/notice_guide.mp4")
            delegate.setPipMediaPlayer(linkUrl: "https://dl.dropboxusercontent.com/s/ca2ag92x6mliyif/notice_guide.mp4", width: 40*5, height: 50*5)
        } else if sender.tag == 2 {
//            delegate.setPlayer(linkUrl: "https://dl.dropboxusercontent.com/s/56dgqm8dr57ccso/review_guide.mp4")
            delegate.setPipMediaPlayer(linkUrl: "https://dl.dropboxusercontent.com/s/56dgqm8dr57ccso/review_guide.mp4", width: 40*5, height: 50*5)
        } else if sender.tag == 3 {
            delegate.segueViewController(identifier: "LoginAAViewController")
        } else if sender.tag == 4 {
            delegate.segueViewController(identifier: "CouponViewController")
        } else if sender.tag == 5 {
            delegate.segueViewController(identifier: "WantViewController")
        } else if sender.tag == 6 {
            
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "CouponViewController") as! CouponViewController
            segue.position = 1
            delegate.navigationController?.pushViewController(segue, animated: true)
        }
    }
}

extension MainListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if row == 1 {
            if UIViewController.appDelegate.MainPangpangStoreObject.count > 0 { return UIViewController.appDelegate.MainPangpangStoreObject.count } else { return 0 }
        } else if row == 2 {
            if UIViewController.appDelegate.MainLegongguObject.count > 0 { return UIViewController.appDelegate.MainLegongguObject.count } else { return 1 }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if row == 1 {
            
            let data = UIViewController.appDelegate.MainPangpangStoreObject[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGridCell_1", for: indexPath) as! MainGridCell
            
            if data.pangpangImage != "" {
                delegate.setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.pangpangImage, cornerRadius: 10, contentMode: .scaleAspectFill)
            } else {
                cell.itemImageView.image = UIImage(named: "logo2")
            }
            cell.countLabel.text = "\(data.pangpangRemain)"
            cell.mainTitleLabel.text = data.storeName
            cell.subTitleLabel.text = "\(data.pangpangMenu) 무료쿠폰"
            
            return cell
            
        } else if (row == 2) && (UIViewController.appDelegate.MainLegongguObject.count > 0) {
            
            let data = UIViewController.appDelegate.MainLegongguObject[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGridCell_2", for: indexPath) as! MainGridCell
            
            if data.itemMainImage != "" {
                delegate.setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.itemMainImage, cornerRadius: 10, contentMode: .scaleAspectFill)
            } else if data.itemImage.count > 0 {
                delegate.setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.itemImage[0], cornerRadius: 10, contentMode: .scaleAspectFill)
            } else {
                cell.itemImageView.image = UIImage(named: "logo2")
            }
            cell.countLabel.text = "\(data.remainCount)"
            cell.mainTitleLabel.text = data.itemName
            cell.subContentLabel.text = data.itemPrice
            cell.subTitleLabel.text = "\(NF.string(from: (Int(data.itemBasePrice) ?? 0) as NSNumber) ?? "0")원"
            
            return cell
            
        } else if (row == 2) && (UIViewController.appDelegate.MainLegongguObject.count == 0) {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "MainGridCell_3", for: indexPath) as! MainGridCell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if row == 1 {
            
            if UIViewController.appDelegate.MemberId == "" {
                delegate.S_NOTICE("로그인 (!)"); delegate.segueViewController(identifier: "LoginAAViewController")
            } else {
                let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
                segue.StoreObject = UIViewController.appDelegate.MainPangpangStoreObject; segue.row = indexPath.row
                delegate.navigationController?.pushViewController(segue, animated: true)
            }
            
        } else if (row == 2) && (UIViewController.appDelegate.MainLegongguObject.count > 0) {
            
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "LegongguDetailViewController") as! LegongguDetailViewController
            segue.LegongguObject = UIViewController.appDelegate.MainLegongguObject; segue.row = indexPath.row
            delegate.navigationController?.pushViewController(segue, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if row == 1 {
            gridViewHeight.constant = 165; return CGSize(width: 120, height: 165)
        } else if (row == 2) && (UIViewController.appDelegate.MainLegongguObject.count > 0) {
            gridViewHeight.constant = 180; return CGSize(width: 120, height: 180)
        } else if (row == 2) && (UIViewController.appDelegate.MainLegongguObject.count == 0) {
            gridViewHeight.constant = 180; return CGSize(width: collectionView.frame.width-40, height: 180)
        } else {
            return .zero
        }
    }
}
