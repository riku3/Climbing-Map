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
    var isYoutube: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: view.frame)
        view.addSubview(webView)
        

        if isYoutube {
            let urlString: String = "https://www.youtube.com/results?search_query=" + String(describing: name!)
            let encodeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

            print(encodeUrlString)
            if let url = URL(string: encodeUrlString!) {
                print(url)
                let request = URLRequest(url: url)
                webView.load(request)
            }
            print("not")
        } else {
            let request = URLRequest(url: URL(string: "https://www.instagram.com/explore/tags/\(String(describing: name!))/?hl=ja")!)
            webView.load(request)
        }
//        webView.load(request)
    }
}
