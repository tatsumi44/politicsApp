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
    
    @objc func  showingKeybord(notification: Notification) {
        if let keybordHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height{
            self.view.frame.origin.y = -keybordHeight
        }
    }
    
    @objc func hidingKeyboard(){
        self.view.frame.origin.y = 0
    }
    
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
    
    func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        _ = Calendar(identifier: .gregorian) // グレゴリオ歴
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
    
    func newsurlPath(newsURL:String)->String{
    return newsURL.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "")
    }
    
    
    
    struct PostDetail {
        var title:String!
        var contents:String!
        var tagArray:[String:Int64]!
        var uid:String!
        var username:String!
        var url:String!
        var date:NSDate!
        init(title:String,contents:String,tagArray:[String:Int64],uid:String,username:String,url:String,date:NSDate) {
            self.title = title
            self.contents = contents
            self.tagArray = tagArray
            self.uid = uid
            self.username = username
            self.url = url
            self.date = date
        }
    }
    struct MiddleGetDtail {
        var num:Int!
        var title:String!
        var contents:String!
        var tagArray:[String:Int64]!
        var uid:String!
        var username:String!
        var docID:String!
        var url:String!
        var date:NSDate!
        init(num:Int,title:String,contents:String,tagArray:[String:Int64],uid:String,username:String,docID:String,url:String,date:NSDate) {
            self.num = num
            self.title = title
            self.contents = contents
            self.tagArray = tagArray
            self.uid = uid
            self.username = username
            self.docID = docID
            self.url = url
            self.date = date
        }
    }
    
    struct GetDetail {
        var num: Int!
        var title:String!
        var contents:String!
        var tagArray:[String:Int64]!
        var uid:String!
        var username:String!
        var docID:String!
        var url:String!
        var likeCount:Int!
        var disLikeCount:Int!
        var commentCount:Int!
        var date:NSDate!
        init(num:Int,title:String,contents:String,tagArray:[String:Int64],uid:String,username:String,docID:String,url:String,likeCount:Int,disLikeCount:Int,commentCount:Int,date:NSDate) {
            self.num = num
            self.title = title
            self.contents = contents
            self.tagArray = tagArray
            self.uid = uid
            self.username = username
            self.docID = docID
            self.url = url
            self.likeCount = likeCount
            self.disLikeCount = disLikeCount
            self.commentCount = commentCount
            self.date = date
        }
    }
    struct weeklyData {
        var docID:String!
        var title:String!
        var questions:[String]!
        init(docID:String,title:String,questions:[String]) {
            self.docID = docID
            self.title = title
            self.questions = questions
        }
    }
    
    struct mainWeeklyData {
        var docID:String!
        var title:String!
        var question:String!
        var questionCount:Int!
        var date:String!
        init(docID:String,title:String,question:String,questionCount:Int,date:String) {
            self.docID = docID
            self.title = title
            self.question = question
            self.questionCount = questionCount
            self.date = date
        }
    }
    
    struct GetResponse{
        var docID:String!
        var comment:String!
        var uid:String!
        var name:String!
        var date:NSDate!
        init(docID:String,comment:String,uid:String,name:String,date:NSDate) {
            self.docID = docID
            self.comment = comment
            self.uid = uid
            self.name = name
            self.date = date
        }
    }
    
    struct PostDetailWihtoutTag {
        var title:String!
        var contents:String!
        var date:NSDate!
        init(title:String,contents:String,date:NSDate) {
            self.title = title
            self.contents = contents
            self.date = date
        }
    }
    struct NewsData {
        var num: Int!
        var title:String!
        var url:String!
        var date:String!
        init(num: Int,title:String,url:String,date:String) {
            self.num = num
            self.title = title
            self.url = url
            self.date = date
        }
    }
    struct MainNewsData {
        var num: Int!
        var title:String!
        var url:String!
        var date:String!
        var likeCount:Int!
        var disLikeCount:Int!
        var commentCount:Int!
        init(num: Int,title:String,url:String,likeCount:Int,disLikeCount:Int,commentCount:Int,date:String) {
            self.num = num
            self.title = title
            self.url = url
            self.likeCount = likeCount
            self.disLikeCount = disLikeCount
            self.commentCount = commentCount
            self.date = date
        }
    }
}

class Userdata: Object{
    @objc dynamic var name = ""
    @objc dynamic var age  = ""
    @objc dynamic var place  = ""
    @objc dynamic var sex  = ""
    @objc dynamic var userID  = ""
}

class MyLikes: Object {
    @objc dynamic var documentID = ""
}

class MyDisLikes: Object {
    @objc dynamic var documentID = ""
}

class NewsLikes: Object {
    @objc dynamic var documentID = ""
}


class NewsDisLikes: Object {
    @objc dynamic var documentID = ""
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
    func nowDate(num:Int) -> String {
        var date = Date()
        date = date - num.days
        return date.string(custom: "YYYY_MM_dd")
    }
}


extension NSDate{
    // NSDate -> Int64
    func toInt64() -> Int64{
        return Int64(timeIntervalSince1970 * 1000)
    }
}

extension Int64{
    // Int64 -> NSDate
    func toNSDate() -> NSDate{
        return NSDate(timeIntervalSince1970: Double(self / 1000) + Double(self % 1000)/1000)
        
    }
}






