//
//  S_NOTICE.swift
//  Horticulture
//
//  Created by 장 제현 on 2021/10/16.
//

import UIKit

// MARK: 알림 문구
extension UIViewController {
    
    func S_NOTICE(_ MESSAGE: String) {
        
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        let VIEW = UILabel(frame: CGRect(x: view.frame.size.width/2 - 97.5, y: 0, width: 195, height: 50))
        VIEW.alpha = 1.0; VIEW.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        VIEW.textColor = .lightGray; VIEW.textAlignment = .center; VIEW.font = .boldSystemFont(ofSize: 12); VIEW.text = MESSAGE
        VIEW.layer.cornerRadius = 25; VIEW.clipsToBounds = true
        UIViewController.appDelegate.window?.addSubview(VIEW)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            VIEW.transform = CGAffineTransform(translationX: 0, y: self.DEVICE_RATIO())
        })
        UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseOut, animations: {
            VIEW.transform = CGAffineTransform(translationX: 0, y: -50)
        }, completion: {(isCompleted) in
            VIEW.removeFromSuperview()
        })
    }
    
    func setAlert(title: String?, body: String?, style: UIAlertController.Style, time: CGFloat = 0) {
        
        let alert = UIAlertController(title: title, message: body, preferredStyle: style)
        present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func ALERT(VIEW: UIView, LABEL: UILabel, TEXT: String) {
        
        VIEW.frame = view.frame; VIEW.backgroundColor = UIColor(white: 0.0, alpha: 0.1); view.addSubview(VIEW)
        LABEL.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 140, y: UIScreen.main.bounds.height / 2 - 30, width: 260, height: 60)
        LABEL.layer.cornerRadius = 10; LABEL.clipsToBounds = true
        if #available(iOS 13.0, *) {
            LABEL.backgroundColor = .tertiarySystemBackground
        } else {
            LABEL.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        }
        LABEL.font = UIFont.systemFont(ofSize: 14)
        LABEL.textAlignment = .center; if #available(iOS 13.0, *) { LABEL.textColor = .label } else { LABEL.textColor = .black }
        LABEL.numberOfLines = 2; LABEL.text = TEXT
        view.addSubview(LABEL)
    }
    
    func PUSH(TITLE: String, BODY: String) {
        
        let CONTENT = UNMutableNotificationContent()
        CONTENT.title = TITLE; CONTENT.body = BODY; CONTENT.sound = .default
        if BODY.contains("부재중 전화") { CONTENT.userInfo = ["sf_reject": 1] } else { CONTENT.userInfo = ["sf_reject": 0] }
        
        let TRIGGER = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let REQUEST = UNNotificationRequest(identifier: "\(Int.random(in: 100000000...999999999))", content: CONTENT, trigger: TRIGGER)
        UNUserNotificationCenter.current().add(REQUEST)
    }
    
    func ALERT2(BG: UIView, TEXT: String = "데이터 불러오는 중...", TIME: CGFloat) {
        
        let LABEL = UILabel()
        LABEL.frame = CGRect(x: BG.frame.midX, y: BG.frame.midY, width: STRING_WIDTH(TEXT: TEXT, FONT_SIZE: 14), height: 45)
        LABEL.backgroundColor = .white
        LABEL.layer.cornerRadius = 12.5; LABEL.clipsToBounds = true
        LABEL.textColor = .black; LABEL.textAlignment = .center
        LABEL.text = TEXT
        
        UIView.animate(withDuration: TIME, delay: TIME) {
            BG.addSubview(LABEL); LABEL.alpha = 1.0
        } completion: { _ in
            LABEL.alpha = 0.0; LABEL.removeFromSuperview()
        }
    }
}

@discardableResult func S_INDICATOR(_ view: UIView, text: String? = "로드 중...", animated: Bool? = true) -> UIActivityIndicatorView {
    
    let LOADING_V = UIVisualEffectView(frame: view.frame)
    LOADING_V.center = view.center
    LOADING_V.effect = UIBlurEffect(style: .regular)
    LOADING_V.alpha = 0.0
    LOADING_V.tag = 3782904084
    LOADING_V.isUserInteractionEnabled = false
     
    let INDICATOR_V = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    INDICATOR_V.center = CGPoint(x: LOADING_V.frame.size.width/2, y: LOADING_V.frame.size.height/2)
    
    let MESSAGE_L = UILabel(frame: CGRect(x: 0, y: 0, width: LOADING_V.frame.size.width, height: 25))
    MESSAGE_L.center = CGPoint(x: LOADING_V.frame.size.width/2, y: LOADING_V.frame.size.height/2+25)
    MESSAGE_L.font = UIFont(name: "GmarketSansMedium", size: 14)
    MESSAGE_L.textAlignment = .center
    MESSAGE_L.text = text
    
    if animated! {
        LOADING_V.contentView.addSubview(INDICATOR_V); LOADING_V.contentView.addSubview(MESSAGE_L); view.addSubview(LOADING_V); INDICATOR_V.startAnimating(); UIView.animate(withDuration: 0.3) { LOADING_V.alpha = 1.0 }
    } else {
        for SUBVIEW in view.subviews { if SUBVIEW.tag == 3782904084 { UIView.animate(withDuration: 0.3) { LOADING_V.alpha = 0.0 } completion: { _ in SUBVIEW.removeFromSuperview() } } }
    }
    
    return INDICATOR_V
}

