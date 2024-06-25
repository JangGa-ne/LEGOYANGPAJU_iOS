//
//  S_QRCODE.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/03/07.
//

import UIKit

extension UIViewController {
    
    func S_QRCODE(_ string: String) -> UIImage? {
        // 한글을 포함한 문자열을 NSData로 변환합니다.
        let data = string.data(using: String.Encoding.utf8)
        
        // QR 코드 생성을 위한 CIFilter를 생성합니다.
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        // 필터에 입력값을 지정합니다.
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue("H", forKey: "inputCorrectionLevel") // 오류 정정 레벨을 "H"로 지정합니다.
        
        // QR 코드 이미지를 생성합니다.
        guard let qrImage = qrFilter.outputImage else { return nil }
        
        // 이미지를 크기 조정합니다.
        let scaleX = UIScreen.main.scale
        let transformedImage = qrImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleX))
        
        // UIImage를 생성하여 반환합니다.
        return UIImage(ciImage: transformedImage)
    }
}
