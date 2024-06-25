//
//  UpdateViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/05/04.
//

import UIKit
import FirebaseFirestore

class UpdateViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var storeVersionNameLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var newestView: UIView!
    @IBOutlet weak var appVersionNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.isHidden = true
        updateButton.isHidden = true
        updateButton.addTarget(self, action: #selector(self.updateButton(_:)), for: .touchUpInside)
        
        newestView.isHidden = false
        
        loadingData()
    }
    
    func loadingData() {
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            Firestore.firestore().collection("app_lego").document("ios").getDocument { response, error in
                
                guard let response = response else { return }
                
                let dict = response.data() ?? [:]
                
                UIViewController.appDelegate.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
                UIViewController.appDelegate.appBuildCode = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1") ?? 1
                UIViewController.appDelegate.storeVersion = dict["version_name"] as? String ?? ""
                UIViewController.appDelegate.storeBuildCode = Int(dict["version_code"] as? String ?? "") ?? 1
                
                print("version - 앱: \(UIViewController.appDelegate.appVersion)(\(UIViewController.appDelegate.appBuildCode)) / 스토어: \(UIViewController.appDelegate.storeVersion)(\(UIViewController.appDelegate.storeBuildCode))")
                
                DispatchGroup.leave()
            }
        }
        
        DispatchGroup.notify(queue: .main) {
            
            if UIViewController.appDelegate.storeBuildCode > UIViewController.appDelegate.appBuildCode {
                
                self.infoView.isHidden = false
                self.storeVersionNameLabel.text = "iOS \(UIViewController.appDelegate.storeVersion)"
                self.updateButton.isHidden = false
                
                self.newestView.isHidden = true
                
            } else {
                
                self.infoView.isHidden = true
                self.updateButton.isHidden = true
                
                self.newestView.isHidden = false
                self.appVersionNameLabel.text = "iOS \(UIViewController.appDelegate.appVersion)"
            }
        }
    }
    
    @objc func updateButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: UIViewController.appDelegate.AppLegoObject.versionUrl)!) { success in
            if success { exit(0) }
        }
    }
}
