//
//  TH2OAboutViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 05/01/17.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import WebKit
import UIKit

class TH2OAboutViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webViewContainer: UIView!
    
    var webView: WKWebView
    
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRect.zero)
        super.init(coder: aDecoder)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.webView.frame = self.webViewContainer.frame
        self.webViewContainer.addSubview(self.webView)
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        if let url = URL.init(string: "http://www.alessioroberto.it/timerh2o/timerh2o.html") {
            webView.navigationDelegate = self
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
}
