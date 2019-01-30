//
//  NewsMainViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/24.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import PageMenu
import SwiftDate
import FirebaseUI
import RealmSwift
class NewsMainViewController: UIViewController {
    let realm = try! Realm()
    var pageMenu : CAPSPageMenu?
    var dateArray = [String]()
    var navBarHeight:CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        iconCreate()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "small_icon.png"))
        for i in 0..<7{
            let date = nowDate(num: i)
            dateArray.append(date)
        }
        
        print(dateArray)
        var controllers : [UIViewController] = []
        let vc = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "TodayViewController")
        let vc1 = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "OneDayAgoViewController")
        let vc2 = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "TwoDaysAgoViewController")
        let vc3 = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "ThreeDaysAgoViewController")
        let vc4 = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "FourDaysAgoViewController")
        let vc5 = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "FiveDaysAgoViewController")
        let vc6 = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "SixDaysAgoViewController")
        
        vc.title = dateArray[0]
        vc1.title = dateArray[1]
        vc2.title = dateArray[2]
        vc3.title = dateArray[3]
        vc4.title = dateArray[4]
        vc5.title = dateArray[5]
        vc6.title = dateArray[6]
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
        
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.navBarHeight = appDelegate.navBarHeight
        let tabheight = appDelegate.tabheight
        
        pageMenu = CAPSPageMenu(
            viewControllers: controllers,
            frame:           CGRect(x: 0.0, y: navBarHeight, width:  self.view.frame.width, height:  self.view.frame.height - navBarHeight - tabheight!),
            pageMenuOptions: params
        )
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        pageMenu!.didMove(toParentViewController: self)

        // Do any additional setup after loading the view.
    }
    func iconCreate() {
        print("呼ばれてるよ")
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let item = UIBarButtonItem(customView: view1)
        self.navigationItem.leftBarButtonItem = item
        let iconImageView = UIImageView(frame: CGRect(x: 2.5, y: 5, width: 35, height: 35))
        iconImageView.layer.cornerRadius = 35/2
        iconImageView.layer.masksToBounds = true
        let iconBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        //        iconBtn.backgroundColor = UIColor.red
        iconBtn.addTarget(self, action: #selector(VoteListViewController.iconTap(_:)), for: .touchUpInside)
        view1.addSubview(iconBtn)
        let user = realm.objects(Userdata.self)[0]
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child("image/profile/\(user.userID).jpg")
        iconImageView.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        view1.addSubview(iconImageView)
    }
    
    @objc func iconTap(_ sender: UIButton){
        print("iconTap")
        performSegue(withIdentifier: "goSetting", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}
