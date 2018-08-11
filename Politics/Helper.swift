//
//  Helper.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/09.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftDate
extension UIViewController{
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func nowDate(num:Int) -> String {
        var date = Date()
        date = date - num.days
        return date.string(custom: "YYYY_MM_dd")
    }
    
    
}
extension  UIResponder{
    func tabSegue()-> UITabBarController{
        var viewControllers: [UIViewController] = []
        let firstSB = UIStoryboard(name: "Chart", bundle: nil)
        let firstVC = firstSB.instantiateInitialViewController()! as UIViewController
        firstVC.tabBarItem = UITabBarItem(title: "世論調査", image: UIImage(named:"chart"), tag: 1)
        viewControllers.append(firstVC)
        
        // 2ページ目になるViewController
        let secondSB = UIStoryboard(name: "SNS", bundle: nil)
        let secondVC = secondSB.instantiateInitialViewController()! as UIViewController
        secondVC.tabBarItem = UITabBarItem(title: "語り場", image: UIImage(named:"User"), tag: 2)
        viewControllers.append(secondVC)
        
        // 3ページ目になるViewController
        let thirdSB = UIStoryboard(name: "News", bundle: nil)
        let thirdVC = thirdSB.instantiateInitialViewController()! as UIViewController
        thirdVC.tabBarItem = UITabBarItem(title: "ニュース", image: UIImage(named:"news"), tag: 3)
        viewControllers.append(thirdVC)
        let tabBarController = UITabBarController()
        tabBarController.tabBar.unselectedItemTintColor = UIColor.orange
        tabBarController.setViewControllers(viewControllers, animated: false)
        return tabBarController
    }
}

class Userdata: Object{
    @objc dynamic var name = ""
    @objc dynamic var age  = ""
    @objc dynamic var place  = ""
    @objc dynamic var sex  = ""
    @objc dynamic var userID  = ""
}

class Qusetions{
    var array:[String]!
    var title:String!
    var questionID:String!
    init(array:[String],title:String,questionID:String) {
        self.array = array
        self.title = title
        self.questionID = questionID
    }
}
class ChartResult{
    var title:String!
    var num1:Int!
    var percent:Double
    init(title:String,num1:Int,percent:Double) {
        self.title = title
        self.num1 = num1
        self.percent = percent
    }
}

