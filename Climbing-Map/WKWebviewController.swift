//
//  WKWebviewController.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/26.
//

import Foundation
import UIKit
import WebKit

class WKWebviewController: UIViewController {

    var webView: WKWebView!
    var name: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: view.frame)
        view.addSubview(webView)

        let urlString = "https://www.youtube.com/results?search_query=" + name
        let encodeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let url = URL(string: encodeUrlString!) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
