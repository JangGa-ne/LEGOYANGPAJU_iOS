//
//  OrderViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/17.
//

import UIKit

class OrderViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    let pickerView_1 = UIPickerView()
    let pickerView_2 = UIPickerView()
    
    var BasketObject: [ItemArrayData] = []
    
    var addressCheckImageViews: [UIImageView] = []
    var addressCheckLabels: [UILabel] = []
    
    var lepayPoint: Int = 0
    var deliveryCoupon: Bool = false
    
    var address: String = ""
    var itemPrice: Int = 0
    var deliveryPrice: Int = 3000
    var lepaypointPrice: Int = 0
    var paymentType: String = ""
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var addressButton_1: UIButton!
    @IBOutlet weak var addressButton_2: UIButton!
    @IBOutlet weak var addressView_1: UIView!
    @IBOutlet weak var addressStackView_1: UIStackView!
    @IBOutlet weak var addressStackViewHeight_1: NSLayoutConstraint!
    @IBOutlet weak var addressStackView_2: UIStackView!
    @IBOutlet weak var addressTextfield_1: UITextField!
    @IBOutlet weak var addressSearchButton: UIButton!
    @IBOutlet weak var addressTextfield_2: UITextField!
    @IBOutlet weak var addressAppendImageView: UIImageView!
    @IBOutlet weak var addressAppendButton: UIButton!
    @IBOutlet weak var memoTextfield: UITextField!
    
    @IBOutlet weak var recieverNameTextfield: UITextField!
    @IBOutlet weak var recieverNumberTextfield_1_1: UITextField!
    @IBOutlet weak var recieverNumberTextfield_1_2: UITextField!
    @IBOutlet weak var recieverNumberTextfield_1_3: UITextField!
    @IBOutlet weak var recieverNumberTextfield_2_1: UITextField!
    @IBOutlet weak var recieverNumberTextfield_2_2: UITextField!
    @IBOutlet weak var recieverNumberTextfield_2_3: UITextField!
    
    @IBOutlet weak var ordererNameTextfield: UITextField!
    @IBOutlet weak var ordererNumberTextfield: UITextField!
    
    @IBOutlet weak var basketStackView: UIStackView!
    @IBOutlet weak var basketLabel: UILabel!
    
    @IBOutlet weak var lepayPointLabel: UILabel!
    @IBOutlet weak var lepayPointTextfield: UITextField!
    @IBOutlet weak var lepayPointButton: UIButton!
    
    @IBOutlet weak var naverPayImageView: UIImageView!
    @IBOutlet weak var naverPayButton: UIButton!
    @IBOutlet weak var kakaoPayImageView: UIImageView!
    @IBOutlet weak var kakaoPayButton: UIButton!
    @IBOutlet weak var payImageView: UIImageView!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var lepayPointPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var gradePointLabel: UILabel!
    @IBOutlet weak var benefitPointLabel: UILabel!
    
    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.OrderViewControllerDelegate = self
        
        setKeyboard()
        
        for textfield in [addressTextfield_1, addressTextfield_2, memoTextfield, recieverNameTextfield, recieverNumberTextfield_1_1, recieverNumberTextfield_1_2, recieverNumberTextfield_1_3, recieverNumberTextfield_2_1, recieverNumberTextfield_2_2, recieverNumberTextfield_2_3, ordererNameTextfield, ordererNumberTextfield, lepayPointTextfield] {
            textfield?.paddingLeft(10); textfield?.paddingRight(10); textfield?.addTarget(self, action: #selector(textfield(_:)), for: .editingChanged); textfield?.delegate = self
        }
        
        for (i, button) in [addressButton_1, addressButton_2, addressSearchButton, addressAppendButton, lepayPointButton, naverPayButton, kakaoPayButton, payButton, orderButton].enumerated() {
            button?.tag = i; button?.addTarget(self, action: #selector(button(_:)), for: .touchUpInside)
        }
        
        addressTextfield_1.isEnabled = false
        memoTextfield.placeholder("배송시 요청사항을 입력해 주세요.", COLOR: .lightGray)
        recieverNameTextfield.placeholder("수령인 이름을 입력해 주세요.", COLOR: .lightGray)
        
        pickerView_1.delegate = self; pickerView_1.dataSource = self; recieverNumberTextfield_1_1.inputView = pickerView_1
        pickerView_2.delegate = self; pickerView_2.dataSource = self; recieverNumberTextfield_2_1.inputView = pickerView_2
        
        if UIViewController.appDelegate.MemberObject.deliveryAddress.count > 0 {
            
            addressButton_1.backgroundColor = .H_00529C
            addressButton_1.setTitleColor(.white, for: .selected)
            addressButton_1.isSelected = true
            addressButton_2.backgroundColor = .clear
            addressButton_2.setTitleColor(.H_00529C, for: .normal)
            addressButton_2.isSelected = false
            
            addressView_1.isHidden = false
            addressStackView_2.isHidden = true
            
            addressCheckImageViews.removeAll(); addressCheckLabels.removeAll()
            addressStackView_1.removeAllArrangedSubviews()
            
            for (i, data) in UIViewController.appDelegate.MemberObject.deliveryAddress.enumerated() {
                
                let addressCheckStackView = UIStackView()
                addressCheckStackView.translatesAutoresizingMaskIntoConstraints = false
                addressCheckStackView.addConstraint(NSLayoutConstraint(item: addressCheckStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
                addressCheckStackView.axis = .horizontal
                addressCheckStackView.spacing = 5
                addressCheckStackView.tag = i; addressCheckStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addressCheckTap(_:))))
                
                let addressCheckImageView = UIImageView()
                addressCheckImageView.translatesAutoresizingMaskIntoConstraints = false
                addressCheckImageView.addConstraint(NSLayoutConstraint(item: addressCheckImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
                addressCheckImageView.contentMode = .scaleAspectFit
                addressCheckImageView.image = UIImage(named: "check_off")
                addressCheckImageViews.append(addressCheckImageView)
                addressCheckStackView.addArrangedSubview(addressCheckImageView)
                
                let addressCheckLabel = UILabel()
                addressCheckLabel.font = UIFont.systemFont(ofSize: 14)
                addressCheckLabel.lineBreakMode = .byTruncatingMiddle
                addressCheckLabel.textAlignment = .left
                addressCheckLabel.numberOfLines = 2
                addressCheckLabel.textColor = .black
                addressCheckLabel.text = data
                addressCheckLabels.append(addressCheckLabel)
                addressCheckStackView.addArrangedSubview(addressCheckLabel)
                
                addressStackView_1.addArrangedSubview(addressCheckStackView)
            }
            
            if UIViewController.appDelegate.MemberObject.deliveryAddress.count > 0 {
                addressStackViewHeight_1.constant = CGFloat(UIViewController.appDelegate.MemberObject.deliveryAddress.count*30)
            } else {
                addressStackViewHeight_1.constant = 30
            }
            
        } else {
            
            addressButton_1.backgroundColor = .clear
            addressButton_1.setTitleColor(.H_00529C, for: .normal)
            addressButton_1.isSelected = false
            addressButton_2.backgroundColor = .H_00529C
            addressButton_2.setTitleColor(.white, for: .selected)
            addressButton_2.isSelected = true
            
            addressView_1.isHidden = true
            addressStackView_2.isHidden = false
        }
        
        if UIViewController.appDelegate.MemberObject.name != "" {
            ordererNameTextfield.isEnabled = false
            ordererNameTextfield.text = UIViewController.appDelegate.MemberObject.name
        } else {
            ordererNameTextfield.isEnabled = true
        }
        ordererNumberTextfield.isEnabled = false
        ordererNumberTextfield.text = setHyphen("phone", UIViewController.appDelegate.MemberObject.number)
        
        for data in BasketObject {
            
            basketLabel.text = data.itemName
            
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
            
            basketStackView.addArrangedSubview(stackView)
            
            itemPrice = ((Int(data.itemPrice) ?? 0)*(Int(data.itemCount) ?? 0))
            if data.freeDeliveryCouponUse == "true" {
                deliveryPrice = 0
                deliveryCoupon = true
            } else {
                deliveryPrice = 3000
                deliveryCoupon = false
            }
        }
        
        loadingData()
    }
    
    func loadingData() {
        
        let data = UIViewController.appDelegate.MemberObject
        lepayPoint = Int(data.point) ?? 0
        
        lepayPointLabel.text = "보유 레페이 포인트: \(NF.string(from: (Int(data.point) ?? 0) as NSNumber) ?? "0")원"
        lepayPointTextfield.text = "\(lepaypointPrice)"
        
        itemPriceLabel.text = "\(NF.string(from: itemPrice as NSNumber) ?? "0")원"
        deliveryPriceLabel.text = "\(NF.string(from: deliveryPrice as NSNumber) ?? "0")원"
        lepayPointPriceLabel.text = "\(NF.string(from: -lepaypointPrice as NSNumber) ?? "0")원"
        totalPriceLabel.text = "\(NF.string(from: (itemPrice+deliveryPrice-lepaypointPrice) as NSNumber) ?? "0")원"
        
        let grade = (Int(data.grade) ?? 1)+1
        gradeImageView.image = UIImage(named: "lv\(data.grade)")
        gradePointLabel.text = "레페이 적립 \(grade)%"
        benefitPointLabel.text = "\(NF.string(from: Int(CGFloat(itemPrice+deliveryPrice-lepaypointPrice)*(CGFloat(grade)*0.01)) as NSNumber) ?? "0")원"
    }
    
    @objc func addressCheckTap(_ sender: UITapGestureRecognizer) {
        
        guard let sender = sender.view else { return }
        
        for i in 0 ..< addressCheckLabels.count {
            if i == sender.tag {
                address = addressCheckLabels[i].text!
                addressCheckImageViews[i].image = UIImage(named: "check_on")
            } else {
                addressCheckImageViews[i].image = UIImage(named: "check_off")
            }
        }
    }
    
    @objc func button(_ sender: UIButton) {
        
        view.endEditing(true)
        
        if sender.tag == 0 {
            
            address = ""
            addressTextfield_1.text?.removeAll()
            addressTextfield_2.text?.removeAll()
            addressAppendButton.isSelected = false
            addressAppendImageView.image = UIImage(named: "check_off")
            
            addressButton_1.backgroundColor = .H_00529C
            addressButton_1.setTitleColor(.white, for: .selected)
            addressButton_1.isSelected = true
            addressButton_2.backgroundColor = .clear
            addressButton_2.setTitleColor(.H_00529C, for: .normal)
            addressButton_2.isSelected = false
            
            addressView_1.isHidden = false
            addressStackView_2.isHidden = true
            
        } else if sender.tag == 1 {
            
            address = ""
            for imageView in addressCheckImageViews { imageView.image = UIImage(named: "check_off") }
            
            addressButton_1.backgroundColor = .clear
            addressButton_1.setTitleColor(.H_00529C, for: .normal)
            addressButton_1.isSelected = false
            addressButton_2.backgroundColor = .H_00529C
            addressButton_2.setTitleColor(.white, for: .selected)
            addressButton_2.isSelected = true
            
            addressView_1.isHidden = true
            addressStackView_2.isHidden = false
            
        } else if sender.tag == 2 {
            
            let segue = storyboard?.instantiateViewController(withIdentifier: "SafariViewController") as! SafariViewController
            segue.titleName = "주소 검색"; segue.linkUrl = "https://kasroid.github.io/Kakao-Postcode/"
            navigationController?.pushViewController(segue, animated: true)
            
        } else if sender.tag == 3 {
            
            sender.isSelected = !sender.isSelected
            
            if !sender.isSelected {
                addressAppendImageView.image = UIImage(named: "check_on")
            } else {
                addressAppendImageView.image = UIImage(named: "check_off")
            }
            
        } else if sender.tag == 4 {
            
            if lepayPoint > (itemPrice+deliveryPrice) {
                lepaypointPrice = itemPrice+deliveryPrice
            } else {
                lepaypointPrice = lepayPoint
            }
            
            loadingData()
            
        } else if sender.tag == 5 {
            
            paymentType = "네이버페이"
            naverPayImageView.image = UIImage(named: "check_on")
            naverPayButton.isSelected = true
            kakaoPayImageView.image = UIImage(named: "check_off")
            kakaoPayButton.isSelected = false
            payImageView.image = UIImage(named: "check_off")
            payLabel.text = "일반결제"
            payButton.isSelected = false
            
        } else if sender.tag == 6 {
            
            paymentType = "카카오페이"
            naverPayImageView.image = UIImage(named: "check_off")
            naverPayButton.isSelected = false
            kakaoPayImageView.image = UIImage(named: "check_on")
            kakaoPayButton.isSelected = true
            payImageView.image = UIImage(named: "check_off")
            payLabel.text = "일반결제"
            payButton.isSelected = false
            
        } else if sender.tag == 7 {
            
            paymentType = "일반결제"
            naverPayImageView.image = UIImage(named: "check_off")
            naverPayButton.isSelected = false
            kakaoPayImageView.image = UIImage(named: "check_off")
            kakaoPayButton.isSelected = false
            payImageView.image = UIImage(named: "check_on")
            payLabel.text = "일반결제"
            payButton.isSelected = true
            
            let alert = UIAlertController(title: nil, message: "일반결제", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "신용/체크 카드", style: .default, handler: { _ in
                self.paymentType = "카드"; self.payLabel.text = "일반결제 (신용/체크 카드)"
            }))
            alert.addAction(UIAlertAction(title: "휴대폰 소액결제", style: .default, handler: { _ in
                self.paymentType = "휴대폰"; self.payLabel.text = "일반결제 (휴대폰 소액결제)"
            }))
            present(alert, animated: true, completion: nil)
            
        } else if sender.tag == 8 {
            
            if address == "" {
                S_NOTICE("배송지 (!)")
            } else if (recieverNameTextfield.text! == "") || (recieverNumberTextfield_1_1.text! == "선택") || (recieverNumberTextfield_1_2.text! == "") || (recieverNumberTextfield_1_3.text! == "") {
                S_NOTICE("수령인 (!)")
            } else if (ordererNameTextfield.text! == "") || (ordererNumberTextfield.text! == "") {
                S_NOTICE("결제수단 (!)")
            } else if (paymentType == "") && ((itemPrice+deliveryPrice-lepaypointPrice) != 0) {
                S_NOTICE("결제수단 (!)")
            } else if (itemPrice+deliveryPrice-lepaypointPrice) != 0 {
                bootpay()
            } else {
                order(receiptId: "")
            }
        }
    }
}

