//
//  WantViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/14.
//

import UIKit
import FirebaseFirestore

class WantViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var StoreObject: [StoreData] = []
    var myLikeStore: [String] = []
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.WantViewControllerDelegate = self
        
        listView.backgroundColor = .white
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        listView.keyboardDismissMode = .onDrag
        listView.delegate = self; listView.dataSource = self
    }
    
    func loadingData() {
        
        StoreObject.removeAll(); myLikeStore.removeAll()
        
        let memberData = UIViewController.appDelegate.MemberObject
        
        for storeData in UIViewController.appDelegate.StoreObject {
            for mylikeStore in memberData.mylikeStore {
                if storeData.storeId == mylikeStore {
                    StoreObject.append(storeData); myLikeStore.append(storeData.storeId)
                }
            }
        }
        
        mainTitleLabel.text = "\(memberData.name)(\(memberData.nick))님 / 총 \(StoreObject.count)개의 찜"
        
        Firestore.firestore().collection("member").document(UIViewController.appDelegate.MemberId).updateData(["mylike_store": myLikeStore])
        UIViewController.appDelegate.MemberObject.mylikeStore = myLikeStore
        if let refresh_1 = UIViewController.MainViewControllerDelegate {
//            refresh_1.listView.reloadSections(IndexSet(integer: 0), with: .none)
            refresh_1.listView.reloadData()
        }
        
        listView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadingData()
        
        setBackSwipeGesture(true)
    }
}

extension WantViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        cell.storeImageBackgroundStackView.isHidden = false
        cell.gridBackgroundView.isHidden = true
        cell.subTitleLabel.numberOfLines = 2
        cell.menuView.isHidden = true
        
        if indexPath.row != (StoreObject.count-1) { cell.lineView.isHidden = false } else { cell.lineView.isHidden = true }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let segue = storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
        segue.StoreObject = StoreObject; segue.row = indexPath.row
        navigationController?.pushViewController(segue, animated: true)
    }
}
