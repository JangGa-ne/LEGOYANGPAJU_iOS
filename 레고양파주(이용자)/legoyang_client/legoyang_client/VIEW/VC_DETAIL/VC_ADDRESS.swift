//
//  VC_ADDRESS.swift
//  legoyang_client
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
        
        setBackSwipeGesture(true)
    }
}

extension VC_ADDRESS: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let DICT = message.body as? [String: Any]
        
        if let BVC = UIViewController.VC_DETAIL4_DEL {
            BVC.ADDRESS_TF1.text = DICT?["roadAddress"] as? String ?? ""
        }; navigationController?.popViewController(animated: true)
    }
}
