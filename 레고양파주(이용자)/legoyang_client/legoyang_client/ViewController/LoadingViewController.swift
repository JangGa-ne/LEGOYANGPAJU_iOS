//
//  LoadingViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/03.
//

import UIKit

class LoadingViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.LoadingViewControllerDelegate = self
        
        loadingData()
    }
}
