//
//  AroundListViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/17.
//

import UIKit

class AroundListViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var category: String = ""
    
    var AroundObject: [AroundData] = []
    var StoreObject: [StoreData] = []
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.AroundListViewControllerDelegate = self
        
        titleLabel.text = "주변 매장 (\(category))"
        
        listView.backgroundColor = .white
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        listView.delegate = self; listView.dataSource = self
        
        loadingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension AroundListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            cell.pangpangCountLabel.text = "\(data.pangpangRemain)"
        } else {
            cell.pangpangCountLabel.text = "0"
        }
        cell.mainTitleLabel.text = data.storeSubTitle
        cell.subTitleLabel.text = data.storeEtc
        
        cell.storeImageBackgroundStackView.isHidden = false
        cell.gridBackgroundView.isHidden = true
        cell.subTitleLabel.numberOfLines = 2
        cell.menuView.isHidden = true
        for aroundData in AroundObject {
            if aroundData.storeId == data.storeId { cell.rangeLabel.text = "\(aroundData.range)km"; break }
        }
        
        if indexPath.row != (StoreObject.count-1) { cell.lineView.isHidden = false } else { cell.lineView.isHidden = true }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let segue = storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
        segue.StoreObject = StoreObject; segue.row = indexPath.row
        navigationController?.pushViewController(segue, animated: true)
    }
}
