//
//  TH2OThirdPartyViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 05/01/17.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import WebKit
import UIKit

class TH2OThirdPartyViewController: UIViewController, Configurable {

    @IBOutlet weak var webViewContainer: UIView!
    
    let webView = WKWebView(frame: CGRect.zero)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = R.string.localizable.moreAcknowledgements()
        
        configureWebView()
    }
}
// MARK: - WKNavigationDelegate
extension TH2OThirdPartyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        NSLog(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("finish to load")
    }
}
