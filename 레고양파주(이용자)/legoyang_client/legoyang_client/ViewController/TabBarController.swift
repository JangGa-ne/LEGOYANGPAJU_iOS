//
//  TabBarController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/05.
//

import UIKit
import Nuke

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.TabBarControllerDelegate = self
        
        UserDefaults.standard.setValue(false, forKey: "first")
        
//        ImageCache.shared.removeAll()
        
        selectedIndex = 2
        delegate = self
        
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = .none
            appearance.stackedLayoutAppearance.normal.iconColor = .clear
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 10)]
            appearance.stackedLayoutAppearance.selected.iconColor = .clear
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.H_00529C, .font: UIFont.boldSystemFont(ofSize: 10)]
            tabBar.standardAppearance = appearance
        }
        
        let backgroundView = UIVisualEffectView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: view.frame.maxY)
        backgroundView.effect = UIBlurEffect(style: .light)
        backgroundView.backgroundColor = .white
        tabBar.insertSubview(backgroundView, at: 0)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5))
        lineView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        tabBar.insertSubview(lineView, at: 1)
        
        for i in 0 ..< tabBar.items!.count {
            
            if i != 2 {
                tabBar.items![i].image = UIImage(named: "tab\(i+5)")?.withRenderingMode(.alwaysOriginal)
            } else {
                let itemImageView = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width/2-25, y: -20, width: 50, height: 50))
                itemImageView.layer.cornerRadius = 25
                itemImageView.clipsToBounds = true
                itemImageView.image = UIImage(named: "logo3")
                tabBar.addSubview(itemImageView)
            }
            
            tabBar.items![i].title = ["주변 탐색", "매장 찾기", "홈", "공동 구매", "마이페이지"][i]
        }
        
        DispatchQueue.main.async { self.shareLoadingData(); self.pushLoadingData() }
        
        UIViewController.appDelegate.first = false
        
        if (UIViewController.appDelegate.shareType != "default") || (UIViewController.appDelegate.pushUpdate != "default") { return }
    }
    
    func shareLoadingData() {
        
        if UIViewController.appDelegate.shareType == "store" {
            
            let segue = storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
            segue.storeId = UIViewController.appDelegate.shareId
            navigationController?.pushViewController(segue, animated: true)
            
        } else if UIViewController.appDelegate.shareType == "legonggu" {
            
            let segue = storyboard?.instantiateViewController(withIdentifier: "LegongguDetailViewController") as! LegongguDetailViewController
            segue.itemName = UIViewController.appDelegate.shareId
            navigationController?.pushViewController(segue, animated: true)
            
        } else if (UIViewController.appDelegate.shareType == "event") && (UIViewController.appDelegate.shareId == "event_reward") {
            
            if let delegate = UIViewController.EventDetailViewControllerDelegate {
                delegate.navigationController?.popViewController(animated: false)
            }
            
            let segue = storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
            if UIViewController.appDelegate.shareData["inviter_from"] as? String ?? "" == UIViewController.appDelegate.MemberId {
                segue.position = 0
            } else {
                segue.root = true; segue.position = 1
            }
            navigationController?.pushViewController(segue, animated: true)
        }
        
        UIViewController.appDelegate.shareType = "default"
        UIViewController.appDelegate.shareId = ""
        
        if let delegate = UIViewController.TutorialViewControllerDelegate { delegate.dismiss(animated: false, completion: nil) }
    }
    
    func pushLoadingData() {
        
        if (UIViewController.appDelegate.pushUpdate != "default") && (UIViewController.appDelegate.MemberId == "") {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else if UIViewController.appDelegate.pushUpdate == "gonggu" {
            
            let segue = storyboard?.instantiateViewController(withIdentifier: "LegongguViewController") as! LegongguViewController
            segue.detail = true
            navigationController?.pushViewController(segue, animated: true)
            
        } else if UIViewController.appDelegate.pushUpdate == "around" {
            
            let segue = storyboard?.instantiateViewController(withIdentifier: "AroundListViewController") as! AroundListViewController
            segue.category = UIViewController.appDelegate.pushData
            navigationController?.pushViewController(segue, animated: true)
            
        } else if UIViewController.appDelegate.pushUpdate == "coupon" {
            
            let segue = storyboard?.instantiateViewController(withIdentifier: "CouponViewController") as! CouponViewController
            segue.position = 1
            navigationController?.pushViewController(segue, animated: true)
        }
        
        UIViewController.appDelegate.pushUpdate = "default"
        UIViewController.appDelegate.pushData = ""
        
        if let delegate = UIViewController.TutorialViewControllerDelegate { delegate.dismiss(animated: false, completion: nil) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UIImpactFeedbackGenerator().impactOccurred()
    }
}
