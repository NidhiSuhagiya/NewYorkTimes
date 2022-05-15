//
//  WebViewVC.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newsBlogUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.loadUrl()
    }
    
    private func setUI() {
        self.navigationItem.title = "The New York Times"
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.webView.navigationDelegate = self
    }
    
    private func loadUrl() {
        guard let webUrl = newsBlogUrl, webUrl.count > 0 else { return }
        webView.load(URLRequest(url: URL(string: webUrl)!))
    }
}

//#MARK: WKNavigation delegate 
extension WebViewVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start loading")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finish loading")
        self.activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed to load url: \(error.localizedDescription)")
        self.activityIndicator.stopAnimating()
    }
}

