//
//  OneDayAgoResultViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/12.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class OneDayAgoResultViewController: TodayResultViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        day = nowDate(num: 1)
//        questionArray = mainQuestionArray[day]!
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
