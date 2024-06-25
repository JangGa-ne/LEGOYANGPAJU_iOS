//
//  UINodataView.swift
//  Kkumnamu
//
//  Created by 장 제현 on 2021/10/18.
//

import UIKit

extension UIViewController {
    
    static var NODATA_L = UILabel()
    
    func NODATA(RECT: UIView, MESSAGE: String) {
        
        UIViewController.NODATA_L.frame = CGRect(x: (RECT.frame.width/2)-80, y: (RECT.frame.height/2)-15, width: 160, height: 30)
        UIViewController.NODATA_L.layer.borderColor = UIColor.H_2B3F6B.cgColor
        UIViewController.NODATA_L.layer.borderWidth = 1
        UIViewController.NODATA_L.layer.cornerRadius = 15
        UIViewController.NODATA_L.font = UIFont.systemFont(ofSize: 12)
        UIViewController.NODATA_L.textAlignment = .center
        UIViewController.NODATA_L.textColor = .H_2B3F6B
        UIViewController.NODATA_L.text = MESSAGE
        
        RECT.addSubview(UIViewController.NODATA_L)
    }
}
