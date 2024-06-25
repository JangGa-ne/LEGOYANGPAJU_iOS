//
//  S_COLOR.swift
//  mujimasjib
//
//  Created by 장 제현 on 2022/07/16.
//

import UIKit

let quoteLeftImages: [String: String] = [
    "#7f7f7f": "quote_left0",
    "#ff0066": "quote_left1",
    "#ff0000": "quote_left2",
    "#ffc000": "quote_left3",
    "#ffff00": "quote_left4",
    "#00b050": "quote_left5",
    "#31859c": "quote_left6",
    "#3399ff": "quote_left7",
    "#0070c0": "quote_left8",
    "#9231db": "quote_left9"
]

let quoteRightImages: [String: String] = [
    "#7f7f7f": "quote_right0",
    "#ff0066": "quote_right1",
    "#ff0000": "quote_right2",
    "#ffc000": "quote_right3",
    "#ffff00": "quote_right4",
    "#00b050": "quote_right5",
    "#31859c": "quote_right6",
    "#3399ff": "quote_right7",
    "#0070c0": "quote_right8",
    "#9231db": "quote_right9"
]

extension UIColor {
    
    static var H_61C0A7 = UIColor(red: 97/255, green: 192/255, blue: 167/255, alpha: 1.0)   // 민트
    static var H_4E177C = UIColor(red: 78/255, green: 23/255, blue: 124/255, alpha: 1.0)    // 퍼플
    static var H_2B3F6B = UIColor(red: 43/255, green: 63/255, blue: 107/255, alpha: 1.0)    // 네이비
    static var H_4895CF = UIColor(red: 72/255, green: 149/255, blue: 207/255, alpha: 1.0)   // 블루
    static var H_FC7667 = UIColor(red: 252/255, green: 118/255, blue: 103/255, alpha: 1.0)  // 핑크
    static var H_00529C = UIColor(red: 0/255, green: 82/255, blue: 156/255, alpha: 1.0)     // 네이비
    static var H_FF6F00 = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1.0)    // 오렌지
    static var H_F4F4F4 = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)  // 그레이
    static var H_EFF5FF = UIColor(red: 239/255, green: 245/255, blue: 255/255, alpha: 1.0)  // 스카이
    
    static var H_F1F1F1 = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
    static var H_F3F3F3 = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
    static var H_E1E1EB = UIColor(red: 225/255, green: 225/255, blue: 235/255, alpha: 1.0)
    
    func COMPARISON(VALUE: Int) -> UIColor { if VALUE > 0 { return .systemRed } else if VALUE < 0 { return .systemGreen } else { return .black } }
    
    public convenience init?(hex: String, alpha: CGFloat) {
        
        let r, g, b: CGFloat
        
        if hex.hasPrefix("#") {
            
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: alpha)
                    
                    return
                }
            }
        }

        return nil
    }
}
