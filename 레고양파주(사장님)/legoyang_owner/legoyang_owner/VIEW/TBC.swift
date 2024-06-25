//
//  TBC.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/11/15.
//

import UIKit

class TBC: UITabBarController {
    
    override func loadView() {
        super.loadView()
        
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
        EFFECT.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: view.frame.maxY)
        EFFECT.effect = UIBlurEffect(style: .light)
        tabBar.insertSubview(EFFECT, at: 0)
        
        let LINE = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 0.5))
        LINE.backgroundColor = UIColor(white: 0, alpha: 0.2)
        tabBar.insertSubview(LINE, at: 1)
        
        for i in 0 ..< tabBar.items!.count {
            
            if i != 2 {
                tabBar.items![i].image = UIImage(named: "tab\(i).png")?.withRenderingMode(.alwaysOriginal)
            } else {
                tabBar.items![i].image = UIImage(named: CATEGORY_IMAGES[UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeCategory] ?? "")?.withRenderingMode(.alwaysOriginal)
            }
            
            tabBar.items![i].title = ["내 가게", "레고팡팡", "", "가게 수정", "Q&A"][i]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.TabBarControllerDelegate = self
        
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
    }
}

extension TBC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UIImpactFeedbackGenerator().impactOccurred()
    }
}
