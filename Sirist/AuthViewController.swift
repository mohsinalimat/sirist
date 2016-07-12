//
//  AuthViewController.swift
//  Sirist
//
//  Created by Rob Reinhardt on 7/8/16.
//  Copyright © 2016 RR. All rights reserved.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKScriptMessageHandler {
    
    // MARK: - View Properties
    
    private var webView: WKWebView?
    
    // MARK: - View Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView = WKWebView()
        let configuration = WKWebViewConfiguration()
            configuration.userContentController.addScriptMessageHandler(self, name: "interOp")

        let authRequest = APIManager.sharedInstance.generateAuthRequest()
        
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        
        if let webView = webView {
            webView.loadRequest(authRequest)
            self.view.addSubview(webView)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AuthViewController.dismiss), name: "savedtoken", object: nil)
    }
    
    // MARK: - Webview Interaction
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let code = message.body
        if let code = code as? String {
            APIManager.sharedInstance.makeAuthTokenExchange(code)
        }
    }
    
    // MARK: - View Cleanups
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
