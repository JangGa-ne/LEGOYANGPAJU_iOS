//
//  LegongguViewController2.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/05/03.
//

import UIKit

class LegongguViewController2: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var detail: Bool = false
    var position: Int = 0
    var refreshControl = UIRefreshControl()
    
    let FilterObject: [String] = ["최신순", "낮은 가격순"]
    var LegongguObject: [LegongguData] = []
    
    @IBOutlet weak var backView: UIView!
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var gridView: UICollectionView!
    @IBOutlet weak var legongguCountLabel: UILabel!
    @IBOutlet weak var listView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.isHidden = !detail
        
        if detail {
            if let refresh = UIViewController.LoadingViewControllerDelegate {
                refresh.loadingData3()
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        gridView.setCollectionViewLayout(layout, animated: true, completion: nil)
        gridView.delegate = self; gridView.dataSource = self
        
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        listView.delegate = self; listView.dataSource = self
        
        loadingData()
        
        refreshControl.backgroundColor = .clear; refreshControl.tintColor = .H_00529C
        refreshControl.addTarget(self, action: #selector(refreshControl(_:)), for: .valueChanged)
        listView.refreshControl = refreshControl
    }
    
    func loadingData() {
        
        LegongguObject.removeAll()
        
        for (i, data) in UIViewController.appDelegate.LegongguObject.enumerated() {
            if position == 0 {
                LegongguObject.append(data)
            } else if position == 1 {
                LegongguObject.append(data)
            }
        }
        
        legongguCountLabel.text = "총 \(LegongguObject.count)개의 상품"
        gridView.reloadData(); listView.reloadData();
    }
    
    @objc func refreshControl(_ sender: UIRefreshControl) {
        if let refresh = UIViewController.LoadingViewControllerDelegate {
            refresh.loadingData3()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(detail)
    }
}

extension LegongguViewController2: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if FilterObject.count > 0 { return FilterObject.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
        cell.mainTitleLabel.text = FilterObject[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        position = indexPath.row; loadingData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: stringWidth(text: FilterObject[indexPath.row], fontSize: 14)+40, height: 40)
    }
}

extension LegongguViewController2: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if LegongguObject.count > 0 { return LegongguObject.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let data = LegongguObject[indexPath.row]
        let cell = cell as! LegongguListCell
        
        if data.itemMainImage != "" {
            setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.itemMainImage, cornerRadius: 0, contentMode: .scaleAspectFill)
        } else if data.itemImage.count > 0 {
            setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.itemImage[0], cornerRadius: 0, contentMode: .scaleAspectFill)
        } else {
            cell.itemImageView.image = UIImage(named: "logo3")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = LegongguObject[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LegongguListCell_1", for: indexPath) as! LegongguListCell
        
        var timestamp: Int = (Int(data.endTime) ?? 0)-(self.setKoreaTimestamp()/1000)
        cell.itemCloseTimeLabel.text = setTimer(timestamp: timestamp)
        cell.timer = nil
        cell.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timestamp = timestamp-1; cell.itemCloseTimeLabel.text = self.setTimer(timestamp: timestamp)
        }
        if setTimer(timestamp: timestamp) == "마감" {
            cell.timer?.invalidate()
        } else {
            RunLoop.current.add(cell.timer ?? Timer(), forMode: .common)
        }
        
        cell.itemPriceLabelWidth.constant = stringWidth(text: data.itemPrice, fontSize: 12)+20
        cell.itemPriceLabel.text = data.itemPrice
        cell.itemCountLabelWidth.constant = stringWidth(text: "\(data.remainCount)개 남음", fontSize: 12)+20
        cell.itemCountLabel.text = "\(data.remainCount)개 남음"
        cell.itemBasePriceLabel.text = "\(NF.string(from: (Int(data.itemBasePrice) ?? 0) as NSNumber) ?? "0")원"
        cell.itemDiscountPercentLabel.text = "0%"
        cell.itemDiscountPriceLabel.text = "\(NF.string(from: (Int(data.itemBasePrice) ?? 0) as NSNumber) ?? "0")원"
        cell.itemBuyCountLabel.text = "구매 \(data.remainCount)/0"
        
        return cell
    }
}
