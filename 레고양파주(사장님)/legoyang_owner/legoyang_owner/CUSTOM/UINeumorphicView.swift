//
//  UIView_BACK.swift
//  Kkumnamu
//
//  Created by 장 제현 on 2021/10/07.
//

import UIKit

class UINeumorphicView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        SETUP_VIEW()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        SETUP_VIEW()
    }
    
//    @IBInspectable var FRAME: CGRect { didSet { SETUP_VIEW() } }
    @IBInspectable var RADIUS: CGFloat = 10 { didSet { SETUP_VIEW() } }
    
    func SETUP_VIEW() {
        
        backgroundColor = .H_E1E1EB
        layer.cornerRadius = RADIUS
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        SET_SHADOW()
    }
    
    let darkShadow = CALayer()
    let lightShadow = CALayer()
    
    func SET_SHADOW() {
        
        darkShadow.frame = bounds
        darkShadow.cornerRadius = RADIUS
        darkShadow.backgroundColor = UIColor.H_E1E1EB.cgColor
        darkShadow.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        darkShadow.shadowOffset = CGSize(width: 10, height: 10)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = 10
        layer.insertSublayer(darkShadow, at: 0)
        
        lightShadow.frame = bounds
        lightShadow.cornerRadius = RADIUS
        lightShadow.backgroundColor = UIColor.H_E1E1EB.cgColor
        lightShadow.shadowColor = UIColor.white.withAlphaComponent(0.9).cgColor
        lightShadow.shadowOffset = CGSize(width: -5, height: -5)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = 10
        layer.insertSublayer(lightShadow, at: 0)
    }
}

//class UINeumorphicView1: UIControl {
//    
//    fileprivate var thumbView: UIView = { return UIView() }()
//    fileprivate var darkShadow: CALayer = { return CALayer() }()
//    fileprivate var lightShadow: CALayer = { return CALayer() }()
//    
//    @IBInspectable var viewFrame: CGRect = CGRect.zero { didSet { setView() } }
//    @IBInspectable var viewBackgroundColor: UIColor = UIColor.H_E1E1EB { didSet { setView() } }
//    @IBInspectable var viewRadius: CGFloat = 10 { didSet { setView() } }
//    
//    private func resetView() { subviews.forEach { $0.removeFromSuperview() } }
//    
//    func setView() {
//        
//        resetView()
//        
//        thumbView.frame = viewFrame; thumbView.backgroundColor = .H_4E177C; thumbView.layer.cornerRadius = viewRadius
//        
//        darkShadow.frame = viewFrame
//        darkShadow.cornerRadius = viewRadius
//        darkShadow.backgroundColor = UIColor.H_E1E1EB.cgColor
//        darkShadow.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
//        darkShadow.shadowOffset = CGSize(width: 10, height: 10)
//        darkShadow.shadowOpacity = 1
//        darkShadow.shadowRadius = 10
//        thumbView.layer.insertSublayer(darkShadow, at: 0)
//        
//        lightShadow.frame = viewFrame
//        lightShadow.cornerRadius = viewRadius
//        lightShadow.backgroundColor = UIColor.H_E1E1EB.cgColor
//        lightShadow.shadowColor = UIColor.white.withAlphaComponent(0.9).cgColor
//        lightShadow.shadowOffset = CGSize(width: -5, height: -5)
//        lightShadow.shadowOpacity = 1
//        lightShadow.shadowRadius = 10
//        thumbView.layer.insertSublayer(lightShadow, at: 0)
//        
//        addSubview(thumbView)
//    }
//}
