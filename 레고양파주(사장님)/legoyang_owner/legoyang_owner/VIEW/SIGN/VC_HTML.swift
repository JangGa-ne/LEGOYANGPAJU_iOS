//
//  VC_HTML.swift
//  legoyang
//
//  Created by 장 제현 on 2022/10/10.
//

import UIKit
import WebKit

class VC_HTML: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var TITLE: String = ""
    var POSITION: Int = 0
    
    @IBOutlet weak var NAVI_L: UILabel!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var WKWEBVIEW: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        NAVI_L.text = TITLE
        
        WKWEBVIEW.scrollView.showsHorizontalScrollIndicator = false
        WKWEBVIEW.scrollView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let HTML_PATH = Bundle.main.path(forResource: "terms\(IDX)", ofType: "html")
//        var HTML_STIRNG: String = ""
//        do { HTML_STIRNG = try String(contentsOfFile: HTML_PATH!, encoding: .utf8) } catch { }
//        let HTML_URL = URL(fileURLWithPath: HTML_PATH!)
//        WKWEBVIEW.loadHTMLString(HTML_STIRNG, baseURL: HTML_URL)
        
        let URLS: [Int: String] = [
            1: "https://sites.google.com/view/legoyangpaju-privacy",
            2: "https://sites.google.com/view/legoyangpaju-term",
            3: "https://sites.google.com/view/legoyangpaju-marketing",
            4: "https://sites.google.com/view/legoyangpaju-marketinfo",
            5: "https://sites.google.com/view/legoyangpaju-termsofservice",
        ]
        
        if let KOREAN_URL = URL(string: URLS[POSITION]!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!) { WKWEBVIEW.load(URLRequest(url: KOREAN_URL)) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(true)
    }
}
