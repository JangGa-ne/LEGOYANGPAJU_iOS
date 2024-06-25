//
//  VC_SIGNCHECK.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2023/01/02.
//

import UIKit
import WebKit
import Bootpay

class VC_SIGNCHECK: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var TITLE: String = ""
    let WEBVIEW = BootpayWebView()
    
    @IBOutlet weak var HEADER_L: UILabel!
    @IBAction func BACK_B(_ sender: UIButton) { guard let _ = navigationController?.popViewController(animated: true) else { dismiss(animated: true, completion: nil); return } }
    @IBOutlet weak var LINE_V: UIView!
    
    @IBOutlet weak var BOOTPAY_V: UIView!
    
    override func loadView() {
        super.loadView()
        
        HEADER_L.text = TITLE
        
        BOOTPAY_V.addSubview(WEBVIEW)
        
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { WKWebsiteDataStore.default().removeData(ofTypes: $0.dataTypes, for: [$0], completionHandler: {}) }
        }
        
        NSLayoutConstraint.activate([
            WEBVIEW.webview.topAnchor.constraint(equalTo: BOOTPAY_V.topAnchor),
            WEBVIEW.webview.leadingAnchor.constraint(equalTo: BOOTPAY_V.leadingAnchor),
            WEBVIEW.webview.trailingAnchor.constraint(equalTo: BOOTPAY_V.trailingAnchor),
            WEBVIEW.webview.bottomAnchor.constraint(equalTo: BOOTPAY_V.bottomAnchor)
        ]); WEBVIEW.webview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WEBVIEW.startBootpay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Bootpay.shared.debounceClose()
    }
}
