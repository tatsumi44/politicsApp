//
//  ThreeDaysAgoViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/24.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class ThreeDaysAgoViewController: TodayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dateNum = 3
        date = nowDate(num: 3)
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
        if appDelegate.dateNum == 3{
             print(mainNewsArray.count)
            mainNewsArray[detailnum].commentCount = appDelegate.responseNum
            mainNewsArray[detailnum].likeCount = appDelegate.goodNum
            mainNewsArray[detailnum].disLikeCount = appDelegate.badNum
            let row = NSIndexPath(row: detailnum, section: 0)
            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
            detailnum = nil
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