extension OrderViewController {
    
    @objc func textfield(_ sender: UITextField) {
        
        if sender == addressTextfield_2 {
            address = "\(addressTextfield_1.text!) \(addressTextfield_2.text!)"
        } else if sender == lepayPointTextfield {
            
            if ((itemPrice+deliveryPrice) <= lepayPoint) && ((itemPrice+deliveryPrice) <= (Int(sender.text!) ?? 0)) {
                sender.text = "\(itemPrice+deliveryPrice)"
            } else if (lepayPoint < (itemPrice+deliveryPrice)) && (lepayPoint <= (Int(sender.text!) ?? 0)) {
                sender.text = "\(lepayPoint)"
            } else {
                sender.text = sender.text!
            }
            
            lepaypointPrice = Int(lepayPointTextfield.text!) ?? 0; loadingData(); return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var isBackspace: Bool = false
        if let char = string.cString(using: .utf8) { isBackspace = (strcmp(char, "\\b") == -92) } else { isBackspace = false }
        
        if textField == recieverNameTextfield {
            if (range.location < 20) { return true } else { return false }
        } else if (textField == recieverNumberTextfield_1_2) || (textField == recieverNumberTextfield_1_3) || (textField == recieverNumberTextfield_2_2) || (textField == recieverNumberTextfield_2_3) {
            if (range.location < 4) || isBackspace { return true } else { textField.resignFirstResponder(); return false }
        } else {
            return true
        }
    }
}

extension OrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ["선택", "010", "011", "016", "018", "019"][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView_1 {
            recieverNumberTextfield_1_1.text = ["선택", "010", "011", "016", "018", "019"][row]
        } else if pickerView == pickerView_2 {
            recieverNumberTextfield_2_1.text = ["선택", "010", "011", "016", "018", "019"][row]
        }
    }
}
