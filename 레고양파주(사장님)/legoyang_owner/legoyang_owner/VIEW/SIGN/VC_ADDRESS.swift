//
//  VC_ADDRESS.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2023/02/02.
//

import UIKit
import WebKit

class VC_ADDRESS: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var LINK: String = ""
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var WKWEBVIEW: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        WKWEBVIEW.scrollView.showsHorizontalScrollIndicator = false
        WKWEBVIEW.scrollView.showsVerticalScrollIndicator = false
        WKWEBVIEW.scrollView.isScrollEnabled = true
        
        guard let LINK = URL(string: "https://kasroid.github.io/Kakao-Postcode/"), let WKWEBVIEW = WKWEBVIEW else { return }
        WKWEBVIEW.load(URLRequest(url: LINK))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WKWEBVIEW.uiDelegate = self; WKWEBVIEW.navigationDelegate = self
        WKWEBVIEW.configuration.userContentController.add(self, name: "callBackHandler")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
    }
}

extension VC_ADDRESS: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let DICT = message.body as? [String: Any]
        
        if let BVC1 = UIViewController.VC_SIGNUP_DEL {
            BVC1.BS_ADDRESS_TF1.text = DICT?["roadAddress"] as? String ?? ""
        }
        if let BVC2 = UIViewController.VC3_STORE_EDIT_DEL {
            BVC2.ADDRESS = DICT?["roadAddress"] as? String ?? ""
            BVC2.ADDRESS_TF.text = DICT?["roadAddress"] as? String ?? ""
        }; navigationController?.popViewController(animated: true)
    }
}
