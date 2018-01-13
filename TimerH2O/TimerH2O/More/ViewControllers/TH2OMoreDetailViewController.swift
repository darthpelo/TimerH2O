//
//  TH2OMoreDetailViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 05/01/17.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import WebKit
import UIKit
import SVProgressHUD

final class TH2OMoreDetailViewController: UIViewController, Configurable {

    @IBOutlet weak var webViewContainer: UIView!
    
    let webView = WKWebView(frame: CGRect.zero)
    
    var type: MoreDetail?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureWebView()
    }
}

// MARK: - WKNavigationDelegate
extension TH2OMoreDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show(withTitle: nil)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
