//
//  S_BASE.swift
//  mujimasjib
//
//  Created by 장 제현 on 2022/07/10.
//

import UIKit

extension UIViewController {
    
    static var AD: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    static var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @objc func BACK_V(_ sender: UITapGestureRecognizer) { guard let _ = navigationController?.popViewController(animated: true) else { dismiss(animated: true, completion: nil); return } }
    
    func FORMAT(MASK: String, PHONE: String) -> String {
        
        let NUMBERS = PHONE.replacingOccurrences(of: "[^0-9*#]", with: "", options: .regularExpression)
        var RESULT: String = ""
        var INDEX = NUMBERS.startIndex
        
        for CH in MASK where INDEX < NUMBERS.endIndex {
            if CH == "X" { RESULT.append(NUMBERS[INDEX]); INDEX = NUMBERS.index(after: INDEX) } else { RESULT.append(CH) }
        }
        
        return RESULT
    }
    func NUMBER(_ TYPE: String, _ STRING: String) -> String {
        
        let NUMBER = STRING.replacingOccurrences(of: "-", with: "")
        if TYPE == "phone" {
            if NUMBER.count <= 8 {
                return FORMAT(MASK: "XXXX-XXXX", PHONE: NUMBER)
            } else if NUMBER.count <= 9 && NUMBER[NUMBER.startIndex] == "0" && NUMBER[NUMBER.index(after: NUMBER.startIndex)] == "2" {
                return FORMAT(MASK: "XX-XXX-XXXX", PHONE: NUMBER)
            } else if NUMBER.count <= 10 && NUMBER[NUMBER.startIndex] == "0" && NUMBER[NUMBER.index(after: NUMBER.startIndex)] == "2" {
                return FORMAT(MASK: "XX-XXXX-XXXX", PHONE: NUMBER)
            } else if NUMBER.count <= 10 {
                return FORMAT(MASK: "XXX-XXX-XXXX", PHONE: NUMBER)
            } else if NUMBER.count <= 11 {
                return FORMAT(MASK: "XXX-XXXX-XXXX", PHONE: NUMBER)
            } else if NUMBER.count <= 12 {
                return FORMAT(MASK: "XXXX-XXXX-XXXX", PHONE: NUMBER)
            } else {
                return NUMBER
            }
        } else if TYPE == "company" {
            return FORMAT(MASK: "XXX-XX-XXXXX", PHONE: NUMBER)
        } else {
            return NUMBER
        }
    }
}

extension UIView {
    
    func roundShadows(color: UIColor, offset: CGSize, opcity: Float, radius1: CGFloat, radius2: CGFloat) {
        layer.shadowColor = color.cgColor; layer.shadowOffset = offset; layer.shadowOpacity = opcity; layer.shadowRadius = radius1; layer.cornerRadius = radius2
    }
    
    func roundCorners(corners: CACornerMask, radius: CGFloat) {
        layer.maskedCorners = corners; self.layer.cornerRadius = radius; self.clipsToBounds = true
    }
    
    func rotate360() {
        
        let ROTATE = CABasicAnimation(keyPath: "transform.rotation.z")
        ROTATE.toValue = Double.pi * 2
        ROTATE.duration = 1.0
        ROTATE.isCumulative = true
        ROTATE.repeatCount = .greatestFiniteMagnitude
        
        layer.add(ROTATE, forKey: "rotationAnimation")
    }
}

extension UITableViewCell { override open func awakeFromNib() { super.awakeFromNib(); selectionStyle = .none } }

class TC_TITLE: UITableViewCell { @IBOutlet weak var TITLE_L: UILabel! }
class CC_TITLE: UICollectionViewCell { @IBOutlet weak var TITLE_L: UILabel! }

extension UIStackView {
    
    func removeAllArrangedSubviews() { arrangedSubviews.forEach { removeArrangedSubview($0); NSLayoutConstraint.deactivate($0.constraints); $0.removeFromSuperview() } }
}
