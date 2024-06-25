//
//  BasketViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/17.
//

import UIKit
import FirebaseFirestore

class BasketListCell: UITableViewCell {
    
    var delegate: BasketViewController!
    var timer: Timer? = nil
    
    var BasketObject: [LegongguData] = []
    var row: Int = 0
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var optionStackView: UIStackView!
    
    @IBOutlet weak var itemCloseTimeLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var segueButton: UIButton!
    
    func viewDidLoad() {
        
        optionStackView.removeAllArrangedSubviews()
        
        for data in BasketObject[row].basket {
            
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 0
            
            let optionNameLabel = UILabel()
            optionNameLabel.translatesAutoresizingMaskIntoConstraints = false
            optionNameLabel.addConstraint(NSLayoutConstraint(item: optionNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15))
            optionNameLabel.font = UIFont.boldSystemFont(ofSize: 12)
            optionNameLabel.textAlignment = .left
            optionNameLabel.textColor = .black
            optionNameLabel.text = "옵션: \(data.itemOption) | 수량: \(data.itemCount)"
            stackView.addArrangedSubview(optionNameLabel)
            
            let optionPriceLabel = UILabel()
            optionPriceLabel.translatesAutoresizingMaskIntoConstraints = false
            optionPriceLabel.addConstraint(NSLayoutConstraint(item: optionPriceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
            optionPriceLabel.font = UIFont.boldSystemFont(ofSize: 14)
            optionPriceLabel.textAlignment = .left
            optionPriceLabel.textColor = .H_FF6F00
            optionPriceLabel.text = "\(NF.string(from: ((Int(data.itemPrice) ?? 0)*(Int(data.itemCount) ?? 0)) as NSNumber) ?? "0")원"
            stackView.addArrangedSubview(optionPriceLabel)
            
            optionStackView.addArrangedSubview(stackView)
        }
    }
    
    @objc func deleteButton(_ sender: UIButton) {
        
        let data = delegate.BasketObject[sender.tag]
        let alert = UIAlertController(title: "안내", message: "선택하신 상품을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            Firestore.firestore().collection("legonggu_basket").document(UIViewController.appDelegate.MemberId).updateData([data.itemName: FieldValue.delete()]) { error in
                if error == nil { self.delegate.loadingData() }
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        delegate.present(alert, animated: true, completion: nil)
    }
    
    @objc func segueButton(_ sender: UIButton) {
        
        let data = delegate.BasketObject[sender.tag]
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            Firestore.firestore().collection("legonggu_item").document(data.itemName).getDocument { response, error in
                data.remainCount = response?.data()?["remain_count"] as? Int ?? 0
                DispatchGroup.leave()
            }
        }
        
        DispatchGroup.notify(queue: .main) {
            if ((self.itemCloseTimeLabel.text == "마감") || (self.itemCountLabel.text == "0")) && !(UIViewController.appDelegate.MemberId == "01031853309") {
                self.delegate.setAlert(title: nil, body: "공동구매 마감되었습니다.", style: .actionSheet, time: 2)
            } else if (data.remainCount < Int(self.itemCountLabel.text!) ?? 0) && !(UIViewController.appDelegate.MemberId == "01031853309") {
                self.delegate.setAlert(title: nil, body: "구매 가능 범위를 초과하였습니다.", style: .actionSheet, time: 2)
            } else {
                let segue = self.delegate.storyboard?.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
                segue.BasketObject = self.BasketObject[self.row].basket
                self.delegate.navigationController?.pushViewController(segue, animated: true)
            }
        }
    }
}

class BasketViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var BasketObject: [LegongguData] = []
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var listView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.BasketViewControllerDelegate = self
        
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        listView.delegate = self; listView.dataSource = self
        
        loadingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if BasketObject.count > 0 { return BasketObject.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = BasketObject[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketListCell_1", for: indexPath) as! BasketListCell
        cell.delegate = self; cell.BasketObject = BasketObject; cell.row = indexPath.row; cell.viewDidLoad()
        
        if data.itemMainImage != "" {
            setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.itemMainImage, cornerRadius: 5, contentMode: .scaleAspectFill)
        } else if data.itemImage.count > 0 {
            setImageNuke(imageView: cell.itemImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.itemImage[0], cornerRadius: 5, contentMode: .scaleAspectFill)
        } else {
            cell.itemImageView.image = UIImage(named: "logo2")
        }
        
        cell.mainTitleLabel.text = data.itemName
        cell.subTitleLabel.text = data.itemContent
        
        var timestamp: Int = (Int(data.endTime) ?? 0) - (self.setKoreaTimestamp()/1000)
        cell.itemCloseTimeLabel.text = FM_TIMER(TIMESTAMP: timestamp)
        cell.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timestamp = timestamp-1; cell.itemCloseTimeLabel.text = self.FM_TIMER(TIMESTAMP: timestamp)
        }
        if FM_TIMER(TIMESTAMP: timestamp) == "마감" { cell.timer?.invalidate() } else { RunLoop.current.add(cell.timer ?? Timer(), forMode: .common) }
        cell.itemCountLabel.text = "\(data.remainCount)"
        
        var itemPrice: Int = 0
        var deliveryPrice: Int = 3000
        for data in data.basket {
            itemPrice += ((Int(data.itemPrice) ?? 0)*(Int(data.itemCount) ?? 0))
            if data.freeDeliveryCouponUse == "true" { deliveryPrice = 0 } else { deliveryPrice = 3000 }
        }
        
        cell.itemPriceLabel.text = "\(NF.string(from: itemPrice as NSNumber) ?? "0")원"
        cell.deliveryPriceLabel.text = "\(NF.string(from: deliveryPrice as NSNumber) ?? "0")원"
        cell.totalPriceLabel.text = "\(NF.string(from: (itemPrice+deliveryPrice) as NSNumber) ?? "0")원"
        
        cell.deleteButton.tag = indexPath.row; cell.deleteButton.addTarget(cell, action: #selector(cell.deleteButton(_:)), for: .touchUpInside)
        cell.segueButton.tag = indexPath.row; cell.segueButton.addTarget(cell, action: #selector(cell.segueButton(_:)), for: .touchUpInside)
        
        return cell
    }
}
