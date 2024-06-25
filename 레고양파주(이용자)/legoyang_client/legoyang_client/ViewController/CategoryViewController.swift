//
//  CategoryViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/05.
//

import UIKit

class CategoryViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var detail: Bool = false
    
    @IBOutlet weak var backView: UIView!
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var pangpangSwitch: UISwitch!
    @IBOutlet weak var gridView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.isHidden = !detail
        pangpangSwitch.isOn = detail
        pangpangSwitch.addTarget(self, action: #selector(pangpangSwitch(_:)), for: .valueChanged)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        gridView.setCollectionViewLayout(layout, animated: true, completion: nil)
        gridView.delegate = self; gridView.dataSource = self
    }
    
    @objc func pangpangSwitch(_ sender: UISwitch) {
        gridView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(detail)
        
        UIViewController.CategoryViewControllerDelegate = self
        UIViewController.StoreViewControllerDelegate = nil
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UIViewController.appDelegate.CategoryObject.count > 0 { return UIViewController.appDelegate.CategoryObject.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = UIViewController.appDelegate.CategoryObject[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryGridCell_1", for: indexPath) as! CategoryGridCell
        
        setImageNuke(imageView: cell.iconImageView, placeholder: UIImage(), imageUrl: data.imageUrl, cornerRadius: 0, contentMode: .scaleAspectFit)
        cell.mainTitleLabel.text = data.cateName
        if pangpangSwitch.isOn { cell.subTitleLabel.text = "\(data.pangpangCount)" } else { cell.subTitleLabel.text = "\(data.count)" }
        cell.subTitleLabelWidth.constant = stringWidth(text: cell.subTitleLabel.text!, fontSize: 10)+20
        
        if indexPath.row == 0, let delegate = UIViewController.TutorialViewControllerDelegate {
            gridView.contentOffset = CGPoint(x: 0, y: 0)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { delegate.loadingData(level: 1, image: cell.toImage()) }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let segue = storyboard?.instantiateViewController(withIdentifier: "StoreViewController") as! StoreViewController
        segue.usePangpang = pangpangSwitch.isOn; segue.position = indexPath.row
        navigationController?.pushViewController(segue, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width-50)/2, height: 60)
    }
}
