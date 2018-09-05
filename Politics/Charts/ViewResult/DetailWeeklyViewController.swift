//
//  DetailWeeklyViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/06.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class DetailWeeklyViewController: UIViewController {
    var maincontentsArray = [mainWeeklyData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(maincontentsArray.filter({$0.date == nowDate(num: 4)}))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
