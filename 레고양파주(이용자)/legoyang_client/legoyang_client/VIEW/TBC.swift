//
//  TBC.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/18.
//

import UIKit
import Nuke

class TBC: UITabBarController {
    
    override func loadView() {
        super.loadView()
        
        UIViewController.TBC_DEL = self
        
        ImageCache.shared.removeAll()
        
        UserDefaults.standard.setValue(false, forKey: "first")
        
        if #available(iOS 13.0, *) {
            let APPEARANCE = UITabBarAppearance()
            APPEARANCE.backgroundEffect = .none
            APPEARANCE.stackedLayoutAppearance.normal.iconColor = .clear
            APPEARANCE.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.darkGray, .font: UIFont.boldSystemFont(ofSize: 10)]
            APPEARANCE.stackedLayoutAppearance.selected.iconColor = .clear
            APPEARANCE.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.darkGray, .font: UIFont.boldSystemFont(ofSize: 10)]
            tabBar.standardAppearance = APPEARANCE
        }
        
        let EFFECT = UIVisualEffectView()
        EFFECT.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: view.frame.maxY)
        EFFECT.effect = UIBlurEffect(style: .light)
        tabBar.insertSubview(EFFECT, at: 0)
        
        let LINE = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5))
        LINE.backgroundColor = UIColor(white: 0, alpha: 0.2)
        tabBar.insertSubview(LINE, at: 1)
        
        for i in 0 ..< tabBar.items!.count {
            
            if i != 1 {
                tabBar.items![i].image = UIImage(named: "tab\(i)")?.withRenderingMode(.alwaysOriginal)
            } else {
                let IMAGE = UIImageView(frame: CGRect(x: tabBar.frame.width/5/2*3-18, y: 1, width: 36, height: 36))
                IMAGE.image = UIImage.gifImageWithName("tab1")?.withRenderingMode(.alwaysOriginal)
                tabBar.addSubview(IMAGE)
            }
            
            tabBar.items![i].title = ["지도", "가게찾기", "", "공동구매", "더보기"][i]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 2
        
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}

extension TBC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UIImpactFeedbackGenerator().impactOccurred()
    }
}
