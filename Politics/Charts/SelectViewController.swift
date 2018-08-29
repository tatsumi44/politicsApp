//
//  SelectViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/13.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        print(statusBarHeight)
        print(navBarHeight!)
        let navheight = statusBarHeight + navBarHeight!
        let tabheight = tabBarController?.tabBar.frame.size.height
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.navBarHeight = navheight
        appDelegate.tabheight = tabheight
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
