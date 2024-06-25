//
//  S_TEXT.swift
//  APT
//
//  Created by 장 제현 on 2021/04/19.
//

import UIKit

extension String {
    
    var ns: NSString { return self as NSString }
    var pathExtension: String { return ns.pathExtension }
}

extension UILabel {
    
    func titleFont(size: CGFloat) { font = UIFont(name: "GmarketSansMedium", size: size) }
}

/// 텍스트 레이아웃 보조 및 인코딩 작업 처리
extension UIViewController {
    
    func DT_CHECK(_ STRING: String) -> String {
        if STRING == "" || STRING == "0" { return "" } else { return STRING }
    }
    
    func ENCODE(_ DECODE_TEXT: String) -> String {
        
        if DECODE_TEXT != "" {
            
            var TEXT: String = ""
            
            let BASE64 = Data(base64Encoded: DECODE_TEXT, options: [])
            if let BASE64 = BASE64 { TEXT = String(data: BASE64, encoding: .utf8) ?? "UTF8 변환 오류" } else { TEXT = DECODE_TEXT }
            
            return TEXT.replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "&apos;", with: "").replacingOccurrences(of: "?", with: "")
        } else {
            return ""
        }
    }
    
// 줄간격
    func LINE_SPACING(TEXT: String, LINE_SPACING: CGFloat) -> NSAttributedString {
        
        let STRING = NSMutableAttributedString(string: TEXT)
        let STYLE = NSMutableParagraphStyle()
        STYLE.lineSpacing = LINE_SPACING
        STRING.addAttribute(.paragraphStyle, value: STYLE, range: NSMakeRange(0, STRING.length) )
        
        return STRING
    }
    
// 글자수 제한
    @objc func MAX_TEXT(_ sender: UITextField) {
        guard let TEXT = sender.text else { return }
        if TEXT.count > sender.tag { sender.deleteBackward(); sender.resignFirstResponder() }
    }
    
// HTML
    func HTML_STRING(_ TEXT: String) -> String? {
        
        var ATTRIBUTED: NSAttributedString? = nil
        do {
            if let DATA = TEXT.data(using: .unicode) {
                ATTRIBUTED = try NSAttributedString(data: DATA, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            }
        } catch {
            
        }
        
        return ATTRIBUTED?.string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func HTML_STRING_DETAIL(_ TEXT: String, _ WIDTH: CGFloat) -> NSAttributedString? {
        
        var ATTRIBUTED: NSAttributedString? = nil
        do {
            if let DATA = TEXT.data(using: .unicode) {
                ATTRIBUTED = try NSAttributedString(data: DATA, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            }
        } catch { }
        
        return ATTRIBUTED?.TEXTVIEW_IMAGE_MAX_WIDTH(WIDTH: WIDTH)
    }
    
    func stringWidth(text: String, fontSize: CGFloat) -> CGFloat {
        return NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]).size().width
    }
}

extension UITextField {
    
    func paddingLeft(_ X: CGFloat) {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: X, height: frame.height)); leftViewMode = ViewMode.always
    }
    
    func paddingRight(_ X: CGFloat) {
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: X, height: frame.height)); rightViewMode = ViewMode.always
    }
    
    func placeholder(_ STRING: String, COLOR: UIColor) {
        attributedPlaceholder = NSAttributedString(string: STRING, attributes: [NSAttributedString.Key.foregroundColor: COLOR])
    }
    
    func removeSpecialChars() {
        text = text!.filter { Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890_").contains($0) }
    }
}

extension UITextView {
    
    func lineHeight() {
        let size = sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude))
        contentOffset.y = -max(0, (bounds.size.height - size.height * zoomScale) / 2)
    }
}

extension NSAttributedString {
    
// HTML 이미지 Width 100%
    func TEXTVIEW_IMAGE_MAX_WIDTH(WIDTH MAX_WIDTH: CGFloat) -> NSAttributedString {
        
        let TEXT = NSMutableAttributedString(attributedString: self)
        TEXT.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, TEXT.length), options: .init(rawValue: 0), using: { (value, range, stop) in
            if let ATTACHEMENT = value as? NSTextAttachment {
                let IMAGE = ATTACHEMENT.image(forBounds: ATTACHEMENT.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                if IMAGE.size.width > MAX_WIDTH {
                    let NEW_IMAGE = IMAGE.RESIZE_IMAGE(SCALE: MAX_WIDTH/IMAGE.size.width)
                    let NEW_ATTRIBUT = NSTextAttachment()
                    NEW_ATTRIBUT.image = NEW_IMAGE
                    TEXT.addAttribute(NSAttributedString.Key.attachment, value: NEW_ATTRIBUT, range: range)
                }
            }
        })
        
        return TEXT
    }
}

extension UIImage {
    
    func RESIZE_IMAGE(SCALE: CGFloat) -> UIImage {
        
        let NEW_SIZE = CGSize(width: self.size.width * SCALE, height: self.size.height * SCALE)
        let RECT = CGRect(origin: CGPoint.zero, size: NEW_SIZE)

        UIGraphicsBeginImageContext(NEW_SIZE)
        self.draw(in: RECT)
        let NEW_IMAGE = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return NEW_IMAGE!
    }
}
