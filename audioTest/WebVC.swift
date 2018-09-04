//
//  WebVC.swift
//  audioTest
//
//  Created by Taehyeon Han on 2018. 7. 13..
//  Copyright © 2018년 Taehyeon Han. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    @IBOutlet weak var wkWebView: WKWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadHtml()
    }
    
    deinit {
        print("deinit webvc")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func initWebView() {
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        
        contentController.add(self, name: "onCreate")
        contentController.add(self, name: "onStart")
        contentController.add(self, name: "onResume")
        contentController.add(self, name: "onPause")
        contentController.add(self, name: "onStop")
        contentController.add(self, name: "onRestart")
        contentController.add(self, name: "onDestroy")
        contentController.add(self, name: "native_console_log")
        config.userContentController = contentController
        
        config.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = []
        } else {
            // Fallback on earlier versions
            config.mediaPlaybackRequiresUserAction = false
        }
        
        let wv = WKWebView(frame: CGRect.zero, configuration: config)
        wv.scrollView.bounces = false
        wv.uiDelegate = self
        wv.navigationDelegate = self
        wkWebView = wv
    }
    
    private func loadHtml() {
        let url = URL(string: "https://www.naver.com")!
        let requset = URLRequest(url: url)

        if UIApplication.shared.canOpenURL(url) {
            wkWebView.load(requset)
        } else {
            print("error")
        }
    }
    
    private func loadHtmlForResource(fileName: String = "index") {
        do {
            guard let filePath = Bundle.main.path(forResource: fileName, ofType: "html")
                else {
                    // File Error
                    return
            }
            
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            wkWebView?.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
