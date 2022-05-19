//
//  PrivacyPolicyViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/05/17.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var privacyPolicyWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: privacyPolicyURL)
        let myRequest = URLRequest(url: myURL!)
        privacyPolicyWebView.load(myRequest)
    }
    
    private var privacyPolicyURL: String {
        if Locale.current.languageCode == "ko" {
            return "https://hyper-stealer-69c.notion.site/b83a29f7c40445c1910e49c9dfd8792c"
        } else {
            return "https://hyper-stealer-69c.notion.site/Privacy-Policy-a4fd70c8d3874f068afe57a28b5fea51"
        }
    }
    
}
