//
//  ViewController.swift
//  webkit_browser_engine
//
//  Created by James on 3/13/20.
//  Copyright © 2020 James Syvertsen. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    private var webView = WKWebView()

    private let urlString = "https://www.youtube.com/channel/UCpX3PTHzP7FApJjBlGfU5Mg"

    private let pageNotFound = "<!DOCTYPE html><html><head></head><body><b>page not found</b></body></html>"
    
    override func loadView() {

        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self as? WKUIDelegate
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // form URL object from string
        guard let urlPage = URL(string: urlString) else { return }
        
        // form URLRequest using URL object
        let urlRequest = URLRequest(url: urlPage)
        
        // just an example of handling an optional urlRequest object
        guard urlRequest != nil else {
            webView.loadHTMLString(pageNotFound, baseURL: nil)
            return
        }
        
        // load URLRequest into webkit browser engine
        webView.load(urlRequest)
    }
}

