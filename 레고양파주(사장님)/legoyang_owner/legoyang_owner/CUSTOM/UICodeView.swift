//
//  UICodeView.swift
//  Apartment
//
//  Created by 장 제현 on 2021/04/12.
//

import UIKit

enum CodeType: String {
    
    case QR = "CIQRCodeGenerator"
    case PDF = "CIPDF417BarcodeGenerator"
    case BAR = "CICode128BarcodeGenerator"
    case AZTEC = "CIAztecCodeGenerator"
}

//@IBDesignable
class UICodeView: UIControl {
    
    var thumbView: UIImageView = { return UIImageView() }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .clear; thumbView.frame = bounds; updateView()
    }
    
    private func resetViews() { subviews.forEach { $0.removeFromSuperview() } }
    
    func updateView() { resetViews(); addSubview(thumbView) }
    
    func setSegmentedWith(code: String, type: CodeType, size: CGSize) -> UIImage? {
        
        if let filter = filter(code: code, type: type) {
            return image(filter: filter, size: size)
        } else {
            return nil
        }
    }
    
    fileprivate func image(filter : CIFilter, size: CGSize) -> UIImage? {
        
        if let image = filter.outputImage {
            return UIImage(ciImage: image.transformed(by: CGAffineTransform(scaleX: size.width / image.extent.size.width, y: size.height / image.extent.size.height)))
        } else {
            return nil
        }
    }
    
    fileprivate func filter(code: String, type: CodeType) -> CIFilter? {
        
        if let filter = CIFilter(name: type.rawValue) {
            guard let data = code.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return nil }
            filter.setValue(data, forKey: "inputMessage")
            return filter
        } else {
            return nil
        }
    }
}
