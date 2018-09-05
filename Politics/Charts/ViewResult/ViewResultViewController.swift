//
//  ViewResultViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/12.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import PageMenu
import Firebase
import SwiftDate
class ViewResultViewController: UIViewController {
    var pageMenu : CAPSPageMenu?
    var mainQuestionArray = [String:[Qusetions]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var dateArray = ["Weekly"]
        print(nowDate(num: 0))       
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        print(statusBarHeight)
        print(navBarHeight!)
        let navheight = statusBarHeight + navBarHeight!
        var controllers : [UIViewController] = []
        let vc0 = UIStoryboard(name: "Chart", bundle: nil).instantiateViewController(withIdentifier: "WeeklyViewController")
        let vc = UIStoryboard(name: "Chart", bundle: nil).instantiateViewController(withIdentifier: "TodayResultViewController")
        let vc1 = UIStoryboard(name: "Chart", bundle: nil).instantiateViewController(withIdentifier: "OneDayAgoResultViewController")
        let vc2 = UIStoryboard(name: "Chart", bundle: nil).instantiateViewController(withIdentifier: "TwoDaysAgoResultViewController")
        let vc3 = UIStoryboard(name: "Chart", bundle: nil).instantiateViewController(withIdentifier: "ThreeDaysAgoResultViewController")
        let vc4 = UIStoryboard(name: "Chart", bundle: nil).instantiateViewController(withIdentifier: "FourDaysAgoResultViewController")
        let vc5 = UIStoryboard(name: "Chart", bundle: nil).instantiateViewController(withIdentifier: "FiveDaysAgoResultViewController")
        let vc6 = UIStoryboard(name: "Chart", bundle: nil).instantiateViewController(withIdentifier: "SixDaysAgoResultViewController")
        for i in 0..<7{
            var date = Date()
            date = date - i.days
            dateArray.append("\(date.string(custom: "MM/dd"))")
        }
        print(dateArray)
        vc0.title = dateArray[0]
        vc.title = dateArray[1]
        vc1.title = dateArray[2]
        vc2.title = dateArray[3]
        vc3.title = dateArray[4]
        vc4.title = dateArray[5]
        vc5.title = dateArray[6]
        vc6.title = dateArray[7]
        controllers.append(vc0)
        controllers.append(vc)
        controllers.append(vc1)
        controllers.append(vc2)
        controllers.append(vc3)
        controllers.append(vc4)
        controllers.append(vc5)
        controllers.append(vc6)
        let params: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
            .viewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .selectionIndicatorColor(UIColor.orange),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .menuHeight(40.0),
            .menuItemWidth(90.0),
            .centerMenuItems(true),
            .addBottomMenuHairline(true),
            
            ]
        
        pageMenu = CAPSPageMenu(
            viewControllers: controllers,
            frame:           CGRect(x: 0.0, y: navheight, width:  self.view.frame.width, height:  self.view.frame.height),
            pageMenuOptions: params
        )
        self.addChildViewController(self.pageMenu!)
        self.view.addSubview(self.pageMenu!.view)
        self.pageMenu!.didMove(toParentViewController: self)
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
