//
//  S_VIEW.swift
//  mujimasjib
//
//  Created by 장 제현 on 2022/07/30.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }
}

extension UIView {
    
    func toImage() -> UIImage? {
        
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { ctx in layer.render(in: ctx.cgContext) }
        
        return image
    }
}
