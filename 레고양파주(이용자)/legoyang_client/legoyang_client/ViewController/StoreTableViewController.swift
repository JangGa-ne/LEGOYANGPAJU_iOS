//
//  StoreTableViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/15.
//

import UIKit
import PanModal

class StoreTableViewController: UITableViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var StoreObject: [StoreData] = []
    var row: [Int] = []
    
    var StoreTableObject: [StoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.StoreTableViewControllerDelegate = self
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        loadingData()
    }
    
    func loadingData() {
        
        StoreTableObject.removeAll()
        
        for position in row {
            StoreTableObject.append(StoreObject[position])
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if StoreTableObject.count > 0 { return StoreTableObject.count } else { return 0 }
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        let data = StoreObject[indexPath.row]
//        let cell = cell as! StoreListCell
//
//        if data.storeImage != "" {
//            setImageNuke(imageView: cell.storeImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.storeImage, cornerRadius: 10, contentMode: .scaleAspectFill)
//        } else if data.imageArray.count > 0 {
//            setImageNuke(imageView: cell.storeImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.imageArray[0], cornerRadius: 10, contentMode: .scaleAspectFill)
//        } else {
//            cell.storeImageView.image = UIImage(named: "logo2")
//        }
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = StoreTableObject[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListCell_1", for: indexPath) as! StoreListCell
        cell.delegate = self; cell.StoreObject = StoreTableObject; cell.row = indexPath.row; cell.bottomSheet = true
        
        if data.storeImage != "" {
            setImageNuke(imageView: cell.storeImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.storeImage, cornerRadius: 10, contentMode: .scaleAspectFill)
        } else if data.imageArray.count > 0 {
            setImageNuke(imageView: cell.storeImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.imageArray[0], cornerRadius: 10, contentMode: .scaleAspectFill)
        } else {
            cell.storeImageView.image = UIImage(named: "logo2")
        }
        
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
            if data.menuName.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567890").inverted) != nil {
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
        
        if indexPath.row != (StoreTableObject.count-1) { cell.lineView.isHidden = false } else { cell.lineView.isHidden = true }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true, completion: nil)
        
        if let delegate = UIViewController.GeoMapViewControllerDelegate {
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
            segue.StoreObject = StoreTableObject; segue.row = indexPath.row
            delegate.navigationController?.pushViewController(segue, animated: true)
        }
    }
}

extension StoreTableViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return tableView
    }
    
    // 접혔을 때
    var shortFormHeight: PanModalHeight {
        // 높이를 390으로 설정
        return .contentHeight(340)
    }
    
    // 펼쳐졌을 때
    var longFormHeight: PanModalHeight {
        if row.count == 1 {
            return .contentHeight(340)
        } else {
            return .maxHeightWithTopInset(60)
        }
    }
    
    // true 값을 리턴하면 화면 화면 최상단까지 스크롤 불가
    var anchorModalToLongForm: Bool {
        return true
    }
}
