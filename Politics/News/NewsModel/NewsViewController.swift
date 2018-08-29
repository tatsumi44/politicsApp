//
//  NewsViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/24.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import WebKit
class NewsViewController: UIViewController,WKNavigationDelegate,WKUIDelegate{
    
    
    @IBOutlet weak var webView: WKWebView!
    
    var url:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        let viewURL = URL(string:url)
        let request = NSURLRequest(url: viewURL!)
        webView.load(request as URLRequest)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
