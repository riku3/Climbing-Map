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
    var projectName: String!
    var rockName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: view.frame)
        view.addSubview(webView)
        
        var urlString = ""
        if rockName == "無題" {
            urlString = "https://www.youtube.com/results?search_query=\(projectName!)"
        } else if projectName == "無題" {
            urlString = "https://www.youtube.com/results?search_query=\(rockName!)"
        } else {
            urlString = "https://www.youtube.com/results?search_query=\(rockName!)+\(projectName!)"
        }
        let encodeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let url = URL(string: encodeUrlString!) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        createBackButton()
    }
    
    private func createBackButton() {
        let backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: self.view.frame.width-80, y: self.view.frame.height-180, width: 50, height: 50)
        backBtn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backBtn.tintColor = UIColor.black
        backBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        backBtn.layer.cornerRadius = 25
        backBtn.layer.shadowColor = UIColor.black.cgColor
        backBtn.layer.shadowRadius = 1
        backBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        backBtn.layer.shadowOpacity = 0.7

        backBtn.addTarget(self,action: #selector(WKWebviewController.buttonTapped(_:)),for: .touchUpInside)
        view.addSubview(backBtn)
    }
    
    @objc func buttonTapped(_ sender : Any) {
        if webView.canGoBack {
            webView.goBack()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
