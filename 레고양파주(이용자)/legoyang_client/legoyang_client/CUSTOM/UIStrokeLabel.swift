//
//  UIStrokeLabel.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/25.
//

import UIKit

@IBDesignable
class UIStrokeLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(5)
        context?.setLineJoin(.miter)
        context?.resetClip()
        
        context?.setTextDrawingMode(.stroke)
        textColor = .black
        super.drawText(in: rect)
        
        context?.setTextDrawingMode(.fill)
        textColor = .white
        super.drawText(in: rect)
    }
}
