//
//  LegongguOptionViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/16.
//

import UIKit
import PanModal
import FirebaseFirestore

class LegongguOptionListCell: UITableViewCell {
    
    var delegate: LegongguOptionViewController!
    
    var LegongguOptionObject: [LegongguOptionData] = []
    var row: Int = 0
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var optionStackView: UIStackView!
    @IBOutlet weak var optionStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var itemMinusbutton: UIButton!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var itemPlusbutton: UIButton!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    func viewDidLoad() {
        
        optionStackView.removeAllArrangedSubviews()
        
        var optionButtons: [UIButton] = []
        
        for (i, data) in LegongguOptionObject[row].LegongguOptionDetail.enumerated() {
            
            let optionButton = UIButton()
            optionButton.frame.size.height = 30
            optionButton.backgroundColor = .H_F4F4F4
            optionButton.layer.cornerRadius = 10
            optionButton.clipsToBounds = true
            optionButton.contentHorizontalAlignment = .left
            optionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            optionButton.setTitleColor(.black, for: .normal)
            optionButton.setTitle("  \(data.optionName) (+\(NF.string(from: (Int(data.optionPrice) ?? 0) as NSNumber) ?? "0")원)", for: .normal)
            optionButton.tag = i; optionButton.addTarget(self, action: #selector(optionButton(_:)), for: .touchUpInside)
            optionButtons.append(optionButton)
            
            optionStackView.addArrangedSubview(optionButton)
        }
        
        optionStackViewHeight.constant = CGFloat(optionStackView.arrangedSubviews.count*40-10)
        
        let apiValue = OptionCheckData()
        
        apiValue.setOptionButtons(forKey: optionButtons)
        apiValue.setOptionCheck(forKey: false)
        apiValue.setOptionName(forKey: "")
        apiValue.setOptionPrice(forKey: 0)
        // 데이터 추가
        delegate.OptionCheckObject.append(apiValue)
    }
    
    @objc func optionButton(_ sender: UIButton) {
        
        let itemBasePrice = Int(delegate.LegongguObject[delegate.row].itemBasePrice) ?? 0
        var optionName: String = ""
        var optionPrice: Int = 0
        
        for (i, button) in delegate.OptionCheckObject[row].optionButtons.enumerated() {
            
            if sender.tag == i {
                
                delegate.OptionCheckObject[row].optionCheck = true
                delegate.OptionCheckObject[row].optionName = LegongguOptionObject[row].LegongguOptionDetail[i].optionName
                delegate.OptionCheckObject[row].optionPrice = Int(LegongguOptionObject[row].LegongguOptionDetail[i].optionPrice) ?? 0
                
                button.backgroundColor = .H_FF6F00
                button.setTitleColor(.white, for: .normal)
                
            } else {
                
                button.backgroundColor = .H_F4F4F4
                button.setTitleColor(.black, for: .normal)
                
            }
        }
        // 전체 옵션 선택완료 확인
        for data in delegate.OptionCheckObject { delegate.check = true; if !data.optionCheck { delegate.check = false; break } }
        if !delegate.check { return }
        // 항목 추가
        for (i, data) in delegate.OptionCheckObject.enumerated() {
            if i < (delegate.OptionCheckObject.count-1) { optionName.append("\(data.optionName) / ") } else { optionName.append(data.optionName) }
            optionPrice += data.optionPrice
        }
        delegate.OptionCheckDictionary.append(["option_name": optionName, "option_price": optionPrice+itemBasePrice, "option_count": 1])
        // 옵션 버튼 비활성화
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            
            for data in self.delegate.OptionCheckObject {
                
                for button in data.optionButtons {
                    
                    data.optionCheck = false
                    data.optionName = ""
                    data.optionPrice = 0
                    
                    button.backgroundColor = .H_F4F4F4
                    button.setTitleColor(.black, for: .normal)
                }
            }
        }
        delegate.check = false
        delegate.OptionCheckDictionary.reverse()
        
        UIView.performWithoutAnimation {
            self.delegate.listView.reloadSections(IndexSet(integer: 1), with: .none)
            self.delegate.listView.contentOffset = self.delegate.listView.contentOffset
            self.delegate.setTotal()
        }
    }
}

class LegongguOptionViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var LegongguObject: [LegongguData] = []
    var row: Int = 0
    
    var LegongguOptionObject: [LegongguOptionData] = []
    var OptionCheckObject: [OptionCheckData] = []
    var OptionCheckDictionary: [[String: Any]] = []
    
    var check: Bool = false
    
    @IBOutlet weak var listView: UITableView!
    
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var freeDeliveryCouponView: UIView!
    @IBOutlet weak var freeDeliveryCouponImageView: UIImageView!
    @IBOutlet weak var freeDeliveryCouponCountLabel: UILabel!
    
    @IBOutlet weak var basketButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.LegongguOptionViewControllerDelegate = self
        
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        listView.delegate = self; listView.dataSource = self
        
        for (i, button) in [basketButton, orderButton].enumerated() {
            button?.tag = i; button?.addTarget(self, action: #selector(segueButton(_:)), for: .touchUpInside)
        }
    }
    
    func setTotal() {
        
        var totalCount: Int = 0
        var totalPrice: Int = 3000
        
        for data in OptionCheckDictionary {
            
            let optionPrice = data["option_price"] as? Int ?? 0
            let optionCount = data["option_count"] as? Int ?? 0
            
            totalCount += optionCount
            totalPrice += optionCount*optionPrice
        }
        
        totalCountLabel.text = "\(totalCount)"
        totalPriceLabel.text = NF.string(from: totalPrice as NSNumber) ?? "0"
        
        if OptionCheckDictionary.count == 0 { listView.reloadData() }
    }
    
    @objc func segueButton(_ sender: UIButton) {
        
        if OptionCheckDictionary.count == 0 { setAlert(title: nil, body: "주문옵션을 선택해주시기 바랍니다.", style: .actionSheet, time: 2); return }
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("legonggu_item").document(self.LegongguObject[self.row].itemName).getDocument { response, error in
                self.LegongguObject[self.row].remainCount = response?.data()?["remain_count"] as? Int ?? 0
                DispatchGroup.leave()
            }
        }
        
        DispatchGroup.notify(queue: .main) {
            
            if (self.LegongguObject[self.row].remainCount == 0) && !(UIViewController.appDelegate.MemberId == "01031853309") {
                self.setAlert(title: nil, body: "공동구매 마감되었습니다.", style: .actionSheet, time: 2)
            } else if (self.LegongguObject[self.row].remainCount < Int(self.totalCountLabel.text!) ?? 0) && !(UIViewController.appDelegate.MemberId == "01031853309") {
                self.setAlert(title: nil, body: "구매 가능 범위를 초과하였습니다.", style: .actionSheet, time: 2)
            } else {
                
                var BasketObject: [ItemArrayData] = []
                var baskets: [Any] = []
                
                for dict in self.OptionCheckDictionary {
                    
                    let apiValue = ItemArrayData()
                    
                    apiValue.setFreeDeliveryCouponUse(forKey: "false")
                    apiValue.setItemCount(forKey: "\(dict["option_count"] as? Int ?? 0)")
                    apiValue.setItemName(forKey: self.LegongguObject[self.row].itemName)
                    apiValue.setItemOption(forKey: dict["option_name"] as? String ?? "")
                    apiValue.setItemOptions(forKey: [])
                    apiValue.setItemPrice(forKey: "\(dict["option_price"] as? Int ?? 0)")
                    // 데이터 추가
                    BasketObject.append(apiValue)
                    
                    baskets.append([
                        "freedelivery_coupon_use": "false",
                        "item_count": "\(dict["option_count"] as? Int ?? 0)",
                        "item_name": self.LegongguObject[self.row].itemName,
                        "item_option": dict["option_name"] as? String ?? "",
                        "item_options": [],
                        "item_price": "\(dict["option_price"] as? Int ?? 0)"
                    ])
                }
                
                var params: [String: Any] = [:]
                params[self.LegongguObject[self.row].itemName] = baskets
                
                Firestore.firestore().collection("legonggu_basket").document(UIViewController.appDelegate.MemberId).setData(params, merge: true) { error in
                    
                    if error == nil {
                        
                        if sender.tag == 0 {
                            
                            let alert = UIAlertController(title: "안내", message: "상품이 장바구니에 담겼습니다.\n지금 확인하시겠습니까?", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "장바구니", style: .default, handler: { _ in
                                
                                self.dismiss(animated: true, completion: nil)
                                
                                if let delegate = UIViewController.LegongguDetailViewControllerDelegate {
                                    delegate.segueViewController(identifier: "BasketViewController")
                                }
                                
                                return
                            }))
                            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        } else if sender.tag == 1 {
                            
                            self.dismiss(animated: true, completion: nil)
                            
                            if let delegate = UIViewController.LegongguDetailViewControllerDelegate {
                                let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
                                segue.BasketObject = BasketObject
                                delegate.navigationController?.pushViewController(segue, animated: true)
                            }
                        }
                    } else {
                        self.setAlert(title: "오류", body: "예기치 못한 오류가 발생했습니다. 나중에 다시 시도해 주세요.", style: .alert, time: 2)
                    }
                }
            }
        }
    }
}

