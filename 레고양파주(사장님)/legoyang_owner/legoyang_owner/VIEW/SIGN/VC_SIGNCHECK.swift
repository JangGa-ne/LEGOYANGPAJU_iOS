//
//  VC_SIGNCHECK.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2023/01/02.
//

import UIKit
import Bootpay

class VC_SIGNCHECK: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    let WEBVIEW = BootpayWebView()
    
    @IBOutlet weak var NAVI_L: UILabel!
    @IBAction func BACK_B(_ sender: UIButton) { guard let _ = navigationController?.popViewController(animated: true) else { dismiss(animated: true, completion: nil); return } }
    @IBOutlet weak var LINE_V: UIView!
    
    @IBOutlet weak var BOOTPAY_V: UIView!
    
    override func loadView() {
        super.loadView()
        
//        WEBVIEW.frame = BOOTPAY_V.bounds
        WEBVIEW.webview.frame = BOOTPAY_V.bounds
        BOOTPAY_V.addSubview(WEBVIEW)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WEBVIEW.startBootpay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Bootpay.shared.debounceClose()
    }
}
