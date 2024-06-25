//
//  StoreViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/09.
//

import UIKit

class StoreViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var usePangpang: Bool = false
    var position: Int = 0
    var refreshControl = UIRefreshControl()
    
    var StoreObject: [StoreData] = []
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var gridView: UICollectionView!
    @IBOutlet weak var listView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.StoreViewControllerDelegate = self
        
        searchTextField.paddingLeft(10); searchTextField.paddingRight(5)
        searchTextField.placeholder("매장명을 입력해 주세요.", COLOR: .lightGray)
        searchTextField.returnKeyType = .search
        searchTextField.addTarget(self, action: #selector(searchTextField(_:)), for: .editingChanged)
        searchTextField.delegate = self
        searchButton.addTarget(self, action: #selector(searchButton(_:)), for: .touchUpInside)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        gridView.setCollectionViewLayout(layout, animated: true, completion: nil)
        gridView.delegate = self; gridView.dataSource = self
        
        listView.backgroundColor = .white
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        listView.keyboardDismissMode = .onDrag
        listView.delegate = self; listView.dataSource = self
        
        refreshControl.backgroundColor = .clear; refreshControl.tintColor = .H_00529C
        refreshControl.addTarget(self, action: #selector(refreshControl(_:)), for: .valueChanged)
        listView.refreshControl = refreshControl
    }
    
    @objc func searchTextField(_ sender: UITextField) {
        if sender.text == "" { searchButton(UIButton()) }
    }
    
    @objc func searchButton(_ sender: UIButton) {
        
        StoreObject.removeAll()
        
        for data in UIViewController.appDelegate.StoreObject {
            
            if UIViewController.appDelegate.CategoryObject[position].cateName == data.storeCategory {
                
                if searchTextField.text == "" {
                    if usePangpang { if data.usePangpang == "true" { StoreObject.append(data) } } else { StoreObject.append(data) }
                } else if (data.storeName.range(of: searchTextField.text!, options: .caseInsensitive) != nil) {
                    if usePangpang { if data.usePangpang == "true" { StoreObject.append(data) } } else { StoreObject.append(data) }
                } else {
                    for tag in data.storeTag {
                        if (tag.range(of: searchTextField.text!, options: .caseInsensitive) != nil) {
                            if usePangpang { if data.usePangpang == "true" { StoreObject.append(data) } } else { StoreObject.append(data) }; break
                        }
                    }
                }
            }
        }
        
        loadingData()
    }
    
    func loadingData() {
        
        for (i, data) in StoreObject.enumerated() {
            if (UIViewController.TutorialViewControllerDelegate == nil) && (data.storeId == "01099999999") {
                StoreObject.remove(at: i); break
            }
        }
        
        gridView.reloadData(); listView.reloadData(); listView.contentOffset = CGPoint(x: 0, y: -20); refreshControl.endRefreshing()
    }
    
    @objc func refreshControl(_ sender: UIRefreshControl) {
        if let refresh = UIViewController.LoadingViewControllerDelegate {
            refresh.loadingData2()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
        
        searchButton(UIButton())
    }
}

extension StoreViewController {
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButton(UIButton()); return true
    }
}

extension StoreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UIViewController.appDelegate.CategoryObject.count > 0 { return UIViewController.appDelegate.CategoryObject.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = UIViewController.appDelegate.CategoryObject[indexPath.row]
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
        cell.mainTitleLabel.text = data.cateName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true); position = indexPath.row; searchButton(UIButton())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: stringWidth(text: UIViewController.appDelegate.CategoryObject[indexPath.row].cateName, fontSize: 14)+40, height: 40)
    }
}

extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if StoreObject.count > 0 { return StoreObject.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let data = StoreObject[indexPath.row]
        let cell = cell as! StoreListCell
        
        if data.storeImage != "" {
            setImageNuke(imageView: cell.storeImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.storeImage, cornerRadius: 10, contentMode: .scaleAspectFill)
        } else if data.imageArray.count > 0 {
            setImageNuke(imageView: cell.storeImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.imageArray[0], cornerRadius: 10, contentMode: .scaleAspectFill)
        } else {
            cell.storeImageView.image = UIImage(named: "logo2")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = StoreObject[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListCell_1", for: indexPath) as! StoreListCell
        cell.delegate = self; cell.StoreObject = StoreObject; cell.row = indexPath.row; cell.bottomSheet = false
        
        cell.quoteLeftImageView.image = UIImage(named: quoteLeftImages[data.storeColor] ?? "quote_left0")
        cell.storeNameLabel.text = " \(data.storeName) "
        cell.quoteRightImageView.image = UIImage(named: quoteRightImages[data.storeColor] ?? "quote_right0")
        if data.usePangpang == "true" {
            cell.pangpangStackView.isHidden = false; cell.pangpangCountLabel.text = "\(data.pangpangRemain)"
        } else {
            cell.pangpangStackView.isHidden = true
        }
        cell.mainTitleLabel.text = data.storeSubTitle
        cell.subTitleLabel.text = data.storeEtc
        
        var menu: String = ""
        cell.subContentLabel.text?.removeAll()
        for data in data.storeMenu {
            if data.menuName.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567890").inverted) != nil {
                menu.append("#\(data.menuName)(\(data.menuPrice)) ")
            } else {
                menu.append("#\(data.menuName)(\(NF.string(from: (Int(data.menuPrice) ?? 0) as NSNumber) ?? "0")원) ")
            }
        }; if data.storeMenu.count > 0 { cell.menuView.isHidden = false; cell.subContentLabel.text = menu } else { cell.menuView.isHidden = true }
        
        if indexPath.item == 0 { print(data.storeMenu.count) }
        if indexPath.row == 0 {
            cell.storeImageBackgroundStackView.isHidden = true
            if data.imageArray.count > 0 { cell.gridBackgroundView.isHidden = false } else { cell.gridBackgroundView.isHidden = true }
            cell.viewDidLoad()
            cell.subTitleLabel.numberOfLines = 5
            cell.menuView.isHidden = false
        } else {
            cell.storeImageBackgroundStackView.isHidden = false
            cell.gridBackgroundView.isHidden = true
            cell.subTitleLabel.numberOfLines = 2
            cell.menuView.isHidden = true
        }
        
        if indexPath.row != (StoreObject.count-1) { cell.lineView.isHidden = false } else { cell.lineView.isHidden = true }
        
        if indexPath.row == 0, let delegate = UIViewController.TutorialViewControllerDelegate {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { delegate.loadingData(level: 2, image: cell.toImage(), imageHeight: cell.bounds.height) }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        view.endEditing(true)
        
        if UIViewController.appDelegate.MemberId == "" {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else {
            let segue = storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
            segue.StoreObject = StoreObject; segue.row = indexPath.row
            navigationController?.pushViewController(segue, animated: true)
        }
    }
}
