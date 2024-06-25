//
//  UICustomImageView.swift
//  Apartment
//
//  Created by 장 제현 on 2021/05/06.
//

import UIKit

class UICustomImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .H_4895CF; layer.cornerRadius = frame.width/2; clipsToBounds = true
    }
}
