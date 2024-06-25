//
//  SearchViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/05.
//

import UIKit

class SearchGridCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
}

class SearchListCell: UITableViewCell {

    var delegate: SearchViewController!
    
    var StoreObject: [StoreData] = []
    
    @IBOutlet weak var gridView: UICollectionView!
    @IBOutlet weak var gridViewHeight: NSLayoutConstraint!

    func viewDidLoad() {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        gridView.setCollectionViewLayout(layout, animated: true, completion: nil)
        gridView.delegate = self; gridView.dataSource = self
    }
    
    func loadingData() {
        
        StoreObject = UIViewController.appDelegate.StoreObject
        StoreObject.sort { front, behind in front.viewCount > behind.viewCount }
        
        gridView.reloadData()
        
        if StoreObject.count > 0 { gridViewHeight.constant = ((gridView.frame.width-20)/3+45)*2+10 } else { gridViewHeight.constant = 0 }
    }
}

extension SearchListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if StoreObject.count > 6 { return 6 } else if StoreObject.count > 0 { return StoreObject.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = StoreObject[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchGridCell_1", for: indexPath) as! SearchGridCell
        
        if data.storeImage != "" {
            delegate.setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.storeImage, cornerRadius: 10, contentMode: .scaleAspectFill)
        } else if data.imageArray.count > 0 {
            delegate.setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.imageArray[0], cornerRadius: 10, contentMode: .scaleAspectFill)
        } else {
            cell.itemImageView.image = UIImage(named: "logo2")
        }
        cell.mainTitleLabel.text = data.storeName
        cell.subTitleLabel.text = data.storeCategory
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if UIViewController.appDelegate.MemberId == "" {
            delegate.S_NOTICE("로그인 (!)"); delegate.segueViewController(identifier: "LoginAAViewController")
        } else {
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
            segue.StoreObject = StoreObject; segue.row = indexPath.row
            delegate.navigationController?.pushViewController(segue, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width-20)/3, height: (collectionView.frame.width-20)/3+45)
    }
}

class SearchViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var search: Bool = false
    
    var SearchObject: [StoreData] = []
    var SearchValues: [String] = []
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: false) }
    @IBOutlet weak var noticeCountLabel: UILabel!
    @IBOutlet weak var noticeCountLabelWidth: NSLayoutConstraint!
    @IBAction func noticeButton(_ sender: UIButton) { view.endEditing(true); segueViewController(identifier: "NoticeViewController") }
    @IBAction func settingButton(_ sender: UIButton) {
        view.endEditing(true)
        if UIViewController.appDelegate.MemberId == "" {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else {
            segueViewController(identifier: "SettingViewController")
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchHistoryView: UIView!
    @IBOutlet weak var searchDeleteButton: UIButton!
    @IBOutlet weak var gridView: UICollectionView!
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.SearchViewControllerDelegate = self
        
        if UIViewController.appDelegate.noticeCount > 0 {
            noticeCountLabel.isHidden = false
            noticeCountLabel.text = "\(UIViewController.appDelegate.noticeCount)"
            noticeCountLabelWidth.constant = stringWidth(text: "\(UIViewController.appDelegate.noticeCount)", fontSize: 10)+10
        } else {
            noticeCountLabel.isHidden = true
        }
        
        searchTextField.becomeFirstResponder()
        searchTextField.paddingLeft(10); searchTextField.paddingRight(5)
        searchTextField.placeholder("#고양맛집 #파주맛집 #감성카페 ...", COLOR: .lightGray)
        searchTextField.returnKeyType = .search
        searchTextField.addTarget(self, action: #selector(searchTextField(_:)), for: .editingChanged)
        searchTextField.delegate = self
        searchButton.addTarget(self, action: #selector(searchButton(_:)), for: .touchUpInside)
        searchHistoryView.isHidden = false
        searchDeleteButton.addTarget(self, action: #selector(searchDeleteButton(_:)), for: .touchUpInside)
        
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
        
        if let refresh = UIViewController.LoadingViewControllerDelegate {
            refresh.loadingData2()
        }
        
        searchButton(UIButton())
    }
    
    @objc func searchTextField(_ sender: UITextField) {
        if sender.text == "" { navigationController?.popViewController(animated: false) }
    }
    
    @objc func searchButton(_ sender: UIButton) {
        
        if sender == searchButton { search = true }
        
        SearchObject.removeAll()
        
        var recentSearchWords = UserDefaults.standard.stringArray(forKey: "searchValues") ?? []
        
        if (searchTextField.text == "") || (searchTextField.text == " ") {
            search = false; searchHistoryView.isHidden = false
        } else {
            
            for data in UIViewController.appDelegate.StoreObject {
                
                if (data.storeName.range(of: searchTextField.text!, options: .caseInsensitive) != nil) {
                    SearchObject.append(data)
                } else {
                    for tag in data.storeTag {
                        if (tag.range(of: searchTextField.text!, options: .caseInsensitive) != nil) { SearchObject.append(data); break }
                    }
                }
            }
            
            recentSearchWords.append(searchTextField.text!)
            
            UserDefaults.standard.setValue(recentSearchWords, forKey: "searchValues")
            UserDefaults.standard.synchronize()
        }
        
        recentSearchWords.reverse()
        SearchValues = recentSearchWords
        
        if SearchValues.count > 0 {
            searchDeleteButton.isHidden = false
            gridView.backgroundColor = .white
        } else {
            searchDeleteButton.isHidden = true
            gridView.backgroundColor = .clear
        }
        
        for (i, data) in SearchObject.enumerated() {
            if data.storeId == "01099999999" { SearchObject.remove(at: i); break }
        }
        
        gridView.reloadData(); listView.reloadData()
        
    }
    
    @objc func searchDeleteButton(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "searchValues"); searchTextField.text?.removeAll(); searchButton(sender)
    }
}

extension SearchViewController {
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search = true; searchButton(UIButton()); return true
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if SearchValues.count > 0 { return SearchValues.count } else { return 0 }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NaviBarGridCell_1", for: indexPath) as! NaviBarGridCell
        
        cell.mainTitleLabel.text = SearchValues[indexPath.row]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        view.endEditing(true)
        
        searchTextField.text = SearchValues[indexPath.row]
        SearchValues.remove(at: indexPath.row)
        
        search = true; searchButton(UIButton())
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: stringWidth(text: SearchValues[indexPath.row], fontSize: 14)+30, height: 40)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search {
            if SearchObject.count > 0 { searchHistoryView.isHidden = true; return SearchObject.count } else { searchHistoryView.isHidden = false; return 0 }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
            
        for indexPath in indexPaths {
            
            if search {
                
                let data = SearchObject[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListCell_1", for: indexPath) as! StoreListCell
                
                if data.storeImage != "" {
                    setImageNuke(imageView: cell.storeImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.storeImage, cornerRadius: 10, contentMode: .scaleAspectFill)
                } else if data.imageArray.count > 0 {
                    setImageNuke(imageView: cell.storeImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.imageArray[0], cornerRadius: 10, contentMode: .scaleAspectFill)
                } else {
                    cell.storeImageView.image = UIImage(named: "logo2")
                }
            } else {
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if search {
            
            let data = SearchObject[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListCell_1", for: indexPath) as! StoreListCell
            cell.delegate = self; cell.StoreObject = SearchObject; cell.row = indexPath.row; cell.bottomSheet = false
            
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
            for data in data.storeMenu {
                if data.menuPrice.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567890").inverted) != nil {
                    menu.append("#\(data.menuName)(\(data.menuPrice)) ")
                } else {
                    menu.append("#\(data.menuName)(\(NF.string(from: (Int(data.menuPrice) ?? 0) as NSNumber) ?? "0")원) ")
                }
            }; if data.storeMenu.count > 0 { cell.menuView.isHidden = false; cell.subContentLabel.text = menu } else { cell.menuView.isHidden = true }
            
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
            
            if indexPath.row != SearchObject.count-1 { cell.lineView.isHidden = false } else { cell.lineView.isHidden = true }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchListCell_1", for: indexPath) as! SearchListCell
            cell.delegate = self; cell.viewDidLoad(); cell.loadingData()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        view.endEditing(true)
        
        if search {
            
            if UIViewController.appDelegate.MemberId == "" {
                S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
            } else {
                let segue = storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
                segue.StoreObject = SearchObject; segue.row = indexPath.row
                navigationController?.pushViewController(segue, animated: true)
            }
        }
    }
}
