//
//  MainTodayViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/26.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class MainTodayViewController: TodayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dateNum = 0
        date = nowDate(num: 0)
        getNews(date: date)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        print("呼ばれてrう1")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.dateNum == 0{
            print(mainNewsArray.count)
//            print(appDelegate.responseNum)
            mainNewsArray[detailnum].commentCount = appDelegate.responseNum
            mainNewsArray[detailnum].likeCount = appDelegate.goodNum
            mainNewsArray[detailnum].disLikeCount = appDelegate.badNum
            let row = NSIndexPath(row: detailnum, section: 0)
            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
            backedNum = nil
            appDelegate.responseNum = nil
            appDelegate.goodNum = nil
            appDelegate.badNum = nil
            appDelegate.dateNum = nil
        }else{
            print("nilだyo")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
            mainTable.frame = CGRect(x: 0, y: -40, width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
