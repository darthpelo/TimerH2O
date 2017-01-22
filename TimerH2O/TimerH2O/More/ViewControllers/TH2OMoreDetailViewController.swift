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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureWebView()
    }
}

// MARK: - WKNavigationDelegate
extension TH2OMoreDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        NSLog(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("Strat to load")
        SVProgressHUD.show(withTitle: nil)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("finish to load")
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
