//
//  VC_DETAIL3.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/02/02.
//

import UIKit
import WebKit

class VC_DETAIL3: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var TITLE: String = ""
    var LINK: String = ""
    
    @IBOutlet weak var HEADER_L: UILabel!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var WKWEBVIEW: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        HEADER_L.text = TITLE
        
        WKWEBVIEW.scrollView.showsHorizontalScrollIndicator = false
        WKWEBVIEW.scrollView.showsVerticalScrollIndicator = false
        WKWEBVIEW.scrollView.isScrollEnabled = true
        
        if let URL = URL(string: LINK) { WKWEBVIEW.load(URLRequest(url: URL)) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WKWEBVIEW.uiDelegate = self; WKWEBVIEW.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension VC_DETAIL3: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }; return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        setAlert(title: "", body: message, style: .alert, time: 1); completionHandler()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if TITLE == "후기 작성하기" {
            
            webView.evaluateJavaScript("document.documentElement.outerHTML") { (html: Any?, error: Error?) in
                if let htmlString = html as? String {
                    print(htmlString)
                }
            }
            
            WKWEBVIEW.evaluateJavaScript("document.getElementsByClassName('ArticleWriteFormSubject').getElementsByTagName('textarea').innerHTML = 'Test';") { result, error in
                print(result as Any, error as Any)
            }
            
//            WKWEBVIEW.evaluateJavaScript("document.getElementById('SE-b5a5efa8-7730-40dd-9567-afb1f95e1984').value = '테스트';") { result, error in
//                print(result as Any)
//            }
//            let webViewConfig = webView.configuration
//            // Set up a user script that injects JavaScript code into the webpage.
//            let script = WKUserScript(source: "document.getElementById('SE-b5a5efa8-7730-40dd-9567-afb1f95e1984').value = 'Hello, world!'", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//            webViewConfig.userContentController.addUserScript(script)
//            // Optionally, set up a message handler to receive messages from the webpage.
//            webViewConfig.userContentController.add(self, name: "myMessageHandler")
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "myMessageHandler" {
            print("Received message from webpage: \(message.body)")
        }
    }
}
