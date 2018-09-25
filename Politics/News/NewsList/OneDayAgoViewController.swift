//
//  OneDayAgoViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/24.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class OneDayAgoViewController: TodayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dateNum = 1
        date = nowDate(num: 1)
        getNews(date: date)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("へいへい")
        print(date)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        print("呼ばれてrう1")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.dateNum == 1{
            
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

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
