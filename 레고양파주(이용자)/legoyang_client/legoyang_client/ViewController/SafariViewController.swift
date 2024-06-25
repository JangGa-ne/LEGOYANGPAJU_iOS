//
//  SafariViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/10.
//

import UIKit
import WebKit
import Bootpay
import SwiftSoup

class SafariViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var bootpay: Bool = false
    var agreement: Bool = false
    var number: String = ""
    
    var titleName: String = ""
    var linkUrl: String = ""
    var storeName: String = ""
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.SafariViewControllerDelegate = self
        
        titleLabel.text = titleName
        
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.isScrollEnabled = true
        
        if bootpay {
            
            let bootpayWebView = BootpayWebView()
            
            webView.addSubview(bootpayWebView)
            
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach { WKWebsiteDataStore.default().removeData(ofTypes: $0.dataTypes, for: [$0], completionHandler: {}) }
            }
            
            NSLayoutConstraint.activate([
                bootpayWebView.webview.topAnchor.constraint(equalTo: webView.topAnchor),
                bootpayWebView.webview.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
                bootpayWebView.webview.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
                bootpayWebView.webview.bottomAnchor.constraint(equalTo: webView.bottomAnchor)
            ]); bootpayWebView.webview.translatesAutoresizingMaskIntoConstraints = false
            
            bootpayWebView.startBootpay()
            
        } else if agreement, let koreanUrl = URL(string: linkUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!) {
            webView.load(URLRequest(url: koreanUrl))
        } else {
            
            if let linkUrl = URL(string: linkUrl) { webView.load(URLRequest(url: linkUrl)) }
            
            webView.uiDelegate = self; webView.navigationDelegate = self
            webView.configuration.userContentController.add(self, name: "callBackHandler")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(!bootpay)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Bootpay.shared.debounceClose()
    }
}

extension SafariViewController: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
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
        
        if titleName == "후기 작성하기" {
            
            let DispatchGroup = DispatchGroup()
            
            DispatchGroup.enter()
            DispatchQueue.global().async {
                
                let script_1 =
                """
                    const textareaElements = document.querySelectorAll('textarea');
                    const textareaElement = textareaElements[0];
                    for (let i = 0; i < textareaElements.length; i++) {
                        textareaElements[i].blur();
                    }
                    setTimeout(() => {
                        textareaElement.focus();
                        textareaElement.value = '\(self.storeName)';
                        textareaElement.dispatchEvent(new Event('input', { bubbles: true }));
                    }, 100);
                """
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    webView.evaluateJavaScript(script_1) { result, error in
                        if let error = error {
                            print("JavaScript 실행 중 에러 발생: \(error)")
                        } else {
                            DispatchGroup.leave()
                        }
                    }
                }
            }
            
            DispatchGroup.enter()
            DispatchQueue.global().async {
                
                let script_2 =
                """
                    javascript: (
                        function() {
                            var elements = document.getElementsByClassName('se-place-toolbar-button');
                            for (var i = 0; i < elements.length; i++) {
                                elements[i].click();
                            }
                        }
                    )()
                """
                
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    webView.evaluateJavaScript(script_2) { result, error in
                        if let error = error {
                            print("JavaScript 실행 중 에러 발생: \(error)")
                        } else {
                            DispatchGroup.leave()
                        }
                    }
                }
            }
            
//            DispatchGroup.enter()
//            DispatchQueue.global().async {
//
//                let script_3 =
//                """
//                    javascript: (
//                        function() {
//                            var input = document.getElementsByClassName('react-autosuggest__input')[0];
//                            input.value = '\(self.storeName)';
//                            setTimeout(
//                                function() {
//                                    input.dispatchEvent(new Event('input', { bubbles: true }));
//                                }, 1000
//                            )
//                            setTimeout(
//                                function() {
//                                    var container = document.getElementsByClassName('react-autosuggest__container')[0];
//                                    var resultList = container.getElementsByClassName('react-autosuggest__suggestions-list');
//                                    if (resultList.length > 0) { resultList[0].focus(); }
//                                }, 2000
//                            )
//                        }
//                    )()
//                """
//
//                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//                    webView.evaluateJavaScript(script_3) { result, error in
//                        if let error = error {
//                            print("JavaScript 실행 중 에러 발생: \(error)")
//                        } else {
//                            DispatchGroup.leave()
//                        }
//                    }
//                }
//            }
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let dict = message.body as? [String: Any] ?? [:]
        
        if titleName == "주소 검색" {
            
            navigationController?.popViewController(animated: true)
            
            if let refresh_1 = UIViewController.OrderViewControllerDelegate {
                refresh_1.address = dict["roadAddress"] as? String ?? ""
                refresh_1.addressTextfield_1.text = dict["roadAddress"] as? String ?? ""
            }
        }
    }
}
