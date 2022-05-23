//
//  PrivacyPolicyViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/05/17.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var privacyPolicyWebView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        privacyPolicyWebView.navigationDelegate = self
        let myURL = URL(string: privacyPolicyURL)
        let myRequest = URLRequest(url: myURL!)
        privacyPolicyWebView.load(myRequest)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Dis appear")
        privacyPolicyWebView.stopLoading()
    }
  
    private var privacyPolicyURL: String {
        if Locale.current.languageCode == "ko" {
            return "https://hyper-stealer-69c.notion.site/b83a29f7c40445c1910e49c9dfd8792c"
        } else {
            return "https://hyper-stealer-69c.notion.site/Privacy-Policy-a4fd70c8d3874f068afe57a28b5fea51"
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
}
