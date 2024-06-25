//
//  StoreListCell.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/05.
//

import UIKit

class StoreGridCell: UICollectionViewCell {
    
    @IBOutlet weak var storeImageView: UIImageView!
}

class StoreListCell: UITableViewCell {
    
    var delegate: UIViewController!
    var StoreObject: [StoreData] = []
    var row: Int = 0
    
    var bottomSheet: Bool = false
    
    @IBOutlet weak var quoteLeftImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var quoteRightImageView: UIImageView!
    @IBOutlet weak var pangpangStackView: UIStackView!
    @IBOutlet weak var pangpangCountLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var subContentLabel: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    
    @IBOutlet weak var storeImageBackgroundStackView: UIStackView!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var gridBackgroundView: UIView!
    @IBOutlet weak var gridView: UICollectionView!
    
    @IBOutlet weak var lineView: UIView!
    
    func viewDidLoad() {
        
        gridView.delegate = nil; gridView.dataSource = nil
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        gridView.setCollectionViewLayout(layout, animated: true, completion: nil)
        gridView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(segueButton(_:))))
        gridView.delegate = self; gridView.dataSource = self
    }
    
    @objc func segueButton(_ sender: UITapGestureRecognizer) {
        
        delegate.view.endEditing(true)
        
        if UIViewController.appDelegate.MemberId == "" {
            delegate.S_NOTICE("로그인 (!)"); delegate.segueViewController(identifier: "LoginAAViewController")
        } else if bottomSheet {
            
            delegate.dismiss(animated: true, completion: nil)
            
            if let delegate = UIViewController.GeoMapViewControllerDelegate {
                let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
                segue.StoreObject = StoreObject; segue.row = row
                delegate.navigationController?.pushViewController(segue, animated: true)
            }
            
        } else {
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
            segue.StoreObject = StoreObject; segue.row = row
            delegate.navigationController?.pushViewController(segue, animated: true)
        }
    }
}

extension StoreListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if StoreObject[row].imageArray.count > 0 { return StoreObject[row].imageArray.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = StoreObject[row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreGridCell_1", for: indexPath) as! StoreGridCell
        
        delegate.setImageNuke(imageView: cell.storeImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.imageArray[indexPath.row], cornerRadius: 10, contentMode: .scaleAspectFill)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
