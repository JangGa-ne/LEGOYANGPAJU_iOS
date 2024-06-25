//
//  UIMainView.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/03.
//

import UIKit

class UIMainView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
    }
}