extension LegongguOptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if LegongguOptionObject.count > 0 { return LegongguOptionObject.count } else { return 0 }
        } else if section == 1 {
            if OptionCheckDictionary.count > 0 { return OptionCheckDictionary.count } else { return 0 }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let data = LegongguOptionObject[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "LegongguOptionListCell_1", for: indexPath) as! LegongguOptionListCell
            cell.delegate = self; cell.LegongguOptionObject = LegongguOptionObject; cell.row = indexPath.row; cell.viewDidLoad()
            
            cell.mainTitleLabel.text = data.optionName
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let data = OptionCheckDictionary[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "LegongguOptionListCell_2", for: indexPath) as! LegongguOptionListCell
            
            let optionName = data["option_name"] as? String ?? ""
            let optionPrice = data["option_price"] as? Int ?? 0
            let optionCount = data["option_count"] as? Int ?? 0
            
            cell.mainTitleLabel.text = LegongguObject[row].itemName
            cell.subTitleLabel.text = optionName
            cell.itemCountLabel.text = "\(optionCount)"
            cell.itemPriceLabel.text = "\(NF.string(from: (optionPrice*optionCount) as NSNumber) ?? "0")원"
            
            cell.deleteButton.tag = indexPath.row; cell.deleteButton.addTarget(self, action: #selector(deleteButton(_:)), for: .touchUpInside)
            cell.itemMinusbutton.tag = indexPath.row; cell.itemMinusbutton.addTarget(self, action: #selector(minusButton(_:)), for: .touchUpInside)
            cell.itemPlusbutton.tag = indexPath.row; cell.itemPlusbutton.addTarget(self, action: #selector(plusButton(_:)), for: .touchUpInside)
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func deleteButton(_ sender: UIButton) { UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        OptionCheckDictionary.remove(at: sender.tag)
        
        UIView.performWithoutAnimation {
            self.listView.reloadSections(IndexSet(integer: 1), with: .none)
            self.listView.contentOffset = self.listView.contentOffset
            self.setTotal()
        }
    }
    
    @objc func minusButton(_ sender: UIButton) { UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        let data = OptionCheckDictionary[sender.tag]
        let optionCount = data["option_count"] as? Int ?? 0
        
        if optionCount > 1 { OptionCheckDictionary[sender.tag]["option_count"] = (OptionCheckDictionary[sender.tag]["option_count"] as? Int ?? 0)-1 }
        
        UIView.performWithoutAnimation {
            self.listView.reloadSections(IndexSet(integer: 1), with: .none)
            self.listView.contentOffset = self.listView.contentOffset
            self.setTotal()
        }
    }
    
    @objc func plusButton(_ sender: UIButton) { UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        OptionCheckDictionary[sender.tag]["option_count"] = (OptionCheckDictionary[sender.tag]["option_count"] as? Int ?? 0)+1
        
        UIView.performWithoutAnimation {
            self.listView.reloadSections(IndexSet(integer: 1), with: .none)
            self.listView.contentOffset = self.listView.contentOffset
            self.setTotal()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if LegongguOptionObject[indexPath.row].LegongguOptionDetail.count > 0 {
                return CGFloat(44+LegongguOptionObject[indexPath.row].LegongguOptionDetail.count*40-10)
            } else {
                return UITableView.automaticDimension
            }
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension LegongguOptionViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return view as? UIScrollView
    }
    
    // 접혔을 때
    var shortFormHeight: PanModalHeight {
        
//        var option: Int = 0
//        for data in LegongguOptionObject { option += 44+data.LegongguOptionDetail.count*40 }
//        let basket = CGFloat(OptionCheckDictionary.count*125)
//
//        return .contentHeight(CGFloat(option)+basket+293)
        return .contentHeight(500)
    }
    
    // 펼쳐졌을 때
    var longFormHeight: PanModalHeight {
        
//        var option: Int = 0
//        for data in LegongguOptionObject { option += 44+data.LegongguOptionDetail.count*40 }
//        let basket = CGFloat(OptionCheckDictionary.count*125)
//
//        return .contentHeight(CGFloat(option)+basket+293)
        return .contentHeight(500)
    }
    
    var anchorModalToLongForm: Bool {
        return true
    }
}
